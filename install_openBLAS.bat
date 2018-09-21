::
::  install_openblas.bat
::  WSpring
::
::  Created by kimbomm on 2018. 04. 26...
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
::dependency
if not exist "C:\Strawberry\perl\bin\perl.exe" (
	echo OpenBLAS installer needs perl.
	if exist "install_perl.bat" call install_perl.bat
)

::start
title install_openblas
echo Downloading...
cd %TEMP%
call :SafeRMDIR "build_openblas"
mkdir build_openblas
cd build_openblas
::GOTO DOWNLOADSKIP
git clone https://github.com/xianyi/OpenBLAS
:DOWNLOADSKIP

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
if exist "C:\MinGW64\" (
	set CC[%CCC%]="MinGW Makefiles"
	set CMAKEDIR[%CCC%]="build_mingw"
	set CCDIR[%CCC%]=""
	set dst_include_dir[%CCC%]="C:\MinGW64\x86_64-w64-mingw32\include\"
	set dst_lib_dir[%CCC%]="C:\MinGW64\x86_64-w64-mingw32\lib\"
	set src_lib_dir[%CCC%]=mingw
	set extension[%CCC%]=a
	set /a CCC=%CCC%+1
)
set /a CCC=%CCC%-1
::CC = C Compiler
::CCC = C Compiler Count

setlocal EnableDelayedExpansion
FOR /L %%i in (0,1,%CCC%) do (
	if not exist !CMAKEDIR[%%i]! md !CMAKEDIR[%%i]!
	cd !CMAKEDIR[%%i]!
	cmake ..\OpenBLAS -G !CC[%%i]! -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=build -DUSE_THREAD=0 -DCMAKE_DEBUG_POSTFIX=d

	if !CC[%%i]! == "MinGW Makefiles"  (
		cmake --build . --config Release
		cmake --build . --target install
	) else (
		cmake --build . --config Release --target ALL_BUILD
		cmake --build . --config Release --target INSTALL
		cmake --build . --config Debug --target ZERO_CHECK
		cmake --build . --config Debug --target driver_level2
		cmake --build . --config Debug --target driver_level3
		cmake --build . --config Debug --target driver_others
		cmake --build . --config Debug --target interface
		cmake --build . --config Debug --target kernel
		cmake --build . --config Debug --target openblas
		xcopy /Y "lib\DEBUG\openblasd.dll" "build\bin\"
		xcopy /Y "lib\DEBUG\openblasd.lib" "build\lib\"
		echo. >> build\include\openblas\cblas.h
		echo #ifdef _DEBUG >> build\include\openblas\cblas.h
		echo. >> build\include\openblas\cblas.h
		echo #pragma comment^(lib,"openblasd.lib"^) >> build\include\openblas\cblas.h
		echo. >> build\include\openblas\cblas.h
		echo #else >> build\include\openblas\cblas.h
		echo. >> build\include\openblas\cblas.h
		echo #pragma comment^(lib,"openblas.lib"^) >> build\include\openblas\cblas.h
		echo #endif >> build\include\openblas\cblas.h
	)
	xcopy /Y "build\include\openblas\*.*" !dst_include_dir[%%i]! /e /h /k 2>&1 >NUL
	xcopy /Y "build\lib\*openblas*" !dst_lib_dir[%%i]! 2>&1 >NUL
	if exist "build\bin\" (
		xcopy /Y "build\bin\*openblas*" "C:\Windows\System32\" 2>&1 >NUL
	)
	cd ..
)
endlocal

pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
