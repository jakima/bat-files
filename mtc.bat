@echo off
setlocal
pushd "%CD%"
dir "*.mp4" "*.mkv" "*.avi" /a-d /b | find /v /c ""
popd
endlocal
exit /b