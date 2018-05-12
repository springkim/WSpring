::
::  install_filezilla.bat
::  WSpring
::
::  Created by kimbomm on 2018. 03. 24...
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
cd /D "%~dp0"
call :AbsoluteDownloadCurl

::start
title install_filezilla
if exist "%programfiles%\FileZilla FTP Client\uninstall.exe" "%programfiles%\FileZilla FTP Client\uninstall.exe" /S
if exist "%programfiles(x86)%\FileZilla FTP Client\uninstall.exe" "%programfiles(x86)%\FileZilla FTP Client\uninstall.exe" /S
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://filezilla-project.org/download.php?show_all=1' -UseBasicParsing;($HTML.Links.href) > filezilla_latest.txt"
powershell "get-content filezilla_latest.txt -ReadCount 1000 | foreach { $_ -match 'win64-setup.exe' } | out-file -encoding ascii filezilla_url.txt"
powershell "get-content filezilla_url.txt -ReadCount 1000 | foreach { $_ -match 'https' } | out-file -encoding ascii filezilla_url2.txt"
set /p "url="<"filezilla_url2.txt"
echo %url%
curlw -L "%url%" -o "FileZilla.exe"
echo Installing...
start /wait FileZilla.exe /S
DEL "%TEMP%\filezilla_latest.txt"
DEL "%TEMP%\filezilla_url.txt"
DEL "%TEMP%\filezilla_url2.txt"
echo Finish!!
pause
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
