::
::  install_MinGW64.bat
::  WSpring
::
::  Created by kimbomm on 2017. 12. 16...
::  Copyright 2017 kimbomm. All rights reserved.
::
:: 7.2.0
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
title install_mingw64
echo Downloading...
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/5hc0q3ryk8lt2w4/MinGW64.zip?dl=1','%TEMP%\MinGW64.zip')"
echo Unzipping...
call :SafeRMDIR "%SystemDrive%\MinGW64"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\MinGW64.zip', '%SystemDrive%\MinGW64'); }"
call :DownloadSetw
setw "C:\MinGW64\bin\"

DEL "%TEMP%\MinGW64.zip"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

:DownloadSetw
where setw
if %ERRORLEVEL% NEQ 0 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/6m35ug7psddzh96/setw.exe?dl=1','%WINDIR%\system32\setw.exe')"
)
exit /b
