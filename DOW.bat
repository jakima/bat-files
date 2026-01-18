@echo off
setlocal
set /a skipPause=0
set "datep=%*"
if defined datep set /a skipPause=1
if not defined datep set /p "datep=Enter dd[-mm[-[yy]yy]] "
for /f "tokens=1-3 delims=+-./\ " %%a in ("%datep%") do ^
set datep=%%a&set monthp=%%b&set yearp=%%c
call bdt
set actDate=%_dd%&set actMonth=%_mm%&set actYear=%_yy%
if not defined datep set datep=%actDate%
if not defined monthp set monthp=%actMonth%
if not defined yearp set yearp=%actYear%
set yearps=10000%yearp%
set /a yearps=yearps %% 100000
if %yearps% lss 100 ( set yearp=%actYear:~0,-2%%yearp%
goto:skipYearParse )
if %yearps% lss 1000 ( set yearp=%actYear:~0,-3%%yearp%
goto:skipYearParse )
if %yearps% lss 10000 set yearp=%actYear:~0,-4%%yearp%
:skipYearParse
echo  %datep% %monthp% %yearp%
call :dayOfWeek %datep% %monthp% %yearp%
if %skipPause% equ 0 pause
endlocal
exit /b

:dayOfWeek <date> <month> <year>
setlocal
set date=10%~1
set /a date=date %% 100
set month=10%~2
set /a month=month %% 100 - 1
set /a year=%~3
set y=%year:~-2%
set c=%year:~0,-2%
set monthCode=033614625035
set "Ans=SunMonTueWedThuFriSat"
call set monthExt=%%monthCode:~%month%,1%%
set /a centuryCode=6 - 2 * (c %% 4)
set /a res=date + monthExt + centuryCode + y + y / 4
call :isLeapYear %year% && if %month% leq 1 set /a res-=1
::compact pure mod
set /a dow=(res %% 7 + 7) %% 7
set /a ansExt=dow * 3
call set ansExt=%%Ans:~%ansExt%,3%%
echo  %ansExt%
endlocal
exit /b

:isLeapYear
setlocal
set /a _val=%~1, _isLeap=1
set /a _mod100=_val %% 100, _mod4=_mod100 %% 4, _mod400=_val %% 400
if %_mod100% gtr 0 if %_mod4% equ 0 set /a _isLeap-=1
if %_mod100% equ 0 if %_mod400% equ 0 set /a _isLeap-=1
exit /b %_isLeap%

