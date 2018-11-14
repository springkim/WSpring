::
::  install_dependency_walker.bat
::  WSpring
::
::  Created by kimbomm on 2018. 11. 14...
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
title install_dependency_walker
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/lucasg/Dependencies/releases' -UseBasicParsing;($HTML.Links.href) > depends_latest.txt"
powershell "get-content depends_latest.txt -ReadCount 1000 | foreach { $_ -match 'x64' } | out-file -encoding ascii depends_url1.txt"
powershell "get-content depends_url1.txt -ReadCount 1000 | foreach { $_ -match 'Release' } | out-file -encoding ascii depends_url2.txt"
powershell "get-content depends_url2.txt -ReadCount 1000 | foreach { $_ -match '.zip' } | out-file -encoding ascii depends_url3.txt"
powershell "get-content depends_url3.txt -ReadCount 1000 | foreach { $_ -Notmatch 'Debug' } | out-file -encoding ascii depends_url4.txt"
set /p "url="<"depends_url4.txt"

curlw -L "https://github.com%url%" -o "%TEMP%\depends.zip"

echo Unzipping...
if not exist "%SystemDrive%\Program Files\Depends64" md "%SystemDrive%\Program Files\Depends64"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\depends.zip', '%SystemDrive%\Program Files\Depends64'); }"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\DependenciesGui.lnk');$s.TargetPath='%SystemDrive%\Program Files\Depends64\DependenciesGui.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\DependenciesGui.lnk');$s.TargetPath='%SystemDrive%\Program Files\Depends64\DependenciesGui.exe';$s.Save()"

DEL "%TEMP%\depends.zip"
DEL "depends_latest.txt"
DEL "depends_url1.txt"
DEL "depends_url2.txt"
DEL "depends_url3.txt"
DEL "depends_url4.txt"
echo Finish!!
pause
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
