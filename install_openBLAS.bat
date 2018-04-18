::
::  install_openblas.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
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
echo install_openblas
echo Downloading...
cd %TEMP%
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/9ax0hovyachz9hh/openblas%28wspring%29.zip?dl=1','openblas(wspring).zip')"
echo Unzipping...
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('openblas(wspring).zip', 'openblas(wspring)'); }"
echo Installing...
::Set dlls
xcopy /Y "openblas(wspring)\MSVC14\bin\*.dll" "C:\Windows\System32\" >NUL
::xcopy /Y "openblas(wspring)\MinGW64\bin\*.dll" "C:\Windows\System32\" >NUL

setlocal EnableDelayedExpansion
set msvc[0]=14
set msvc[1]=12
set msvc[2]=11
set msvc[3]=10
FOR /L %%i in (0,1,3) do (
	set version=!msvc[%%i]!
	set /A version2=version + 1
	if exist "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include" (
		echo Install openblas in Visual Studio 20!version2!
		xcopy /Y "openblas(wspring)\MSVC14\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include" /e /h /k >NUL
		xcopy /Y "openblas(wspring)\MSVC14\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\lib\amd64\" >NUL
	)
)
if exist "C:\MinGW64\" (
	echo Install openblas in MinGW64
	xcopy /Y "openblas(wspring)\MinGW64\include\*.*" "C:\MinGW64\x86_64-w64-mingw32\include" /e /h /k >NUL
	xcopy /Y "openblas(wspring)\MinGW64\lib\*.*" "C:\MinGW64\x86_64-w64-mingw32\lib" >NUL
)
RMDIR /S /Q "openblas(wspring)"
DEL "openblas(wspring).zip"
echo Finish!!
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
