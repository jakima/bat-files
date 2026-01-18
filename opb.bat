@echo off
setlocal
pushd "%~dp0"
set "validExtension=bat"
if /I "%~x1"==".txt" set "validExtension=txt"
if not "%~1"=="." ^
if not "%~1"==".." ^
if not "%~1"=="" if exist "%~n1.%validExtension%" (
start "" notepad "%~n1.%validExtension%"
) else (
echo No such %validExtension% file exists!
)
if "%~1"=="" echo Must name bat files
popd
endlocal
exit /b