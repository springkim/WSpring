::
::  install_clion.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 04...
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

::::::::::::install
title install_clion
cd %TEMP%
echo Downloading...
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://confluence.jetbrains.com/display/CLION/Release+notes'; $HTML.Links.outerText > clion_latest.txt"
powershell "get-content clion_latest.txt -ReadCount 1000 | foreach { $_ -match '^CLion [\d\.]+ ' } | foreach { $_.Split(' ')[1] } | out-file -encoding ascii clion_ver.txt"
powershell "get-content clion_ver.txt | sort -Descending | get-unique | out-file -encoding ascii clion_ver2.txt"
set /p "VER="<"clion_ver2.txt"


if not exist "%SystemDrive%\Program Files\JetBrains" md "%SystemDrive%\Program Files\JetBrains"

::#section=windows
curlw -L "https://download.jetbrains.com/cpp/CLion-%VER%.zip" -o "%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip"
echo Unzipping...
call :SafeRMDIR "%SystemDrive%\Program Files\JetBrains\CLion-%VER%"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip', '%SystemDrive%\Program Files\JetBrains\CLion-%VER%'); }"
echo Download settings
curlw -L "https://www.dropbox.com/s/j6clpd1r9yfv2vk/settings.jar?dl=1" -o "%SystemDrive%\Program Files\JetBrains\CLion-%VER%\settings.jar"

del "%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip"
DEL "%TEMP%\clion_latest.txt"
DEL "%TEMP%\clion_ver.txt"
DEL "%TEMP%\clion_ver2.txt"
if not exist "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains" md "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\JetBrains CLion %VER%.lnk');$s.TargetPath='%SystemDrive%\Program Files\JetBrains\clion-%VER%\bin\clion64.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\JetBrains CLion %VER%.lnk');$s.TargetPath='%SystemDrive%\Program Files\JetBrains\clion-%VER%\bin\clion64.exe';$s.Save()"

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
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
