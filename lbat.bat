@echo off
setlocal
set "validExtension=bat"
if /I "%~1"=="txt" set "validExtension=txt"
dir "%~dp0\*.%validExtension%" /a-d /b | find /v "%~nx0"
endlocal
exit /b