::
::  install_cudnn.1.bat
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
title install cudnn7.1
echo Downloading...
cd %TEMP%
nvcc -V | findstr /C:"release 8.0" > cuda_ver.txt
set /p "ver80="<"cuda_ver.txt"
if not "%ver80%" equ "" (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/fcro8sch6hdylxy/cudnn-8.0-windows10-x64-v7.1.zip?dl=1','cudnn.zip')"
)
nvcc -V | findstr /C:"release 9.0" > cuda_ver.txt
set /p "ver90="<"cuda_ver.txt"
if not "%ver90%" equ "" (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ypatpohwadnsfcl/cudnn-9.0-windows10-x64-v7.1.zip?dl=1','cudnn.zip')"
)
nvcc -V | findstr /C:"release 9.1" > cuda_ver.txt
set /p "ver91="<"cuda_ver.txt"
if not "%ver91%" equ "" (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/uunuql87laxb6lj/cudnn-9.1-windows10-x64-v7.1.zip?dl=0','cudnn.zip')"
)
DEL cuda_ver.txt
echo Installing...
call :SafeRMDIR "%TEMP%\cuda"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cudnn.zip', '%TEMP%'); }"

xcopy /Y "cuda\include\*.*" "%CUDA_PATH%\include\" /e /h /k 2>&1 >NUL
xcopy /Y "cuda\lib\x64\*.*" "%CUDA_PATH%\lib\x64\" /e /h /k 2>&1 >NUL
xcopy /Y "cuda\bin\*.*" "%CUDA_PATH%\bin\" /e /h /k 2>&1 >NUL
call :SafeRMDIR "%TEMP%\cuda"
DEL "cudnn.zip"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
