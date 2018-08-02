::
::  install_python3.bat
::  WSpring
::
::  Created by kimbomm on 2018. 08. 02...
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
call :AbsoluteDownloadCurl
::start
title install_python3
echo Downloading...
cd %TEMP%

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://www.python.org/downloads/' -UseBasicParsing;($HTML.Links.href) > python_html.txt"
powershell "get-content python_html.txt -ReadCount 10000 | foreach { $_ -match '/downloads/release/python-3' } | out-file -encoding ascii python_url.txt"
set /p "url="<"python_url.txt"
echo latest version of python3 is %url:~26,3%

curlw -L "https://www.python.org/ftp/python/%url:~26,1%.%url:~27,1%.%url:~28,1%/python-%url:~26,1%.%url:~27,1%.%url:~28,1%-amd64.exe" -o "%TEMP%\Python3_installer.exe"


echo Installing...
start /wait Python3_installer.exe /uninstall /quiet
start /wait Python3_installer.exe /simple /quiet

::C:\Users\username\AppData\Local\Programs\Python\Python37
::Remove old python
for /D %%f in (%SYSTEMDRIVE%\Python3*) do @rmdir /S /Q %%f
::Move latest python to C:\
for /D %%f in (%LOCALAPPDATA%\Programs\Python\Python3*) do move %%f %SYSTEMDRIVE%\

setw "C:\Python%url:~26,2%\"
setw "C:\Python%url:~26,2%\Scripts"

DEL python_url.txt
DEL python_html.txt
::DEL "%TEMP%\Python3_installer.exe"
echo Finish!!
pause
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
