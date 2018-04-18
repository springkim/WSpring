::
::  install_clover.bat
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


::start
title install_clover
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'http://en.ejie.me/'; $HTML.Parsedhtml.getElementsByTagName('small') > clover_tags.txt"
powershell "get-content clover_tags.txt -ReadCount 1000 | foreach { $_ -match 'outerText' } | foreach { $_.Split(':')[1]} | out-file -encoding ascii clover_ver.txt"
set /p "VER="<"clover_ver.txt"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('http://cn.ejie.me/uploads/setup_clover@%VER:~1%.exe','%TEMP%\clover.exe')"

echo Installing...
start /wait clover.exe /S
DEL "%TEMP%\clover.exe"
echo Finish!!
pause
exit /b

::http://en.ejie.me/
::http://cn.ejie.me/uploads/setup_clover@3.4.3.exe
