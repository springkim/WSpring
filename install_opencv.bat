::
::  install_opencv.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 2...
::  Copyright 2017 kimbom. All rights reserved.
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
echo Download opencv
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ewyjzutjjgmzeqi/opencv%28wspring%29.zip?dl=1','opencv(wspring).zip')"
echo Unzip opencv
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv(wspring).zip', 'opencv(wspring)'); }"
echo Install opencv ...
xcopy /Y "opencv(wspring)\bin\*.dll" "C:\Windows\System32\" >NUL

if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	echo Install opencv in Visual Studio 2015
	xcopy /Y "opencv(wspring)\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" /e /h /k >NUL
	xcopy /Y "opencv(wspring)\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\" >NUL
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include" (
	echo Install opencv in Visual Studio 2013
	xcopy /Y "opencv(wspring)\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include" /e /h /k >NUL
	xcopy /Y "opencv(wspring)\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\amd64\" >NUL
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\include" (
	echo Install opencv in Visual Studio 2012
	xcopy /Y "opencv(wspring)\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\include" /e /h /k >NUL
	xcopy /Y "opencv(wspring)\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\lib\amd64\" >NUL
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include" (
	echo Install opencv in Visual Studio 2010
	xcopy /Y "opencv(wspring)\include\*.*" "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include" /e /h /k >NUL
	xcopy /Y "opencv(wspring)\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\lib\amd64\" >NUL
)
if exist "C:\python27\Lib\site-packages\" (
	echo Install opencv in Python2.7
	pip install numpy >NUL
	pip install matplotlib >NUL
	xcopy /Y "opencv(wspring)\cv2.pyd" "C:\python27\Lib\site-packages\" >NUL
)

RMDIR /S /Q "opencv(wspring)"
DEL "opencv(wspring).zip"
pause
exit /b