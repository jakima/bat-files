@echo off
setlocal
if not "%~1"=="-SIGINTHNDL" (
CALL <NUL %0 -SIGINTHNDL %~1 %~2
exit /b
)
set "param_path=%~2"
if /I "%param_path%"=="l" set "NetworkIP=127.0.0.1"
if /I "%param_path%"=="local" set "NetworkIP=127.0.0.1"
if defined NetworkIP SHIFT /1
set "param_path=%~2"
set "param_port=%~3"
if not defined param_port set param_port=8096
if not defined NetworkIP ^
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
set "pathToDirectory=%CD%"
if defined param_path if exist "%param_path%\" set "pathToDirectory=%param_path%"
<nul set /p "=%NetworkIP%:%param_port%"|clip
python -m http.server --bind %NetworkIP% --directory "%pathToDirectory%" %param_port%
pause
endlocal
exit /b
