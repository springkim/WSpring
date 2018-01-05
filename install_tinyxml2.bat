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
	mkdir 3rdparty\staticlib\x64
	mkdir 3rdparty\staticlib\x86
)

::::::::::::::::::::Select CC::::::::::::::::::::
set CC="Visual Studio 14 2015 Win64"

::::::::::::::::::::::::::::::::::::::::::::::::::

::start
echo Git clone tinyxml2
git clone https://github.com/leethomason/tinyxml2
echo Build tinyxml2 ...
cd tinyxml2
git checkout
mkdir build
cd build
cmake ..^
 -G %CC%^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_SHARED_LIBS:BOOL=OFF^
 -DBUILD_STATIC_LIBS:BOOL=ON^
 -DBUILD_TESTS:BOOL=OFF^
;
cmake .. -G %CC% -DCMAKE_BUILD_TYPE=RELEASE
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL

cd ../../
echo #ifdef _DEBUG >> tinyxml2\build\build\include\tinyxml2.h
echo #pragma comment(lib,"tinyxml2d.lib") >> tinyxml2\build\build\include\tinyxml2.h
echo #else >> tinyxml2\build\build\include\tinyxml2.h
echo #pragma comment(lib,"tinyxml2.lib") >> tinyxml2\build\build\include\tinyxml2.h
echo #endif >> tinyxml2\build\build\include\tinyxml2.h
::Set local library
xcopy /d /i /Y "tinyxml2\build\build\include\*.h" "3rdparty\include\"
xcopy /d /i /Y "tinyxml2\build\build\lib\*.lib" "3rdparty\staticlib\x64"
::Set global library
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	echo Install tinyxml2 in Visual Studio 2015
	xcopy /d /i /Y "tinyxml2\build\build\include\*.h" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\"
	xcopy /d /i /Y "tinyxml2\build\build\lib\*.lib" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\"
)
call :SafeRMDIR tinyxml2
call :SafeRMDIR tinyxml2
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b