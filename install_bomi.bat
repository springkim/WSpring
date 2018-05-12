::
::  install_bomi.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
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
title install_bomi
echo Downloading...

curlw -L "http://master.dl.sourceforge.net/project/bomi/windows/latest/bomi-64bit.7z" -o "%TEMP%\bomi-64bit.7z"
echo Installing...
call :Download7z
7z x "%TEMP%\bomi-64bit.7z" -y -o"%SystemDrive%\Program Files\"
DEL "%TEMP%\bomi-64bit.7z"
echo Finish!!
pause
exit /b

:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://www.dropbox.com/s/utcz5y6rqf6j0zq/7z.exe?dl=1" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://www.dropbox.com/s/z4sj3yf0rn3k6nk/7z.dll?dl=1" -o "%WINDIR%\system32\7z.dll"
exit /b

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
