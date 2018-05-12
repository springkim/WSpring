::
::  install_bandizip.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 03...
::  Copyright 2017-2018 kimbomm. All rights reserved.
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
call :AbsoluteDownloadCurl

::start
title install_bandizip
echo Downloading...
powershell "Set-ExecutionPolicy RemoteSigned -Force"

curlw -L "https://www.bandisoft.co.kr/bandizip/dl.php?web" -o "%TEMP%\BANDIZIP-SETUP-KR.EXE"

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

::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xytowp38v6d61lh/curl.exe?dl=1','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ibgh7o7do1voctb/ca-bundle.crt?dl=1','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
