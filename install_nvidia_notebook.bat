::
::  install_nvidia_notebook.bat
::  WSpring
::
::  Created by kimbomm on 2018. 03. 23...
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

echo install nvidia driver for notebook
echo Downloading...
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/dgeosk46771lf77/nvidia-notebook.exe?dl=1','%TEMP%\nvidia-notebook.exe')"
echo Installing...
cd "%TEMP%"
call nvidia-notebook.exe -s -noreboot
del "%TEMP%\nvidia-notebook.exe"
echo Finish!!
pause
