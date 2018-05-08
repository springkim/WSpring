::
::  install_cuda9.0.bat
::  WSpring
::
::  Created by kimbomm on 2018. 05. 08...
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


pushd "%CD%"
title install cuda9.0
echo Downloading...

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/u81h7uw5dc4j8z7/cuda_9.0.176_win10.exe?dl=1','%TEMP%\cuda9.0.exe')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/lr8ut0gnvq8h197/cuda_9.0.176.1_windows.exe?dl=1','%TEMP%\cuda9.0_1.exe')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/0rcdol9an4ezl3y/cuda_9.0.176.2_windows.exe?dl=1','%TEMP%\cuda9.0_2.exe')"

echo Installing...
cd "%TEMP%"
call cuda9.0.exe -s -noreboot
call cuda9.0_1.exe -s -noreboot
call cuda9.0_2.exe -s -noreboot
del "%TEMP%\cuda9.0.exe"
del "%TEMP%\cuda9.0_1.exe"
del "%TEMP%\cuda9.0_2.exe"
popd
::Encoding convert
call :DownloadIConv
::ASCII -> Unicode
set dst="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\include"
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

:DownloadIConv
::Do not use [where] command for search iconv. Because Strawberry has also iconv.
if not exist "%WINDIR%\system32te\iconv.exe" (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/2ybjknzhc1cjdj3/iconv.exe?dl=1','%WINDIR%\system32\iconv.exe')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xvsdm13dg9yu1x3/libcharset1.dll?dl=1','%WINDIR%\SysWOW64\libcharset1.dll')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ixynh3op3sf8h0x/libiconv2.dll?dl=1','%WINDIR%\SysWOW64\libiconv2.dll')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/2zkuv5kinarqb9j/libintl3.dll?dl=1','%WINDIR%\SysWOW64\libintl3.dll')"
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/vg7ou16vs0qytxi/enca.exe?dl=1','%WINDIR%\system32\enca.exe')"
)
exit /b