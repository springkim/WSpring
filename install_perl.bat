::
::  install_perl.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 04...
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
title install_perl
echo Downloading...
cd %TEMP%
powershell "(New-Object System.Net.WebClient).DownloadFile('http://strawberryperl.com/download/5.26.1.1/strawberry-perl-5.26.1.1-64bit.msi','strawberry-perl-5.26.1.1-64bit.msi')"
echo Installing...
msiexec /i  strawberry-perl-5.26.1.1-64bit.msi /qb
del strawberry-perl-5.26.1.1-64bit.msi
echo Finish!
pause
exit /b
