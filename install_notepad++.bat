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
echo install_notepad++
echo Downloading...
powershell "(New-Object System.Net.WebClient).DownloadFile('https://notepad-plus-plus.org/repository/7.x/7.5.4/npp.7.5.4.Installer.x64.exe','%TEMP%\npp.exe')"
echo Installing...
if exist "%programfiles%\Notepad++\uninstall.exe" "%programfiles%\Notepad++\uninstall.exe" /S
if exist "%programfiles(x86)%\ Notepad++\uninstall.exe" "%programfiles(x86)%\ Notepad++\uninstall.exe" /S
cd %TEMP%
start /wait npp.exe /S
del "%TEMP%\npp.exe"
echo Finish!!
pause
exit /b
