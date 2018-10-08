@if (@CodeSection == @Batch) @then
::
::  build_nana.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 04...
::  Copyright 2018 kimbomm. All rights reserved.
::
@echo off
call :CCSelect

call :AbsoluteDownloadHtmlAgilityPack
set NAME=nana
call :SafeRMDIR "build_%NAME%"
mkdir "build_%NAME%"
cd "build_%NAME%"

powershell "$wc = New-Object System.Net.WebClient;$html=$wc.DownloadString('http://nanapro.org/en-us/');add-type -Path %WINDIR%\System32\HtmlAgilityPack.dll;$doc = New-Object HtmlAgilityPack.HtmlDocument;$doc.LoadHtml($html);$doc.DocumentNode.SelectSingleNode('html').SelectSingleNode('body').SelectSingleNode('div[3]').SelectSingleNode('div[2]').SelectSingleNode('div').SelectSingleNode('div').SelectSingleNode('span[2]').InnerText | out-file -encoding ascii nanaver.txt"


set /p "nanaver="<"nanaver.txt"
echo "http://nanapro.org/common/api/download.php?ver=%nanaver%"
curlw -L "http://nanapro.org/common/api/download.php?ver=%nanaver%" -o "nana.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('nana.zip', '.'); }"

if not x%COMPILER:MinGW=%==x%COMPILER% ( 
	cd nana\build
	cmake .. -G "MinGW Makefiles"
) else ( 
	if not x%COMPILER:2013=%==x%COMPILER% (
		cd nana\build\vc2013
		"%VS120COMNTOOLS%vsvars32.bat"
	)
	if not x%COMPILER:2015=%==x%COMPILER% (
		cd nana\build\vc2015
		"%VS140COMNTOOLS%vsvars32.bat"
	)
	if not x%COMPILER:2017=%==x%COMPILER% (
		cd nana\build\vc2017
		"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
	)
	msbuild nana.sln /p:Configuration=Debug /p:Platform=x64
	msbuild nana.sln /p:Configuration=Release /p:Platform=x64
)

pause
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:AbsoluteDownloadHtmlAgilityPack
:loop_adhap
call :GetFileSize "%SystemRoot%\System32\HtmlAgilityPack.dll"
if %FILESIZE% neq 134656 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/HtmlAgilityPack.dll','%WINDIR%\System32\HtmlAgilityPack.dll')"
	goto :loop_adhap
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::reference : http://reboot.pro/topic/20968-basic-batch-menu-using-arrows-keys/
:CCSelect
setlocal EnableDelayedExpansion
set numOpts=0
if "%1" equ "" set OPT="Visual Studio 2017 x64" "Visual Studio 2015 x64" "Visual Studio 2013 x64" "MinGW x64" "Visual Studio 2017 x86" "Visual Studio 2015 x86" "Visual Studio 2013 x86" "MinGW x86"
if not "%1" equ "" set OPT=%*
for %%a in (%OPT%) do (
   set /A numOpts+=1
   set aa=%%a
   set option[!numOpts!]=!aa:"=!
)
set /A numOpts+=1
set "option[!numOpts!]=exit"
rem Clear previous doskey history
doskey /LISTSIZE=!numOpts!
rem Fill doskey history with menu options
cscript //nologo /E:JScript "%~f0" EnterOpts
for /L %%i in (1,1,%numOpts%) do set /P "COMPILER="
:nextOpt
cls
rem echo MULTI-LINE MENU WITH OPTIONS SELECTION
rem echo/
rem Send a F7 key to open the selection menu
cscript //nologo /E:JScript "%~f0" > nul
set COMPILER=
set /P "COMPILER=Select the desired option: " > nul
endlocal & set COMPILER="%COMPILER%"
doskey /LISTSIZE=0
cls
goto :eof
@end
var wshShell = WScript.CreateObject("WScript.Shell"),
    envVar = wshShell.Environment("Process"),
    numOpts = parseInt(envVar("numOpts"));
if ( WScript.Arguments.Length ) {
   // Enter menu options
   for ( var i=1; i <= numOpts; i++ ) {
      wshShell.SendKeys(envVar("option["+i+"]")+"{ENTER}");
   }
} else {
   // Enter a F7 to open the menu
   wshShell.SendKeys("{F7}");
   wshShell.SendKeys("{HOME}");
}