::
::  install_bomi.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
::  Copyright 2017 kimbomm. All rights reserved.
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
echo install_bomi
echo Downloading... 
powershell "(New-Object System.Net.WebClient).DownloadFile('http://master.dl.sourceforge.net/project/bomi/windows/latest/bomi-64bit.7z','%TEMP%\bomi-64bit.7z')"
echo Installing...
7z x "%TEMP%\bomi-64bit.7z" -y -o"%SystemDrive%\Program Files\"
DEL "%TEMP%\bomi-64bit.7z"
echo Finish!!
pause
exit /b
