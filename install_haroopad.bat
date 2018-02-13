::
::  install_haroopad.bat
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
echo install_haroopad
echo Downloading...
cd %TEMP%
powershell "(New-Object System.Net.WebClient).DownloadFile('https://bitbucket.org/rhiokim/haroopad-download/downloads/Haroopad-v0.13.1-win-x64.msi','Haroopad-v0.13.1-win-x64.msi')"
echo Installing...
msiexec /i Haroopad-v0.13.1-win-x64.msi /qb
del Haroopad-v0.13.1-win-x64.msi
echo Finish!
pause
exit /b
