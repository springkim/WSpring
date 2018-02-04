::
::  install_clion.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 04...
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
	
	
::::::::::::install
set VER=2017.3.3
if not exist "%SystemDrive%\Program Files\JetBrains" md "%SystemDrive%\Program Files\JetBrains"
echo Downloading Clion
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/vlwd6utokvq0q93/CLion-2017.3.3.zip?dl=1','%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip')"
echo Unzip Clion
call :SafeRMDIR '%SystemDrive%\Program Files\JetBrains\CLion-%VER%'
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip', '%SystemDrive%\Program Files\JetBrains\CLion-%VER%'); }"
del '%SystemDrive%\Program Files\JetBrains\CLion-%VER%.zip'

if not exist "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains" md "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\JetBrains CLion 2017.3.3.lnk');$s.TargetPath='%SystemDrive%\Program Files\JetBrains\CLion-2017.3.3\bin\clion64.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\JetBrains CLion 2017.3.3.lnk');$s.TargetPath='%SystemDrive%\Program Files\JetBrains\CLion-2017.3.3\bin\clion64.exe';$s.Save()"

pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b