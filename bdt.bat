@echo off
::https://ss64.com/nt/syntax-getdate.html method 3
if not "%~1"=="" (
setlocal
set /a "isLocal=1"
)
Set tokes=2&if "%date%z" LSS "A" set tokes=1
for /f "skip=1 tokens=2-4 delims=(-)" %%A in ('echo/^|date') do ^
for /f "tokens=%tokes%-4 delims=.-/ " %%J in ('date /t') do ^
set _%%A=%%J&set _%%B=%%K&set _%%C=%%L
for /f "tokens=1-4 delims=:." %%A in ("%time: =0%") do set _hr=%%A&set _mn=%%B&set _sc=%%C&set _ms=%%D
if defined isLocal echo %_yy%, %_mm%, %_dd%, %_hr%, %_mn%, %_sc%
exit /b