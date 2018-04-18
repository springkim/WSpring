::
::  install_foxit.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
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
title install_foxit
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/w2mczugknccriop/FoxitReader90_L10N_Setup_Prom.exe?dl=1','%TEMP%\foxit.exe')"

echo Installing...
cd %TEMP%
start /wait foxit.exe /ForceInstall /VERYSILENT DESKTOP_SHORTCUT="0" MAKEDEFAULT="0" VIEWINBROWSER="0" LAUNCHCHECKDEFAULT="0" AUTO_UPDATE="0" /passive /norestart

del "%TEMP%\foxit.exe"
echo Finish!!
pause
exit /b
