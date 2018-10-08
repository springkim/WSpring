@if (@CodeSection == @Batch) @then
::
::  build_dlib.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 19...
::  Copyright 2018 kimbomm. All rights reserved.
::
@echo off
call :CCSelect
call ::SET_CMAKE_COMPILER

call :SafeRMDIR "build_dlib"
mkdir "build_dlib"
cd "build_dlib"

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/davisking/dlib/releases' -UseBasicParsing;($HTML.Links.href) > dlib_releases.txt"
powershell "get-content dlib_releases.txt -ReadCount 1000 | foreach { $_ -match 'archive' } | out-file -encoding ascii dlib_releases2.txt"
powershell "get-content dlib_releases2.txt -ReadCount 1000 | foreach { $_ -match 'zip' } | out-file -encoding ascii dlib_releases3.txt"

set /p "dlibver="<"dlib_releases3.txt"
echo "https://github.com%dlibver%"
curlw -L "https://github.com%dlibver%" -o "dlib.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('dlib.zip', '.'); }"
move dlib-* dlib


mkdir build
cd build
cmake ../dlib^
 -G %CMAKE_COMPILER%^
 -T host=x64^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DCUDA_USE_STATIC_CUDA_RUNTIME=ON^
 -DDLIB_USE_CUDA=ON^
 -Dcudnn=..\cuda\lib\x64\cudnn.lib^
 -Dcudnn_include=..\cuda\include\^
 -DUSE_AVX_INSTRUCTIONS=ON^
 -DUSE_SSE2_INSTRUCTIONS=ON^
 -DUSE_SSE2_INSTRUCTIONS=ON^
;
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL

pause
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SET_CMAKE_COMPILER
if %COMPILER% == "exit" (
	pause
	exit
)
if %COMPILER% == "Visual Studio 2017 x64" (
	set CMAKE_COMPILER="Visual Studio 15 2017 Win64"
)
if %COMPILER% == "Visual Studio 2015 x64" (
	set CMAKE_COMPILER="Visual Studio 14 2015 Win64"
)
if %COMPILER% == "Visual Studio 2013 x64" (
	set CMAKE_COMPILER="Visual Studio 12 2013 Win64"
)
if %COMPILER% == "MinGW x64" (
	set CMAKE_COMPILER="MinGW Makefiles"
)
if %COMPILER% == "Visual Studio 2017 x86" (
	set CMAKE_COMPILER="Visual Studio 15 2017"
)
if %COMPILER% == "Visual Studio 2015 x86" (
	set CMAKE_COMPILER="Visual Studio 14 2015"
)
if %COMPILER% == "Visual Studio 2013 x86" (
	set CMAKE_COMPILER="Visual Studio 12 2013"
)
if %COMPILER% == "MinGW x86" (
	set CMAKE_COMPILER="MinGW Makefiles"
)
echo Selected compiler : %CMAKE_COMPILER%
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::reference : http://reboot.pro/topic/20968-basic-batch-menu-using-arrows-keys/
:CCSelect
setlocal EnableDelayedExpansion
set numOpts=0
if "%1" equ "" set OPT="Visual Studio 2017 x64" "Visual Studio 2015 x64" "Visual Studio 2013 x64" "MinGW x64" "Visual Studio 2017 x86" "Visual Studio 2015 x86" "Visual Studio 2013 x86" "MinGW x86"
if not "%1" equ "" set OPT=%*
for %%a in (%OPT%) do (
   set /A numOpts+=1
   set aa=%%a
   set option[!numOpts!]=!aa:"=!
)
set /A numOpts+=1
set "option[!numOpts!]=exit"
rem Clear previous doskey history
doskey /LISTSIZE=!numOpts!
rem Fill doskey history with menu options
cscript //nologo /E:JScript "%~f0" EnterOpts
for /L %%i in (1,1,%numOpts%) do set /P "COMPILER="
:nextOpt
cls
rem echo MULTI-LINE MENU WITH OPTIONS SELECTION
rem echo/
rem Send a F7 key to open the selection menu
cscript //nologo /E:JScript "%~f0" > nul
set COMPILER=
set /P "COMPILER=Select the desired option: " > nul
endlocal & set COMPILER="%COMPILER%"
doskey /LISTSIZE=0
cls
goto :eof
@end
var wshShell = WScript.CreateObject("WScript.Shell"),
    envVar = wshShell.Environment("Process"),
    numOpts = parseInt(envVar("numOpts"));
if ( WScript.Arguments.Length ) {
   // Enter menu options
   for ( var i=1; i <= numOpts; i++ ) {
      wshShell.SendKeys(envVar("option["+i+"]")+"{ENTER}");
   }
} else {
   // Enter a F7 to open the menu
   wshShell.SendKeys("{F7}");
   wshShell.SendKeys("{HOME}");
}