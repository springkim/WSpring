::
::  install_git.bat
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
title install_git
echo Downloading...
powershell "$HTML=Invoke-WebRequest -Uri 'https://git-scm.com/download/win' -UseBasicParsing;($HTML.Links.href) > %TEMP%\git_latest.txt"
powershell "get-content %TEMP%\git_latest.txt -ReadCount 1000 | foreach { $_ -match 'PortableGit' } | out-file -encoding ascii %TEMP%\git_url.txt"
powershell "get-content %TEMP%\git_url.txt -ReadCount 1000 | foreach { $_ -match '64-bit' } | out-file -encoding ascii %TEMP%\git_url1.txt"
set /p "url="<"%TEMP%\git_url1.txt"
curlw -L "%url%" -o "%TEMP%\git.7z"
echo Installing...
call :SafeRMDIR "%SystemDrive%\Program Files\Git\"
md "%SystemDrive%\Program Files\Git\"
call :Download7z
7z x "%TEMP%\git.7z" -y -o"%SystemDrive%\Program Files\Git\"
call :DownloadSetw
setw "C:\Program Files\Git\cmd"
DEL "%TEMP%\git.7z"
DEL "%TEMP%\git_latest.txt"
DEL "%TEMP%\git_url.txt"
DEL "%TEMP%\git_url1.txt"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.exe" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.dll" -o "%WINDIR%\system32\7z.dll"
exit /b

:DownloadSetw
if not exist "%WINDIR%\system32\setw.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/setw.exe" -o "%WINDIR%\system32\setw.exe"
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
