::
::  install_git.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
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
title install_git
echo Downloading...
powershell "$HTML=Invoke-WebRequest -Uri 'https://git-scm.com/download/win' -UseBasicParsing;($HTML.Links.href) > %TEMP%\git_latest.txt"
powershell "get-content %TEMP%\git_latest.txt -ReadCount 1000 | foreach { $_ -match 'PortableGit' } | out-file -encoding ascii %TEMP%\git_url.txt"
powershell "get-content %TEMP%\git_url.txt -ReadCount 1000 | foreach { $_ -match '64-bit' } | out-file -encoding ascii %TEMP%\git_url1.txt"
set /p "url="<"%TEMP%\git_url1.txt"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object System.Net.WebClient).DownloadFile('%url%','%TEMP%\git.7z')"
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
where 7z
if %ERRORLEVEL% NEQ 0 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/z4sj3yf0rn3k6nk/7z.dll?dl=1','%WINDIR%\system32\7z.dll')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/utcz5y6rqf6j0zq/7z.exe?dl=1','%WINDIR%\system32\7z.exe')"
)
exit /b

:DownloadSetw
where setw
if %ERRORLEVEL% NEQ 0 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/6m35ug7psddzh96/setw.exe?dl=1','%WINDIR%\system32\setw.exe')"
)
exit /b
