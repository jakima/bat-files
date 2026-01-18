@echo off
setlocal
chcp 65001
pushd "%CD%"
>"%~dp0zzzz_mtempMve.txt" dir "*.mp4" "*.mkv" "*.avi" /a:-d /b 2>nul
findstr /virc:"^$" "%~dp0zzzz_mtempMve.txt" | find /v /c "" >nul || (
echo No movies here
goto:skipNoSrtProcess
)
>"%~dp0zzzz_mtempSrt.txt" dir "*.srt" /a:-d /b 2>nul
findstr /virc:"^$" "%~dp0zzzz_mtempSrt.txt" | find /v /c "" >nul || (
(echo ^^$)>"%~dp0zzzz_mtempSrt.txt"
goto:skipRegGen
)
call jrepl "^.*\.srt$" "$txt=carr+$src.replace(/\.srt$/i,'').replace(/([^0-9a-z])/ig,'\\$1')+eReg" /JQ /JBEG "carr=decode('\\c','output');eReg='\\.[^\\.\\\\]*$'" /X /I /F "%~dp0zzzz_mtempSrt.txt|utf-8|NB" /O -
:skipRegGen
findstr /V /I /R /G:"%~dp0zzzz_mtempSrt.txt" "%~dp0zzzz_mtempMve.txt"
if exist "%~dp0zzzz_mtemp*.txt" del /f /q "%~dp0zzzz_mtemp*.txt"
:skipNoSrtProcess
popd
endlocal
exit /b
