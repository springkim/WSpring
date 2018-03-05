::
::  install_opencv.bat
::  WSpring
::
::  Created by kimbomm on 2018. 03. 01...
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

::start
echo install_opencv
echo Downloading...
::cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/opencv/opencv/releases';($HTML.ParsedHtml.getElementsByTagName('a') | %% href) > opencv.txt"
powershell "get-content opencv.txt -ReadCount 1000 | foreach { $_ -match 'archive' } | out-file -encoding ascii opencv_link.txt"
powershell "get-content opencv_link.txt -ReadCount 1000 | foreach { $_ -match 'zip' } | out-file -encoding ascii opencv_link_zip.txt"

powershell "get-content opencv_link_zip.txt -ReadCount 1000 | foreach { $_ -match '/3.' } | out-file -encoding ascii opencv_link3.txt"
powershell "get-content opencv_link_zip.txt -ReadCount 1000 | foreach { $_ -match '/2.' } | out-file -encoding ascii opencv_link2.txt"

set /p "cv2="<"opencv_link2.txt"
set /p "cv3="<"opencv_link3.txt"

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com%cv3:~6%','cv3.zip')"
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com%cv2:~6%','cv2.zip')"

powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cv2.zip', 'build_opencv'); }"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cv3.zip', 'build_opencv'); }"

cd build_opencv
setlocal EnableDelayedExpansion
if exist "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include" (
	set CC[0]="Visual Studio 12 2013 Win64"
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	set CC[0]="Visual Studio 14 2015 Win64"
)
if exist "C:\MinGW64\" (
	set CC[1]="MinGW Makefiles"
)
::loop 컴파일러 종류별로 순회하면서 빌드(cv3만 빌드할까 그냥 하...)


del opencv.txt
del opencv_link.txt
del opencv_link_zip.txt
del opencv_link2.txt
del opencv_link3.txt
