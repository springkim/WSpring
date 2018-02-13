::
::  install_clover.bat
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
echo install_clover
echo Downloading...
powershell "Set-ExecutionPolicy RemoteSigned -Force"
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/z6gvg1e3666afci/clover.exe?dl=1','%TEMP%\clover.exe')"
cd %TEMP% 
echo Installing...
start /wait clover.exe /S
DEL "%TEMP%\clover.exe"
echo Finish!!
pause
exit /b