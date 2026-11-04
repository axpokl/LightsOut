@echo off
setlocal
cd /d "%~dp0"
del subtitle.txt
del subtitle_raw.txt
del title.txt
del latex.txt
del normal.txt

set "LIGHTS_OUT_EXPORT_LOGS=1"
manimgl lights_out_gl3.py LightsOut -w --file_name lights_out
if errorlevel 1 (
    pause
) else (
    start "" ".\videos\lights_out.mp4"
)
