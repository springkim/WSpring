::
::  install_wsl(Windows Subsystem for Linux).bat
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
powershell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if not exist %APPDATA%\..\Local\lxss (
	lxrun /install
)


powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ypxtonz2shil2se/Xming-6-9-0-31-setup.exe?dl=1','Xming-6-9-0-31-setup.exe')"
if not exist %SystemDrive%\install\Logs\ md %SystemDrive%\install\Logs\
"%~dp0Xming-6-9-0-31-setup.exe" /verysilent /norestart /LOG="%systemdrive%\install\logs\Xming_6_9_0_31.log"
del /S /Q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Uninstall Xming.lnk" >;NUL 2>&1
del /S /Q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Xming on the Web.lnk" >;NUL 2>&1
netsh advfirewall firewall add rule name="Xming" dir=in action=allow program="C:\Program Files\Xming\Xming.exe" enable=yes LocalSubnet profile=domain
del Xming-6-9-0-31-setup.exe
echo "WSL and XMing installed!"
echo "Please, Run WSL and download USpring(https://github.com/springkim/USpring) for setup WSL."



::remove
:: lxrun /uninstall /full
echo Finish!!
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::https://sccmpackager.wordpress.com/category/xming-deployment/xming-silent-install/