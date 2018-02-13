::
::  install_teamviewer.bat
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
echo Downloading...
powershell "(New-Object System.Net.WebClient).DownloadFile('https://download.teamviewer.com/download/TeamViewer_Setup.exe','%TEMP%\TeamViewer_Setup.exe')"
echo Installing...
cd %TEMP%
start /wait TeamViewer_Setup.exe /S /norestart
del "%TEMP%\TeamViewer_Setup.exe"
echo Finish!!
pause
exit /b
