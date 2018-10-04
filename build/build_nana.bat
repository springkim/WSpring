::
::  build/build_nana.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 04...
::  Copyright 2018 kimbomm. All rights reserved.
::
@echo off

::set COMPILER=vc2017
set COMPILER=vc2015
::set COMPILER=vc2013
::set COMPILER=mingw

::                       ::
:: PRE-DEFINED VARIABLES ::
::                       ::
:: url : http://nanapro.org/common/api/download.php?ver=1.6.2
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

if %COMPILER% == mingw (
	cmake ..
) else (
	cd nana\build\%COMPILER%
	if %COMPILER% == vc2013 (
		"%VS120COMNTOOLS%vsvars32.bat"
	)
	if %COMPILER% == vc2015 (
		"%VS140COMNTOOLS%vsvars32.bat"
	)
	if %COMPILER% == vc2017 (
		"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
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
