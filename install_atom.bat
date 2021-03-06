::
::  install_atom.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 18...
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
call :AbsoluteDownloadCurl

::start
title install_atom
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/atom/atom/releases/latest' -UseBasicParsing;($HTML.Links.href) > atom_latest.txt"
powershell "get-content atom_latest.txt -ReadCount 1000 | foreach { $_ -match 'AtomSetup-x64' } | out-file -encoding ascii atom_url.txt"
set /p "url="<"atom_url.txt"

curlw -L "https://github.com%url%" -o "AtomSetup-x64.exe"
echo Installing...
start /wait AtomSetup-x64.exe --silent
::DEL "%TEMP%\AtomSetup-x64.exe"	::대기를 넣어도 삭제불가.
DEL "%TEMP%\atom_latest.txt"
DEL "%TEMP%\atom_url.txt"
::install uncrustify
cd %TEMP%
call :SafeRMDIR "%TEMP%\uncrustify"
if exist "install_git.bat" (
	call "install_git.bat"
)
if exist "install_cmake.bat" (
	call "install_cmake.bat"
)
call :ProgramExistInit
call :ProgramExistTest python
call :ProgramExistTest cmake
call :ProgramExistTest git

if %PEI% EQU 0 (
	call :SafeRMDIR "%TEMP%\uncrustify"
	git clone https://github.com/uncrustify/uncrustify
	cd uncrustify
	mkdir build
	cd build
	cmake -DCMAKE_BUILD_TYPE=RELEASE ..
	cmake --build . --config Release
	move Release\uncrustify.exe "%SystemDrive%\Windows\System32"
	call :SafeRMDIR "%TEMP%\uncrustify"
	::install cfg files
	md C:\Atom
	powershell "(New-Object System.Net.WebClient).DownloadFile('https://gist.githubusercontent.com/springkim/756f0aa50ee265f28e2465e83f70b613/raw/531e6e7fee132c86a4f03dbfca4d2c19660a3f71/uncrustify-cpp.cfg','C:\Atom\uncrustify-cpp.cfg')"
)

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
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
:ProgramExistInit
set PEI=0
exit /b
:ProgramExistTest
where %~1 >nul 2>&1
set /a PEI=%PEI%+%ERRORLEVEL%
exit /b