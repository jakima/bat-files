@echo off
setlocal
color 07
qr --ascii --error-correction=H %*
endlocal
exit /b