::
::  install_atom.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 18...
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
echo install_atom
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/atom/atom/releases/latest';($HTML.ParsedHtml.getElementsByTagName('a') | %% href) > atom_latest.txt"
powershell "get-content atom_latest.txt -ReadCount 1000 | foreach { $_ -match 'AtomSetup-x64' } | out-file -encoding ascii atom_url.txt"
set /p "url="<"atom_url.txt"
::echo %url:~6%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com%url:~6%','AtomSetup-x64.exe')"
echo Installing...
start /wait AtomSetup-x64.exe --silent
::DEL "%TEMP%\AtomSetup-x64.exe"	::대기를 넣어도 삭제불가.
DEL "%TEMP%\atom_latest.txt"
DEL "%TEMP%\atom_url.txt"
::install uncrustify
cd %TEMP% 
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
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
