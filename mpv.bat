@echo off
setlocal
set "mpvPath=C:\mpv-x86_64\mpv.exe"
start "" "%mpvPath%" %*
>nul timeout /t 1 /nobreak
endlocal
exit /b