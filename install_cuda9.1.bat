::
::  install_cuda9.1.bat
::  WSpring
::
::  Created by kimbomm on 2018. 05. 08...
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

pushd "%CD%"
title install cuda9.0
echo Downloading...

curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85_win10.exe" -o "%TEMP%\cuda9.1.exe"
curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.1_windows.exe" -o "%TEMP%\cuda9.1_1.exe"
curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.2_windows.exe" -o "%TEMP%\cuda9.1_2.exe"
curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.3_windows.exe" -o "%TEMP%\cuda9.1_3.exe"

echo Installing...
cd "%TEMP%"
call cuda9.1.exe -s -noreboot
call cuda9.1_1.exe -s -noreboot
call cuda9.1_2.exe -s -noreboot
call cuda9.1_3.exe -s -noreboot
del "%TEMP%\cuda9.1.exe"
del "%TEMP%\cuda9.1_1.exe"
del "%TEMP%\cuda9.1_2.exe"
del "%TEMP%\cuda9.1_2.exe"
popd
::Encoding convert
call :DownloadIConv
::ASCII -> Unicode
set dst="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.1\include"
set ascii=ASCII
set utf8=UTF-8
set unknown=unkno
SETLOCAL EnableDelayedExpansion
for /f "delims=" %%f in ('dir %dst% /a-d /s /b') do (
	call enca -L none -e "%%f" > tmp.txt
	set /p encoding=<tmp.txt
	set encoding=!encoding:~0,5!
	if !encoding! EQU %ascii% (
		iconv -c -f ASCII -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %utf8% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %unknown% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	del tmp.txt
)
endlocal

echo Finish!!
pause
exit /b
:DownloadIConv
::Do not use [where] command for search iconv. Because Strawberry has also iconv.
if not exist "%WINDIR%\system32\iconv.exe" (
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/iconv.exe" -o "%WINDIR%\system32\iconv.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libcharset1.dll" -o "%WINDIR%\SysWOW64\libcharset1.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libiconv2.dll" -o "%WINDIR%\SysWOW64\libiconv2.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libintl3.dll" -o "%WINDIR%\SysWOW64\libintl3.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/enca.exe" -o "%WINDIR%\system32\enca.exe"
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
