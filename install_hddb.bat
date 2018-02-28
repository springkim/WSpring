::
::  install_hddb.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 14...
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
echo install_hddb
echo Downloading... 
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/oaz0gdo0cgj37ou/hddb_4.4.0.x64.zip?dl=1','%TEMP%\hddb_4.4.0.x64.zip')"
echo Unzipping...
call :SafeRMDIR "%UserProfile%\hddb"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TEMP%\hddb_4.4.0.x64.zip', '%UserProfile%\hddb'); }"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\hddb.lnk');$s.TargetPath='%UserProfile%\hddb\hddb-4.4.0.x64.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\hddb.lnk');$s.TargetPath='%UserProfile%\hddb\hddb-4.4.0.x64.exe';$s.Save()"


DEL "%TEMP%\hddb_4.4.0.x64.zip"
echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b