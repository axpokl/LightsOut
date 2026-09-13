#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import math
import os
import subprocess
import tempfile

import librosa
import numpy as np
import scipy.ndimage as ndi
import scipy.signal as sig
import soundfile as sf


def run(cmd):
    subprocess.run(cmd, check=True)


def odd(value):
    value = max(3, int(value))
    return value if value % 2 else value + 1


def decode_float(input_file, wav_file):
    run([
        "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
        "-i", input_file, "-c:a", "pcm_f32le", wav_file
    ])


def encode_output(input_wav, output_file, volume):
    ext = os.path.splitext(output_file)[1].lower()
    common = [
        "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
        "-i", input_wav, "-af", f"volume={volume:.12f}"
    ]
    if ext == ".flac":
        codec = ["-c:a", "flac", "-compression_level", "8"]
    elif ext == ".mp3":
        codec = ["-c:a", "libmp3lame", "-b:a", "320k"]
    elif ext == ".wav":
        codec = ["-c:a", "pcm_s24le"]
    else:
        raise ValueError("输出格式仅支持 .flac、.mp3 或 .wav")
    run(common + codec + [output_file])


def main():
    parser = argparse.ArgumentParser(
        description="削弱节拍同步的周期性音量起伏，同时保留长期响度趋势。"
    )
    parser.add_argument("input", help="输入音频")
    parser.add_argument("output", help="输出音频：FLAC、MP3 或 WAV")
    parser.add_argument("--bpm", type=float, default=90.0, help="节拍速度，默认 90")
    parser.add_argument("--strength", type=float, default=0.45,
                        help="校正强度；自然版约 0.45，强平滑版约 0.65")
    parser.add_argument("--cut-db", type=float, default=2.0,
                        help="每拍最响处最大衰减 dB，默认 2.0")
    parser.add_argument("--boost-db", type=float, default=3.5,
                        help="每拍最弱处最大提升 dB，默认 3.5")
    parser.add_argument("--target-peak", type=float, default=-0.5,
                        help="输出样本峰值 dBFS，默认 -0.5")
    args = parser.parse_args()

    if args.bpm <= 0:
        raise ValueError("BPM 必须大于 0")
    if not 0 <= args.strength <= 1.5:
        raise ValueError("strength 建议在 0 到 1.5 之间")

    period = 60.0 / args.bpm
    analysis_sr = 12000
    envelope_hop_seconds = 0.01
    envelope_frame_seconds = 0.04
    control_rate = 200.0

    with tempfile.TemporaryDirectory(prefix="periodic_volume_") as temp_dir:
        decoded_wav = os.path.join(temp_dir, "decoded_float.wav")
        corrected_wav = os.path.join(temp_dir, "corrected_float.wav")
        decode_float(args.input, decoded_wav)

        audio, sample_rate = sf.read(decoded_wav, dtype="float32", always_2d=True)
        duration = len(audio) / sample_rate
        mono = np.mean(audio, axis=1)
        if sample_rate != analysis_sr:
            mono = librosa.resample(mono, orig_sr=sample_rate, target_sr=analysis_sr)
        else:
            mono = mono.copy()

        nyquist = analysis_sr / 2
        sos = sig.butter(
            4, [180 / nyquist, 2500 / nyquist],
            btype="bandpass", output="sos"
        )
        mid = sig.sosfiltfilt(sos, mono)

        hop = int(analysis_sr * envelope_hop_seconds)
        frame = int(analysis_sr * envelope_frame_seconds)
        rms = librosa.feature.rms(
            y=mid.astype(np.float32), frame_length=frame,
            hop_length=hop, center=True
        )[0]
        env_time = np.arange(len(rms)) * hop / analysis_sr
        env_db = 20 * np.log10(np.maximum(rms, 1e-8))
        trend = sig.medfilt(env_db, kernel_size=odd(2.0 / envelope_hop_seconds))
        residual = env_db - trend

        bins = 200
        template_mask = (
            (env_time >= min(20.0, duration * 0.10)) &
            (env_time <= max(duration - 20.0, duration * 0.90))
        )
        phase = (env_time[template_mask] % period) / period
        phase_index = np.floor(phase * bins).astype(int) % bins
        template = np.array([
            np.median(residual[template_mask][phase_index == i])
            if np.any(phase_index == i) else 0.0
            for i in range(bins)
        ])
        pad = 12
        template = sig.savgol_filter(
            np.r_[template[-pad:], template, template[:pad]], 25, 3
        )[pad:-pad]
        template -= np.mean(template)
        phase_grid = np.arange(bins) / bins

        beat_centers = []
        coefficients = []
        correlations = []
        levels = []
        beat_count = int(math.ceil(duration / period))
        for beat in range(beat_count):
            start = beat * period
            end = min((beat + 1) * period, duration)
            mask = (env_time >= start) & (env_time < end)
            if np.count_nonzero(mask) < 20:
                continue
            local_phase = (env_time[mask] % period) / period
            template_values = np.interp(
                local_phase, phase_grid, template, period=1.0
            )
            values = residual[mask]
            values = values - np.mean(values)
            template_values = template_values - np.mean(template_values)
            denominator = np.dot(template_values, template_values) + 1e-12
            coefficient = float(np.dot(values, template_values) / denominator)
            if np.std(values) > 1e-8 and np.std(template_values) > 1e-8:
                correlation = float(np.corrcoef(values, template_values)[0, 1])
            else:
                correlation = 0.0
            beat_centers.append((start + end) / 2)
            coefficients.append(coefficient)
            correlations.append(correlation)
            levels.append(float(np.median(env_db[mask])))

        beat_centers = np.asarray(beat_centers)
        coefficients = np.asarray(coefficients)
        correlations = np.nan_to_num(np.asarray(correlations))
        levels = np.asarray(levels)

        correlation_weight = np.clip((correlations - 0.30) / 0.50, 0, 1)
        level_weight = np.clip((levels + 42) / 12, 0, 1)
        adaptive = np.clip(coefficients, 0, 1.5) * correlation_weight * level_weight
        if len(adaptive) >= 9:
            adaptive = sig.medfilt(adaptive, kernel_size=9)
        if len(adaptive) >= 17:
            adaptive = sig.savgol_filter(
                np.pad(adaptive, (8, 8), mode="edge"), 17, 2
            )[8:-8]
        adaptive = np.clip(adaptive, 0, 1.35)

        control_time = np.arange(int(math.ceil(duration * control_rate)) + 1) / control_rate
        control_phase = (control_time % period) / period
        template_control = np.interp(
            control_phase, phase_grid, template, period=1.0
        )
        adaptive_control = np.interp(
            control_time, beat_centers, adaptive, left=0.0, right=0.0
        )
        periodic_db = np.clip(
            -args.strength * adaptive_control * template_control,
            -args.cut_db, args.boost_db
        )

        trend_hop = int(analysis_sr * 0.05)
        trend_frame = int(analysis_sr * 0.20)
        original_rms = librosa.feature.rms(
            y=mono.astype(np.float32), frame_length=trend_frame,
            hop_length=trend_hop, center=True
        )[0]
        trend_time = np.arange(len(original_rms)) * trend_hop / analysis_sr
        original_db = 20 * np.log10(np.maximum(original_rms, 1e-8))
        sigma = 3.0 / (trend_hop / analysis_sr)
        original_long = ndi.gaussian_filter1d(original_db, sigma=sigma, mode="nearest")

        analysis_gain_db = np.interp(
            np.arange(len(mono)) / analysis_sr, control_time, periodic_db
        )
        corrected_mono = mono * (10 ** (analysis_gain_db / 20)).astype(np.float32)
        corrected_rms = librosa.feature.rms(
            y=corrected_mono.astype(np.float32), frame_length=trend_frame,
            hop_length=trend_hop, center=True
        )[0]
        corrected_db = 20 * np.log10(np.maximum(corrected_rms, 1e-8))
        corrected_long = ndi.gaussian_filter1d(corrected_db, sigma=sigma, mode="nearest")
        slow_compensation = np.clip(original_long - corrected_long, -1.5, 1.5)
        slow_compensation = ndi.gaussian_filter1d(
            slow_compensation,
            sigma=5.0 / (trend_hop / analysis_sr),
            mode="nearest"
        )
        total_db = periodic_db + np.interp(
            control_time, trend_time, slow_compensation,
            left=slow_compensation[0], right=slow_compensation[-1]
        )

        block = sample_rate * 10
        peak = 0.0
        with sf.SoundFile(
            corrected_wav, mode="w", samplerate=sample_rate,
            channels=audio.shape[1], subtype="FLOAT"
        ) as output:
            for start in range(0, len(audio), block):
                end = min(start + block, len(audio))
                time = np.arange(start, end) / sample_rate
                gain_db = np.interp(time, control_time, total_db)
                gain = (10 ** (gain_db / 20)).astype(np.float32)
                chunk = audio[start:end] * gain[:, None]
                peak = max(peak, float(np.max(np.abs(chunk))))
                output.write(chunk.astype(np.float32))

        peak_db = 20 * math.log10(max(peak, 1e-12))
        master_gain_db = args.target_peak - peak_db
        master_volume = 10 ** (master_gain_db / 20)
        encode_output(corrected_wav, args.output, master_volume)

        print(f"BPM: {args.bpm:.3f}")
        print(f"周期: {period:.6f} 秒")
        print(f"周期校正范围: {periodic_db.min():.2f} 到 {periodic_db.max():.2f} dB")
        print(f"峰值保护总增益: {master_gain_db:.2f} dB")
        print(f"输出: {args.output}")


if __name__ == "__main__":
    main()
