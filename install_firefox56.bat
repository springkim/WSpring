::
::  install_firefox56.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 10...
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


::::::::::::install
title install_firefox
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xs1lhslyc76mp7p/Firefox%20Setup%2056.0.2.exe?dl=1','%TEMP%\firefox56.exe')"

echo Installing...
"%TEMP%\firefox56.exe" -ms
DEL "%TEMP%\firefox56.exe"
echo Finish!!
pause
exit /b
