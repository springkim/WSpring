::
::  install_pathcopycopy.bat
::  WSpring
::
::  Created by kimbomm on 2018. 04. 22...
::  Copyright 2017 kimbomm. All rights reserved.
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
title install_pathcopycopy
echo Downloading...
cd %TEMP%
if exist "%programfiles%\Path Copy Copy\unins000.exe" "%programfiles%\Path Copy Copy\unins000.exe" /VERYSILENT /NORESTART
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/clechasseur/pathcopycopy/releases' -UseBasicParsing;($HTML.Links.href) > pcc_latest.txt"
powershell "get-content pcc_latest.txt -ReadCount 1000 | foreach { $_ -match '.exe$' } | out-file -encoding ascii pcc_url.txt"
set /p "url="<"pcc_url.txt"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com%url%','PathCopyCopy.exe')"
echo Installing...
start /wait PathCopyCopy.exe /VERYSILENT
DEL "%TEMP%\PathCopyCopy.exe.txt"
DEL "%TEMP%\pcc_latest.txt"
DEL "%TEMP%\pcc_url.txt"
echo Finish!!
pause
exit /b
