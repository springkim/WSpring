::
::  install_cudnn7.3.1.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 08...
::  Modified by kimbomm on 2019. 02. 13...
::  Copyright 2018 kimbomm. All rights reserved.
::
<# :
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

pushd "%CD%"
title install_cudnn
echo Please download and select the correct version of cudnn zip file. If the version is different, it may not work.

set CUDNNZIP=""

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    set CUDNNZIP=%%~I
)
if not exist "%CUDNNZIP%" (
	echo No file selected.
	pause
	exit /b
)

echo %CUDNNZIP%

echo Installing...
call :SafeRMDIR "%TEMP%\cuda"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%CUDNNZIP%', '%TEMP%'); }"
cd /D %TEMP%

where nvcc > "%temp%\cudapath.txt"
set /p "cudapath="<"%TEMP%\cudapath.txt"

xcopy /Y "cuda\include\*.*" "%cudapath%\include\" /e /h /k 2>&1 >NUL
xcopy /Y "cuda\lib\x64\*.*" "%cudapath%\lib\x64\" /e /h /k 2>&1 >NUL
xcopy /Y "cuda\bin\*.*" "%cudapath%\bin\" /e /h /k 2>&1 >NUL
call :SafeRMDIR "%TEMP%\cuda"

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::https://stackoverflow.com/questions/15885132/file-folder-chooser-dialog-from-a-windows-batch-script
:  #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "cudnn zip files (*.zip)|*.zip"
$f.ShowHelp = $true
$f.Multiselect = $false
[void]$f.ShowDialog()
if ($f.Multiselect) { $f.FileNames } else { $f.FileName }
