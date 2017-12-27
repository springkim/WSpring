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
	
	
::Create 3rdparty folder for local library
if not exist 3rdparty (
	mkdir 3rdparty\include
	mkdir 3rdparty\lib\x64
	mkdir 3rdparty\lib\x86
	mkdir 3rdparty\bin\x64
	mkdir 3rdparty\bin\x86
)

::::::::::::::::::::Select CC::::::::::::::::::::
set CC="Visual Studio 14 2015 Win64"

::::::::::::::::::::::::::::::::::::::::::::::::::

::start
echo Git clone openBLAS
git clone https://github.com/xianyi/OpenBLAS
echo Build openBLAS ...
cd openBLAS
git checkout
mkdir build
cd build
cmake .. -G %CC% -DCMAKE_BUILD_TYPE=RELEASE
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL

cd ../../
echo #pragma comment(lib,"libopenblas.lib") >> OpenBLAS\cblas.h
::Set local library
mkdir 3rdparty\include\openblas
xcopy /d /i /Y "OpenBlas\*.h" "3rdparty\include\openblas\"
xcopy /d /i /Y "OpenBlas\build\*.h" "3rdparty\include\openblas\"
xcopy /d /i /Y "OpenBlas\build\lib\RELEASE\*.lib" "3rdparty\lib\x64"
xcopy /d /i /Y "OpenBlas\build\lib\RELEASE\*.dll" "3rdparty\bin\x64"
::Set global library
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	echo Install OpenBLAS in Visual Studio 2015
	call :SafeRMDIR "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\openblas"
	del "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\libopenblas.lib"
	del "C:\Windows\System32\libopenblas.dll"
	mkdir "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\openblas"
	xcopy /d /i /Y "OpenBlas\*.h" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\openblas\"
	xcopy /d /i /Y "OpenBlas\build\*.h" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\openblas\"
	xcopy /d /i /Y "OpenBlas\build\lib\RELEASE\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\"
	xcopy /d /i /Y "OpenBlas\build\lib\RELEASE\*.dll" "C:\Windows\System32\"
)

call :SafeRMDIR OpenBLAS
call :SafeRMDIR OpenBLAS
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b