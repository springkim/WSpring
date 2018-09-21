::
::  install_hdf5.bat
::  WSpring
::
::  Created by kimbomm on 2018. 07. 05...
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
title install_zlib
echo Downloading...
cd %TEMP%
curlw -L "https://github.com/springkim/WSpring/releases/download/library/hdf5-1.10.2.zip" -o "hdf5.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\hdf5.zip', '%TEMP%\hdf5'); }"
set CCC=0
if exist "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include" (
	set CC[%CCC%]="Visual Studio 12 2013 Win64"
	set CMAKEDIR[%CCC%]="build_vc12"
	set CCDIR[%CCC%]="vc12"
	set dst_include_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include\"
	set dst_lib_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\amd64\"
	set src_lib_dir[%CCC%]=vc12
	set extension[%CCC%]=lib
	set /a CCC=%CCC%+1
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	set CC[%CCC%]="Visual Studio 14 2015 Win64"
	set CMAKEDIR[%CCC%]="build_vc14"
	set CCDIR[%CCC%]="vc14"
	set dst_include_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\"
	set dst_lib_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\"
	set src_lib_dir[%CCC%]=vc14
	set extension[%CCC%]=lib
	set /a CCC=%CCC%+1
)
if exist 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC' (
	pushd %cd%
	cd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\"
	dir /B > "%TEMP%\msvc2017path.txt"
	set /p "msvcnum="<"%TEMP%\msvc2017path.txt"
	popd
	set CC[%CCC%]="Visual Studio 15 2017 Win64"
	set CMAKEDIR[%CCC%]="build_vc15"
	set CCDIR[%CCC%]="vc15"
	set dst_include_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\%msvcnum%\include\"
	set dst_lib_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\%msvcnum%\lib\x64\"
	set src_lib_dir[%CCC%]=vc15
	set extension[%CCC%]=lib
	set /a CCC=%CCC%+1
)

set /a CCC=%CCC%-1
::CC = C Compiler
::CCC = C Compiler Count

xcopy /Y "hdf5\bin\*.*" "%SystemRoot%\System32\" /e /h /k 2>&1 >NUL

setlocal EnableDelayedExpansion
FOR /L %%i in (0,1,%CCC%) do (
	xcopy /Y "hdf5\include\*.*" !dst_include_dir[%%i]! /e /h /k 2>&1 >NUL
	xcopy /Y "hdf5\lib\*.lib" !dst_lib_dir[%%i]! 2>&1 >NUL
)
endlocal
call :SafeRMDIR "hdf5"
DEL "hdf5.zip"
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/curl.exe','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/ca-bundle.crt','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
