::
::  install_waterfox.bat
::  WSpring
::
::  Created by kimbomm on 2018. 09. 17...
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

::::::::::::install
title install_waterfox
echo Downloading...
cd /D %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://www.waterfox.net/download/' -UseBasicParsing;($HTML.Links.href) > parse_waterfox.txt"
powershell "get-content parse_waterfox.txt -ReadCount 1000 | foreach { $_ -match 'win64/installer' } | out-file -encoding ascii parse_waterfox1.txt"
powershell "get-content parse_waterfox1.txt -ReadCount 1000 | foreach { $_ -match 'Current' } | out-file -encoding ascii parse_waterfox2.txt"
set /p "url="<"parse_waterfox2.txt"
curlw -L "%url%" -o "%TEMP%\waterfox.exe"

echo Installing...
"%TEMP%\waterfox.exe" -ms
DEL "%TEMP%\waterfox.exe"
echo Finish!!
pause
exit /b

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
