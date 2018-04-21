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

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'http://strawberryperl.com/releases.html' -UseBasicParsing;($HTML.Links.href) > perl_latest.txt"
powershell "get-content perl_latest.txt -ReadCount 1000 | foreach { $_ -match '64bit.zip' } | out-file -encoding ascii perl_url.txt"
set /p "url="<"perl_url.txt"

powershell "(New-Object System.Net.WebClient).DownloadFile('%url%','perl.zip')"
echo Installing...
call :DownloadSetw
call :SafeRMDIR "%SystemDrive%\Strawberry"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('perl.zip', '%SystemDrive%\Strawberry'); }"
setw "%SystemDrive%\Strawberry\c\bin"
setw "%SystemDrive%\Strawberry\perl\site\bin"
setw "%SystemDrive%\Strawberry\perl\bin"
::msiexec /i  strawberry-perl-5.26.1.1-64bit.msi /qb
del perl.zip
echo Finish!
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
