::
::  install_shareX.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
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
echo install_shareX
echo Downloading...
cd %TEMP%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/ShareX/ShareX/releases/latest' -UseBasicParsing;($HTML.Links.href) > sharex_latest.txt"
powershell "get-content sharex_latest.txt -ReadCount 1000 | foreach { $_ -match 'ShareX-portable.zip' } | out-file -encoding ascii sharex_url.txt"
set /p "url="<"sharex_url.txt"
::echo %url:~6%
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com%url%','%TEMP%\ShareX.zip')"

echo Unzipping...
call :SafeRMDIR "%UserProfile%\ShareX-Portable"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\ShareX.zip', '%UserProfile%\ShareX-Portable'); }"
echo Installing...

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\ShareX.lnk');$s.TargetPath='%UserProfile%\ShareX-Portable\ShareX.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\ShareX.lnk');$s.TargetPath='%UserProfile%\ShareX-Portable\ShareX.exe';$s.Save()"

DEL "%TEMP%\ShareX.zip"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
