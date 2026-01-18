@echo off
setlocal
rem remove everything after "stream" from "=" to get a full list
"%~dp0ffmpeg-master-latest-win64-gpl\bin\ffprobe.exe" -loglevel panic -show_entries stream=codec_name,codec_long_name,width,height,coded_width,coded_height,pix_fmt,level,bits_per_raw_sample -select_streams v %*
rem "%~dp0ffmpeg-master-latest-win64-gpl\bin\ffprobe.exe" -show_streams %*
endlocal
exit /b