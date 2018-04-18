::
::  install_bandizip.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 03...
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
title install_bandizip
echo Downloading...
powershell "Set-ExecutionPolicy RemoteSigned -Force"

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.bandisoft.co.kr/bandizip/dl.php?web','%TEMP%\BANDIZIP-SETUP-KR.EXE')"

cd %TEMP%
echo Installing...
start /wait BANDIZIP-SETUP-KR.EXE /S
DEL "%TEMP%\BANDIZIP-SETUP-KR.EXE"
echo Finish!!
pause
exit /b
::Power shell hidden option
::https://stackoverflow.com/questions/1802127/how-to-run-a-powershell-script-without-displaying-a-window

::power shell run on admin
::https://social.technet.microsoft.com/Forums/ie/en-US/acf70a31-ceb4-4ea5-bac1-be2b25eb5560/how-to-run-as-admin-powershellps1-file-calling-in-batch-file?forum=winserverpowershell

::powershell mouse event
::https://stackoverflow.com/questions/39353073/how-i-can-send-mouse-click-in-powershell
