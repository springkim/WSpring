::
::  install_clover.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
::  Copyright 2017-2018 kimbomm. All rights reserved.
::
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Get admin permission...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
call :AbsoluteDownloadCurl

::start
title install_clover
cd %TEMP%
call :AbsoluteDownloadHtmlAgilityPack

powershell "$wc = New-Object System.Net.WebClient;$html=$wc.DownloadString('http://en.ejie.me/');add-type -Path %WINDIR%\System32\HtmlAgilityPack.dll;$doc = New-Object HtmlAgilityPack.HtmlDocument;$doc.LoadHtml($html);$doc.DocumentNode.SelectSingleNode('html').SelectSingleNode('body').SelectSingleNode('div').SelectSingleNode('div').SelectSingleNode('div').SelectSingleNode('div').SelectSingleNode('div').InnerText -replace ' ','' > clover_tags.txt;"
powershell "get-content clover_tags.txt -ReadCount 1000 | foreach { $_ -match '^[0-9\.]+' | out-file -encoding ascii clover_ver.txt }"

set /p "VER="<"clover_ver.txt"
curlw -L "http://cn.ejie.me/uploads/setup_clover@%VER%.exe" -o "%TEMP%\clover.exe"

echo Installing...
start /wait clover.exe /S
DEL "%TEMP%\clover.exe"
echo Finish!!
pause
exit /b

::http://en.ejie.me/
::http://cn.ejie.me/uploads/setup_clover@3.4.3.exe
::https://social.msdn.microsoft.com/Forums/en-US/eaadff1f-7bfc-49be-9e9a-3139c3dbe473/invoke-web-request-return-empty-parsed-html-field
::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/curl.exe','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/ca-bundle.crt','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
:AbsoluteDownloadHtmlAgilityPack
:loop_adhap
call :GetFileSize "%SystemRoot%\System32\HtmlAgilityPack.dll"
if %FILESIZE% neq 134656 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/HtmlAgilityPack.dll','%WINDIR%\System32\HtmlAgilityPack.dll')"
	goto :loop_adhap
)
exit /b
