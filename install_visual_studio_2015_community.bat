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
echo install_visual_studio_2015_community
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/zjgulyaambq5t9r/vs2015community.zip?dl=1','%TEMP%\vs2015community.zip')"
echo Unzipping...
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\vs2015community.zip', '%TEMP%'); }"
echo Installing...
cd "%TEMP%\vs2015community"
call vs_community.exe /AdminFile %CD%\AdminDeployment.xml /s
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\Visual Studio 2015.lnk');$s.TargetPath='%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe';$s.Save()"

start /wait "VSIX" "%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\VSIXInstaller.exe" -q "ColorThemeEditor.vsix"
start /wait "VSIX" "%SystemDrive%\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\VSIXInstaller.exe" -q "Open Command Line v2.1.179.vsix"

DEL "%TEMP%\vs2015community.zip"
call SafeRMDIR "%TEMP%\vs2015community"

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
