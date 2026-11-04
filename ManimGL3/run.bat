@echo off
setlocal
cd /d "%~dp0"
set "LIGHTS_OUT_EXPORT_LOGS=0"
manimgl lights_out_gl3.py LightsOut %*
pause
