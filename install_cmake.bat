::
::  install_cmake.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02 22...
::  Copyright 2017 kimbomm. All rights reserved.
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
::move "C:\Program Files\CMake\" "C:\Program Files\CMake\cmake-3.10.2-win64-x64\bin\" 
echo install_cmake
pushd "%CD%"
echo Verify latest version...
powershell "$HTML=Invoke-WebRequest -Uri 'https://cmake.org/download/';($HTML.ParsedHtml.getElementsByTagName('a') | %% href) > %TEMP%\parse_cmake.txt"
::win64-x64.zip 가 들어간 라인만 추출
powershell "get-content %TEMP%\parse_cmake.txt -ReadCount 1000 | foreach { $_ -match 'win64-x64.zip' } | out-file -encoding ascii %TEMP%\parse_cmake1.txt"
::rc가 들어간 Release Candidate 버전은 제외
powershell "get-content %TEMP%\parse_cmake1.txt -ReadCount 1000 | foreach { $_ -notMatch 'rc' } | out-file -encoding ascii %TEMP%\parse_cmake2.txt"
::맨 첫줄이 가장 최신 버전
set /p "url="<"%TEMP%\parse_cmake2.txt"
::echo %url%
echo Downloading...
powershell "(New-Object System.Net.WebClient).DownloadFile('https://cmake.org%url:~6%','%TEMP%\CMake.zip')"
echo Unzipping...
call :SafeRMDIR "%SystemDrive%\Program Files\CMake"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\CMake.zip', '%SystemDrive%\Program Files\CMake'); }"
echo Installing...
CD "%SystemDrive%\Program Files\CMake"
CD cmake*
move bin ..\
move doc ..\
move man ..\
move share ..\
popd
setw "C:\Program Files\CMake\bin"
DEL "%TEMP%\CMake.zip"
DEL "%TEMP%\parse_cmake.txt"
DEL "%TEMP%\parse_cmake1.txt"
DEL "%TEMP%\parse_cmake2.txt"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b