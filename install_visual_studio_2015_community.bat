::
::  install_visual_studio_2015_community.bat
::  WSpring
::
::  Created by kimbomm on 2018. 03. 26...
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
title install_visual_studio_2015_community
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/57s8z52xq5vfjra/vs2015community.7z.001?dl=1','%TEMP%\vs2015community.7z.001')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/9xo6v4omymmitvg/vs2015community.7z.002?dl=1','%TEMP%\vs2015community.7z.002')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/597anec8ig0jc70/vs2015community.7z.003?dl=1','%TEMP%\vs2015community.7z.003')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/nhcfnfbykvdlkc4/vs2015community.7z.004?dl=1','%TEMP%\vs2015community.7z.004')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/0bdnhj2z2c9fv24/vs2015community.7z.005?dl=1','%TEMP%\vs2015community.7z.005')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/rhy8ax8mtgatf5l/vs2015community.7z.006?dl=1','%TEMP%\vs2015community.7z.006')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ibt3diko3aaen6t/vs2015community.7z.007?dl=1','%TEMP%\vs2015community.7z.007')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/7y8bg7atkchyv7d/vs2015community.7z.008?dl=1','%TEMP%\vs2015community.7z.008')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ib1v1ctthljfajz/vs2015community.7z.009?dl=1','%TEMP%\vs2015community.7z.009')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/fxxz7ce84ncb927/vs2015community.7z.010?dl=1','%TEMP%\vs2015community.7z.010')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/l75rkoj4qxe3jwr/vs2015community.7z.011?dl=1','%TEMP%\vs2015community.7z.011')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/8cohrdxoz5i75z6/vs2015community.7z.012?dl=1','%TEMP%\vs2015community.7z.012')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xo3th2sxcuy7xl2/vs2015community.7z.013?dl=1','%TEMP%\vs2015community.7z.013')"
echo Unzipping...
cd %TEMP%
call :Download7z
7z x vs2015community.7z.001 -y -o"%TEMP%"
echo Installing...
cd "%TEMP%\vs2015community"
call vs_community.exe /AdminFile %CD%\AdminDeployment.xml /s
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\Visual Studio 2015.lnk');$s.TargetPath='%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe';$s.Save()"

start /wait "VSIX" "%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\VSIXInstaller.exe" -q "ColorThemeEditor.vsix"
start /wait "VSIX" "%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\VSIXInstaller.exe" -q "Open Command Line v2.1.179.vsix"

DEL "%TEMP%\vs2015community.zip"
call :SafeRMDIR "%TEMP%\vs2015community"

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::https://msdn.microsoft.com/ko-kr/library/mt720584.aspx
::https://social.msdn.microsoft.com/Forums/vstudio/en-US/826e52b6-a32b-4ef4-9bab-ed3c62038284/is-there-a-way-to-install-a-vsix-file-in-quitesilent-mode?forum=vsx

:Download7z
where 7z
if %ERRORLEVEL% NEQ 0 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/z4sj3yf0rn3k6nk/7z.dll?dl=1','%WINDIR%\system32\7z.dll')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/utcz5y6rqf6j0zq/7z.exe?dl=1','%WINDIR%\system32\7z.exe')"
)
exit /b
