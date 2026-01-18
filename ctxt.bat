@echo off
setlocal
if not "%~1"=="" set "custTxtName=%~n1"
pushd "%CD%"
if defined custTxtName (
type nul>"%custTxtName%.txt"
goto:skipTxtCreationProcess
)
call bdt
echo Date=%dd% Month=%mm% Year=%yy%
type nul>"_%yy:~-2%%mm%%dd%.txt"
:skipTxtCreationProcess
popd
endlocal
exit /b