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
title install_haroopad
if exist "%AppData%\Haroo Studio\Haroopad\Uninstall.lnk" (
	echo Remove old verison
	"%AppData%\Haroo Studio\Haroopad\Uninstall.lnk" /qb
)
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://bitbucket.org/rhiokim/haroopad-download/downloads/' -UseBasicParsing;($HTML.Links.href) > haroopad_latest.txt"
powershell "get-content haroopad_latest.txt -ReadCount 1000 | foreach { $_ -match '/rhiokim/haroopad-download/downloads/Haroopad' } | out-file -encoding ascii haroopad_url.txt"
powershell "get-content haroopad_url.txt -ReadCount 1000 | foreach { $_ -match 'msi' } | out-file -encoding ascii haroopad_url2.txt"
set /p "url="<"haroopad_url2.txt"
powershell "(New-Object System.Net.WebClient).DownloadFile('https://bitbucket.org/%url%','Haroopad.msi')"
echo Installing...
msiexec /i Haroopad.msi /qb
del Haroopad.msi
echo Finish!
pause
exit /b
