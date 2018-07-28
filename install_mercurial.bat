::
::  install_mercurial.bat
::  WSpring
::
::  Created by kimbomm on 2018. 05. 24...
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
::::::::::::install
title install_mercurial
echo Downloading...
cd %TEMP%

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://www.mercurial-scm.org/release/windows/' -UseBasicParsing;($HTML.Links.href) > hg_latest.txt"

powershell "get-content hg_latest.txt -ReadCount 1000 | foreach { $_ -match 'mercurial' } | out-file -encoding ascii hg_url.txt"
powershell "get-content hg_url.txt -ReadCount 1000 | foreach { $_ -match 'x64.msi' } | out-file -encoding ascii hg_url2.txt"
powershell "$x = Get-Content -Path hg_url2.txt; Set-Content -Path hg_url2.txt -Value ($x[($x.Length-1)..0])"
set /p "url="<"hg_url2.txt"

curlw -L "https://www.mercurial-scm.org/release/windows/%url%" -o "mercurial.msi"
echo Installing...
start /wait msiexec /i mercurial.msi /qb

del mercurial.msi
del hg_latest.txt
del hg_url.txt
del hg_url2.txt
echo Finish!
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
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/curl.exe','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/ca-bundle.crt','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
