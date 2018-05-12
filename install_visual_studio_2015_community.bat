::
::  install_visual_studio_2015_community.bat
::  WSpring
::
::  Created by kimbomm on 2018. 03. 26...
::  Copyright 2017-2018 kimbomm. All rights reserved.
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
title install_visual_studio_2015_community
echo Downloading...
curlw -L "https://www.dropbox.com/s/1spk9799fqie7bg/vs2015community.7z?dl=1" "%TEMP%\vs2015community.7z"

echo Unzipping...
cd %TEMP%
call :Download7z
7z x vs2015community.7z -y -o"%TEMP%"
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
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://www.dropbox.com/s/utcz5y6rqf6j0zq/7z.exe?dl=1" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://www.dropbox.com/s/z4sj3yf0rn3k6nk/7z.dll?dl=1" -o "%WINDIR%\system32\7z.dll"
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
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xytowp38v6d61lh/curl.exe?dl=1','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ibgh7o7do1voctb/ca-bundle.crt?dl=1','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
