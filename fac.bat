@echo off
setlocal
"%~dp0ffmpeg-master-latest-win64-gpl\bin\ffprobe.exe" -loglevel panic -show_entries stream=codec_name,codec_long_name,profile,channels,channel_layout,sample_rate,bit_rate,duration -select_streams a %* | call jrepl "^(bit\_rate\=)([0-9]+)" "$txt=$1+($2/1024)+' kb'" /JQ
endlocal
exit /b