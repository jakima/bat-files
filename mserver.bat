@echo off
setlocal
goto:skipCloseWarning

CTRL+C raises SIGINT and only results in a graceful shutdown of a process
please disable active adapter and re-enable in ncpa.cpl
  after killing dms.exe for releasing listens on network
  and before restarting the server
microslop win sucks and doesn't close ports properly

:skipCloseWarning
if not "%~1"=="-SIGINTHNDL" (
cls
CALL <NUL %0 -SIGINTHNDL %~1 %~2
exit /b
)
:: you need https://github.com/anacrolix/dms
::   and an android tv with as vlc-android to browse and watch
"%~dp0dms.exe" ^
-noProbe -noTranscode -ignoreHidden -ignoreUnreadable ^
-notifyInterval 2s ^
-path "%CD%"
endlocal
exit /b