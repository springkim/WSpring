::
::  install_notepad++.bat
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
title install_notepad++
cd %TEMP%
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/download' -UseBasicParsing;($HTML.Links.href) > npp_latest.txt"
powershell "get-content npp_latest.txt -ReadCount 1000 | foreach { $_ -match 'Installer.x64.exe' } | out-file -encoding ascii npp_url.txt"
set /p "url="<"npp_url.txt"

powershell "(New-Object System.Net.WebClient).DownloadFile('https://notepad-plus-plus.org/%url%','%TEMP%\npp.exe')"
echo Installing...
if exist "%programfiles%\Notepad++\uninstall.exe" "%programfiles%\Notepad++\uninstall.exe" /S
if exist "%programfiles(x86)%\ Notepad++\uninstall.exe" "%programfiles(x86)%\ Notepad++\uninstall.exe" /S
cd %TEMP%
start /wait npp.exe /S
del "%TEMP%\npp.exe"
echo Finish!!
pause
exit /b
