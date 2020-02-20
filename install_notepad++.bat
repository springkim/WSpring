::
::  install_notepad++.bat
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

::::::::::::install
title install_notepad++
cd /D %TEMP%
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/download' -UseBasicParsing;($HTML.Links.href) > npp_latest.txt"
powershell "get-content npp_latest.txt -ReadCount 1000 | foreach { $_ -match 'https://notepad-plus-plus.org/downloads' } | out-file -encoding ascii npp_url.txt"
set /p "url="<"npp_url.txt"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri '%url%' -UseBasicParsing;($HTML.Links.href) > npp_latest2.txt"
powershell "get-content npp_latest2.txt -ReadCount 1000 | foreach { $_ -match 'Installer.x64.exe' } | out-file -encoding ascii npp_url2.txt"
set /p "url2="<"npp_url2.txt"
curlw -L "%url2%" -o "%TEMP%\npp.exe"
echo Installing...
if exist "%programfiles%\Notepad++\uninstall.exe" "%programfiles%\Notepad++\uninstall.exe" /S
if exist "%programfiles(x86)%\ Notepad++\uninstall.exe" "%programfiles(x86)%\ Notepad++\uninstall.exe" /S
cd /D %TEMP%
start /wait npp.exe /S
del "%TEMP%\npp.exe"
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
