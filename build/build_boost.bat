@if (@CodeSection == @Batch) @then
::
::  build_boost.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 08...
::  Copyright 2018 kimbomm. All rights reserved.
::
@echo off
call :CCSelect
call :AbsoluteDownloadCurl
call :Download7z


::=============
set "BOOST_WITH=--with-date_time --with-system --with-filesystem --with-thread"
::=============

set NAME=boost
call :SafeRMDIR "build_%NAME%"
mkdir "build_%NAME%"
cd "build_%NAME%"

set BOOST=boost_1_68_0
curlw -L "https://dl.bintray.com/boostorg/release/1.68.0/source/%BOOST%.7z" -o "%BOOST%.7z"
call :SafeRMDIR %BOOST%
7z x "%BOOST%.7z" -y -o"."
cd %BOOST%
call bootstrap.bat

if %COMPILER% == "exit" (
	pause
	exit
)
if %COMPILER% == "Visual Studio 2017 x64" (
	b2.exe --toolset=msvc-14.1 variant=debug,release address-model=64 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "Visual Studio 2015 x64" (
	b2.exe --toolset=msvc-14.0 variant=debug,release address-model=64 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "Visual Studio 2013 x64" (
	b2.exe --toolset=msvc-12.0 variant=debug,release address-model=64 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "MinGW x64" (
	b2.exe --toolset=gcc variant=debug,release address-model=64 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "Visual Studio 2017 x86" (
	b2.exe --toolset=msvc-14.1 variant=debug,release address-model=32 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "Visual Studio 2015 x86" (
	b2.exe --toolset=msvc-14.0 variant=debug,release address-model=32 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "Visual Studio 2013 x86" (
	b2.exe --toolset=msvc-12.0 variant=debug,release address-model=32 threading=multi link=static runtime-link=shared %BOOST_WITH%
)
if %COMPILER% == "MinGW x86" (
	b2.exe --toolset=gcc variant=debug,release address-model=32 threading=multi link=static runtime-link=shared %BOOST_WITH%
)


xcopy /Y "boost\*.*" ..\include\boost\ /e /h /k 2>&1 >NUL
xcopy /Y "stage\lib\*.*" ..\lib\ /e /h /k 2>&1 >NUL
pause
exit /b
::gcc          MinGW64
::msvc-12.0	   Visual Studio 2013
::msvc-14.0	   Visual Studio 2015
::msvc-14.1	   Visual Studio 2017


:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.exe" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.dll" -o "%WINDIR%\system32\7z.dll"
exit /b 


::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/curl.exe','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/ca-bundle.crt','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::reference : http://reboot.pro/topic/20968-basic-batch-menu-using-arrows-keys/
:CCSelect
TITLE C-CompilerSelecter
setlocal EnableDelayedExpansion
set numOpts=0
if "%1" equ "" set OPT="Visual Studio 2017 x64" "Visual Studio 2015 x64" "Visual Studio 2013 x64" "MinGW x64" "Visual Studio 2017 x86" "Visual Studio 2015 x86" "Visual Studio 2013 x86" "MinGW x86"
if not "%1" equ "" set OPT=%*
for %%a in (%OPT%) do set /A numOpts+=1&&set option[!numOpts!]=%%~a
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