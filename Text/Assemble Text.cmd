
@echo off

set "textprocess=%~dp0..\Tools\TextProcess\text-process-classic"
set "parsefile=C:\Users\Vesly\Desktop\FEBuilderGBA\app\EA\Tools\ParseFile.exe"

echo: | ("%textprocess%" "text_buildfile.txt" --parser-exe "%parsefile%")

pause
