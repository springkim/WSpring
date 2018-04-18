::
::  install_cmake.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02 22...
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
title install_cmake
pushd "%CD%"
echo Downloading...
powershell "$HTML=Invoke-WebRequest -Uri 'https://cmake.org/download/' -UseBasicParsing;($HTML.Links.href) > %TEMP%\parse_cmake.txt"
::find win64-x64.zip
powershell "get-content %TEMP%\parse_cmake.txt -ReadCount 1000 | foreach { $_ -match 'win64-x64.zip' } | out-file -encoding ascii %TEMP%\parse_cmake1.txt"
::without RC version
powershell "get-content %TEMP%\parse_cmake1.txt -ReadCount 1000 | foreach { $_ -notMatch 'rc' } | out-file -encoding ascii %TEMP%\parse_cmake2.txt"

set /p "url="<"%TEMP%\parse_cmake2.txt"
::echo %url%

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://cmake.org%url%','%TEMP%\CMake.zip')"
echo Unzipping...
call :SafeRMDIR "%SystemDrive%\Program Files\CMake"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\CMake.zip', '%SystemDrive%\Program Files\CMake'); }"
echo Installing...
CD "%SystemDrive%\Program Files\CMake"
CD cmake*
move bin ..\
move doc ..\
move man ..\
move share ..\
popd
call :DownloadSetw
setw "C:\Program Files\CMake\bin"
DEL "%TEMP%\CMake.zip"
DEL "%TEMP%\parse_cmake.txt"
DEL "%TEMP%\parse_cmake1.txt"
DEL "%TEMP%\parse_cmake2.txt"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\cmake-gui.lnk');$s.TargetPath='%SystemDrive%\Program Files\CMake\bin\cmake-gui.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\cmake-gui.lnk');$s.TargetPath='%SystemDrive%\Program Files\CMake\bin\cmake-gui.exe';$s.Save()"

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

:DownloadSetw
where setw
if %ERRORLEVEL% NEQ 0 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/6m35ug7psddzh96/setw.exe?dl=1','%WINDIR%\system32\setw.exe')"
)
exit /b
