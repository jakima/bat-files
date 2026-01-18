@echo off
setlocal
goto :hashProcessStart

When a file is hashed, its hash is stored for the
sake of comparision

Info about when the stored hash is overwritten
based on the parameters

Note: No information about the FILE or Alg is stored

X - Not overwritten ; O - overwritten

O - FILE
	with FILE hash
X - FILE -c
	allows for multiple files to be checked for match
O - FILE -c hash
	with passed hash irrespective of match
	this is basically override functionality
O - FILE -c checksumFile
	with FILE hash
	but only upon successful match
X - when FILE is not present
? - the "copy to clipboard" option
	Not relevant to overwriting the stored hash
	doesn't overwrite anything except your clipboard


:hashProcessStart
if not exist "%~dp0sha_prevFileHash.txt" type nul>"%~dp0sha_prevFileHash.txt"
if "%~1"=="" (
call :printUsage
goto :hashProcessEnd
)

set "hashFileName="
set hashAlg=sha256
if "%~x1"=="" echo(%~1|findstr /irc:"^[0-9][0-9]*$" >nul && set /a isAlgNum=1
if not defined isAlgNum goto :skipAlgSwapProcess

rem this reads as "sha" and not "hash" to include md5
echo(%~1|findstr /irc:"^256$" /c:"^384$" /c:"^512$" /c:"^1$" >nul || (
echo [ERROR] Invalid Alg argument
call :printUsage
goto :hashProcessEnd
)
if "%~1"=="384" set hashAlg=sha384
if "%~1"=="512" set hashAlg=sha512
if "%~1"=="1" set hashAlg=sha1
:skipAlgSwapProcess

if defined isAlgNum SHIFT /1
if not "%~x1"=="" set "hashFileName=%~f1"

if defined isAlgNum ^
if not defined hashFileName (
echo [ERROR] File is not mentioned
goto :hashProcessEnd
)

if defined hashFileName set "sizeOfFileToHash=%~z1"
if defined hashFileName SHIFT /1

if /I "%~1"=="-v" set /a copyHashToClip=1

if defined copyHashToClip ^
if not defined hashFileName (
echo [ERROR] File is not mentioned
goto :hashProcessEnd
)
if defined copyHashToClip SHIFT /1

if not "%~1"=="" set "compareToPrevFile=%~1"

if defined compareToPrevFile ^
if /I not "%compareToPrevFile%"=="-c" (
echo [ERROR] Invalid parameter
call :printUsage
goto :hashProcessEnd
)
if not defined hashFileName ^
if defined compareToPrevFile set /a isCompareOnlyMode=1
if defined compareToPrevFile SHIFT /1

if defined compareToPrevFile ^
if not "%~1"=="" set "overridePrevHash=%~1"

if defined compareToPrevFile ^
if not "%~x1"=="" echo(%~x1|findstr /irc:"^\.sha256$" /c:"^\.sha384$" /c:"^\.sha512$" /c:"^\.sha1$" /c:"^\.sha$" /c:"^\.checksum$" /c:"^\.checksums$" >nul && set "isCheckSumFileMode=%~f1" || (
echo [ERROR] Invalid checksum file
call :printUsage
goto :hashProcessEnd
)

if defined isCompareOnlyMode ^
if defined compareToPrevFile ^
if not defined isCheckSumFileMode ^
if not defined overridePrevHash (
rem how did this case cause no match
echo [ERROR] hash or checksum file is expected when FILE is not present
goto :hashProcessEnd
)

if not defined isCheckSumFileMode ^
if defined overridePrevHash echo(%overridePrevHash%|findstr /irc:"^[0-9a-f][0-9a-f]*$" >nul || (
echo [ERROR] Invalid hash
goto :hashProcessEnd
)

if not defined isCompareOnlyMode ^
if not exist "%hashFileName%" (
echo [ERROR] File to hash does not exist
goto :hashProcessEnd
)

if defined isCheckSumFileMode ^
if not exist "%isCheckSumFileMode%" (
echo [ERROR] checksum file does not exist
goto :hashProcessEnd
)

if defined hashFileName if "%sizeOfFileToHash%"=="0" (
echo [ERROR] FILE is empty
goto :hashProcessEnd
)

if defined isCheckSumFileMode if "%~z1"=="0" (
echo [ERROR] checksum file is empty
goto :hashProcessEnd
)


rem call :logVars


if defined isCompareOnlyMode ^
if not defined isCheckSumFileMode set hashOfFile=%overridePrevHash%

if not defined compareToPrevFile type nul>"%~dp0sha_prevFileHash.txt"

if not defined isCompareOnlyMode ^
if not defined isCheckSumFileMode ^
if defined overridePrevHash (echo %overridePrevHash%)>"%~dp0sha_prevFileHash.txt"

if not defined isCompareOnlyMode for /f "tokens=* delims=" %%# in ('certutil -hashfile "%hashFileName%" %hashAlg% ^| findstr /irc:"^[0-9a-f][0-9a-f]*$"') do set "hashOfFile=%%#"
if defined copyHashToClip <nul set /p "=%hashOfFile%"|clip

if not defined compareToPrevFile (echo %hashOfFile%)>"%~dp0sha_prevFileHash.txt"&&type "%~dp0sha_prevFileHash.txt"

if not defined isCheckSumFileMode ^
if defined compareToPrevFile findstr /irc:"^%hashOfFile%$" "%~dp0sha_prevFileHash.txt" >nul && echo ___MATCHED___ || echo =\=\=\=NO MATCH=\=\=\=

if defined isCompareOnlyMode ^
if defined isCheckSumFileMode for /f "usebackq tokens=* delims=" %%# in ("%~dp0sha_prevFileHash.txt") do set "hashOfFile=%%#"

rem https://unix.stackexchange.com/a/23017
if defined isCheckSumFileMode findstr /irc:"^%hashOfFile%  *" "%isCheckSumFileMode%" >nul && ( set /a isHashMatched=1 && echo ___MATCHED___) || echo =\=\=\=NO MATCH=\=\=\=
rem filename won't matter if hash matches

if not defined isCompareOnlyMode ^
if defined isHashMatched (echo %hashOfFile%)>"%~dp0sha_prevFileHash.txt"

:hashProcessEnd
endlocal
exit /b

:logVars
setlocal
echo(
echo ==================Variable Log====================
if defined hashAlg echo _hashAlg = %hashAlg%
if defined isAlgNum echo _isAlgNum = %isAlgNum%
if defined hashFileName echo _hashFileName = %hashFileName%
if defined isCompareOnlyMode echo _isCompareOnlyMode = %isCompareOnlyMode%
if defined compareToPrevFile echo _compareToPrevFile = %compareToPrevFile%
if defined overridePrevHash echo _overridePrevHash = %overridePrevHash%
if defined isCheckSumFileMode echo _isCheckSumFileMode = %isCheckSumFileMode%
if defined copyHashToClip echo _copyHashToClip = %copyHashToClip%
echo ===================================================
echo(
endlocal
exit /b

:printUsage
echo(
echo sha [[Alg] FILE [-v]] [-c [hash or checksum file]]
echo(
echo Help	-	If no parameters are passed
echo			help is printed
echo(
echo Alg	-	Accepts 1, 256, 384, 512
echo			Default is 256
echo(
echo FILE	-	File to be hashed
echo			can be optional when using ^-c
echo(
echo ^-v	-	Copy file hash to clipboard
echo(
echo ^-c	-	Check
echo			Using this parameter without hash
echo			or checksum when FILE is present
echo			will compare hash to the hash of
echo			previous file
echo(
echo			Hash or checksum file is optional
echo			only when FILE is present
echo(
echo			Hash of previous file is stored in
echo			the same location as this batch file
echo			in sha_prevFileHash.txt
echo(
echo			Accepted checksum file extensions are
echo			sha[1^|256^|384^|512], checksum[s]
echo			case^-insensitive
exit /b