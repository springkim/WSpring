::
::  install_bandizip.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 03...
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
powershell "Set-ExecutionPolicy RemoteSigned -Force"
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.bandisoft.co.kr/bandizip/dl.php?web','%TEMP%\BANDIZIP-SETUP-KR.EXE')"
cd %TEMP%
echo $myshell=New-Object -com 'Wscript.Shell'; >> install_bandizip.ps1
echo while($myshell.AppActivate('반디집') -eq $False) >> install_bandizip.ps1
echo { >> install_bandizip.ps1
echo } >> install_bandizip.ps1
echo while($myshell.AppActivate('반디집')) >> install_bandizip.ps1
echo { >> install_bandizip.ps1
echo $myshell.sendkeys('{ENTER}'); >> install_bandizip.ps1
echo sleep 1; >> install_bandizip.ps1
echo } >> install_bandizip.ps1
echo while($myshell.AppActivate('반디집') -eq $False) >> install_bandizip.ps1
echo { >> install_bandizip.ps1
echo sleep 1; >> install_bandizip.ps1
echo } >> install_bandizip.ps1
echo while($myshell.AppActivate('반디집')) >> install_bandizip.ps1
echo { >> install_bandizip.ps1
echo $myshell.sendkeys('{ESC}'); >> install_bandizip.ps1
echo sleep 1; >> install_bandizip.ps1
echo } >> install_bandizip.ps1
echo del BANDIZIP-SETUP-KR.EXE >> install_bandizip.ps1
echo del install_bandizip.ps1 >> install_bandizip.ps1

powershell -noprofile -command "&{ start-process powershell -windowstyle hidden -ArgumentList '-noprofile -file %cd%\install_bandizip.ps1' -verb RunAs}"
::powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -file %cd%\install_bandizip.ps1' -verb RunAs}"
start %cd%\BANDIZIP-SETUP-KR.EXE

exit /b
::Power shell hidden option
::https://stackoverflow.com/questions/1802127/how-to-run-a-powershell-script-without-displaying-a-window

::power shell run on admin
::https://social.technet.microsoft.com/Forums/ie/en-US/acf70a31-ceb4-4ea5-bac1-be2b25eb5560/how-to-run-as-admin-powershellps1-file-calling-in-batch-file?forum=winserverpowershell

::powershell mouse event
::https://stackoverflow.com/questions/39353073/how-i-can-send-mouse-click-in-powershell