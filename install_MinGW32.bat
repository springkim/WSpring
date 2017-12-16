::
::  install_MinGW.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 16...
::  Copyright 2017 kimbom. All rights reserved.
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
echo Download MinGW
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/1gw4m5vb4i1nvay/MinGW.zip?dl=1','MinGW.zip')"
echo "Unzip & Install MinGW"
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('MinGW.zip', 'C:\MinGW'); }"

SETX PATH %PATH%;C:\MinGW\bin\ /m
::SET PATH=%PATH%;C:\MinGW\bin\

DEL "MinGW.zip"
echo Finish!!
pause
exit /b