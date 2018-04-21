::
::  install_speccy.bat
::  WSpring
::
::  Created by kimbomm on 2018. 04. 22...
::  Copyright 2018 kimbomm. All rights reserved.
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


::start
title install_speccy
echo Downloading...
cd %TEMP%
powershell "$HTML=Invoke-WebRequest -Uri 'https://www.ccleaner.com/speccy/download/standard' -UseBasicParsing;($HTML.Links.href) > speccy_latest.txt"
powershell "get-content speccy_latest.txt -ReadCount 1000 | foreach { $_ -match 'spsetup' } | out-file -encoding ascii speccy_url.txt"
set /p "url="<"speccy_url1.txt"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object System.Net.WebClient).DownloadFile('%url%','spsetup.exe')"
echo Installing...
start /wait spsetup.exe /S
del spsetup.exe
echo Finish!!
pause
exit /b
