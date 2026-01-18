@echo off
setlocal
set "validExtension=txt"
if /i not "%~1"=="do" goto:skipExtChange
set "validExtension=todo"
SHIFT /1
:skipExtChange
if not "%~1"=="" set "custTxtName=%~n1"
if defined custTxtName (
type nul>"%custTxtName%.%validExtension%"
goto:skipTxtCreationProcess
)
call bdt
pushd "%CD%"
echo Date=%_dd% Month=%_mm% Year=%_yy%
type nul>"_%_yy:~-2%%_mm%%_dd%.%validExtension%"
:skipTxtCreationProcess
popd
endlocal
exit /b
