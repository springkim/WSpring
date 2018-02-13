::
::  install_opencv.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
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
cd %TEMP%
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/uh97fag1yie0o8p/opencv3.4.0%28wspring%29.zip?dl=1','opencv(wspring).zip')"
echo Unzipping...
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv(wspring).zip', 'opencv(wspring)'); }"
echo Install opencv ...
::Set dlls
del "C:\Windows\System32\opencv_*" >NUL
del "C:\Windows\System32\libopencv_*" >NUL
xcopy /Y "opencv(wspring)\MSVC14\bin\*.dll" "C:\Windows\System32\" >NUL
xcopy /Y "opencv(wspring)\MinGW64\bin\*.dll" "C:\Windows\System32\" >NUL

setlocal EnableDelayedExpansion
set msvc[0]=14
set msvc[1]=12
set msvc[2]=11
set msvc[3]=10
FOR /L %%i in (0,1,3) do (
	set version=!msvc[%%i]!
	set /A version2=version + 1
	if exist "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include" (
		echo Install opencv in Visual Studio 20!version2!
		call :SafeRMDIR "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include\opencv"
		call :SafeRMDIR "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include\opencv2"
		call :SafeRMDIR "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\lib\amd64\opencv"
		xcopy /Y "opencv(wspring)\MSVC14\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\include" /e /h /k >NUL
		mkdir "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\lib\amd64\opencv\"
		xcopy /Y "opencv(wspring)\MSVC14\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio !version!.0\VC\lib\amd64\opencv\" >NUL
	)
)
if exist "C:\MinGW64\" (
	echo Install opencv in MinGW64
	xcopy /Y "opencv(wspring)\MinGW64\include\*.*" "C:\MinGW64\x86_64-w64-mingw32\include" /e /h /k >NUL
	xcopy /Y "opencv(wspring)\MinGW64\lib\*.*" "C:\MinGW64\x86_64-w64-mingw32\lib" >NUL
)
if exist "C:\python27\Lib\site-packages\" (
	cd "C:\python27"
	echo Install opencv in Python2.7
	pip2 install numpy
	pip2 install matplotlib
	pip2 install opencv-python
)
if exist "C:\python36\Lib\site-packages\" (
	cd "C:\python36"
	echo Install opencv in Python3.6
	pip3 install numpy
	pip3 install matplotlib
	pip3 install opencv-python
)
cd %TEMP%
RMDIR /S /Q "opencv(wspring)"
DEL "opencv(wspring).zip"
echo Finish!!
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b