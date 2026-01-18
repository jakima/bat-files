@echo off
setlocal
set subScore=90
if not "%~2"=="" set subScore=%~2
subliminal --opensubtitles username123 password123 download -l en -s -m %subScore% -w 3 "%~1"
endlocal
exit /b