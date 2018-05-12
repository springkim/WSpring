::
::  install_java.bat
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
title install_java
echo Downloading...
call :SafeRMDIR "%SystemDrive%\JAVA"
if not exist %SystemDrive%\JAVA md %SystemDrive%\JAVA
cd %SystemDrive%\JAVA
curlw -L "https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10/openjdk-10.0.1_windows-x64_bin.tar.gz" -o "%SystemDrive%\JAVA\openjdk.tar.gz"
echo Installing...
call :Download7z
7z x openjdk*.tar.gz -y
7z x openjdk*.tar -y
DEL *.tar
DEL *.tar.gz
dir /B > z.txt
set /p "jdkname="<"z.txt"
call :DownloadSetw
setw "%SystemDrive%\JAVA\%jdkname%\bin"
DEL z.txt

echo Finish!!
pause
exit /b


:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://www.dropbox.com/s/utcz5y6rqf6j0zq/7z.exe?dl=1" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://www.dropbox.com/s/z4sj3yf0rn3k6nk/7z.dll?dl=1" -o "%WINDIR%\system32\7z.dll"
exit /b

:DownloadSetw
if not exist "%WINDIR%\system32\setw.exe" curlw -L "https://www.dropbox.com/s/6m35ug7psddzh96/setw.exe?dl=1" -o "%WINDIR%\system32\setw.exe"
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
