@echo off
setlocal
if not "%~1"=="-SIGINTHNDL" (
CALL <NUL %0 -SIGINTHNDL %~1 %~2
exit /b
)
set "param_port=%~2"
if /I "%param_port%"=="w" set "writeFlag=-w"
if /I "%param_port%"=="write" set "writeFlag=-w"
if defined writeFlag SHIFT /1
set "param_port=%~2"
set /a portDisplay=%param_port%
if not defined param_port set "portDisplay=2121"
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
<nul set /p "=%NetworkIP%:%portDisplay%"|clip
echo __________________%NetworkIP%:%portDisplay%__________________
if defined param_port set "portFlag=-p %param_port%"
python -m pyftpdlib -d "%CD%" -i %NetworkIP% %writeFlag% %portFlag% -u asdfg -P asdfg
pause
endlocal
exit /b