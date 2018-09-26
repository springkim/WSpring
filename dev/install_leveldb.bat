::
::  install_leveldb.bat
::  WSpring
::
::  Created by kimbomm on 2018. 09. 24...
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

::start
title install_leveldb
echo Downloading...
cd %TEMP%
call :SafeRMDIR "build_leveldb"
mkdir build_leveldb
cd build_leveldb
::GOTO DOWNLOADSKIP
git clone https://github.com/google/leveldb
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
pause
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC" (
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
pause
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
	cmake ..\leveldb -G !CC[%%i]! -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=build -DBUILD_SHARED_LIBS=ON
	if !CC[%%i]! == "MinGW Makefiles"  (
		cmake --build . --config Release
		cmake --build . --target install
	) else (
		cmake --build . --config Release --target ALL_BUILD
		cmake --build . --config Release --target INSTALL
		cmake --build . --config Debug --target ALL_BUILD
		cmake --build . --config Debug --target INSTALL
		call :AddPragmaComment "build\include\leveldb"
	)
	::xcopy /Y "build\include\*.*" !dst_include_dir[%%i]! /e /h /k 2>&1 >NUL
	::xcopy /Y "build\lib\*glog*" !dst_lib_dir[%%i]! 2>&1 >NUL
	::if exist "build\bin\" (
	::	xcopy /Y "build\bin\*glog*" "C:\Windows\System32\" 2>&1 >NUL
	::)
	cd ..
)
endlocal
::call :SafeRMDIR "build_leveldb"
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::안돌아감
:AddPragmaComment
SETLOCAL EnableDelayedExpansion
pushd %CD%
cd %~1
FOR /R %%E IN (./*.*) DO (
	 set file=%%~nxE
	 echo. >> !file!
	 echo #ifdef _DEBUG >> !file!
	 echo #pragma comment^(lib,"glogd.lib"^) >> !file!
	 echo #else >> !file!
	 echo #pragma comment^(lib,"glog.lib"^) >> !file!
	 echo #endif >> !file!
)
ENDLOCAL
popd
exit /b
