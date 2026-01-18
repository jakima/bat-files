@echo off
setlocal
set /a "launchMovie=1"
if not "%~1"=="" set /a "launchMovie=0"
set "mpvPath=C:\mpv-x86_64\mpv.exe"
pushd "%CD%"
if exist "%~1" if /I not "%~x1"==".srt" (
set /a "launchMovie=1"
set "PickedMovieName=%~1"
goto:skipRandomPicking
)
>"%~dp0zzz_dirOutmTemp.txt" dir *.mp3 *.mp4 *.mkv *.avi /o-d /TC /a-d /b 2>nul
for /f "tokens=* delims=" %%# in ('find /v /c ""^<"%~dp0zzz_dirOutmTemp.txt"') do set "totalFileCount=%%#"
if %totalFileCount% equ 0 (
echo No movies to pick from
goto:skipMoviePickerProcess
)
set /a "randNum=%RANDOM% %% totalFileCount + 1"
for /f "tokens=1* delims=]" %%a in ('find /v /n ""^<"%~dp0zzz_dirOutmTemp.txt" ^| findstr /irc:"^\[%randNum%\]"') do set "pickedMovieName=%%b"
:skipRandomPicking
echo %pickedMovieName%
if %launchMovie% equ 0 goto:skipMoviePickerProcess
start "" "%mpvPath%" --fs --video-aspect-override=16:9 --script-opts=rand_file-is_file_picked=yes "%pickedMovieName%"
:: mpv loses focus if cmd exits quickly
>nul timeout /t 1 /nobreak
:skipMoviePickerProcess
popd
if exist "%~dp0zzz_dirOutmTemp.txt" del /f /q "%~dp0zzz_dirOutmTemp.txt"
endlocal
exit /b