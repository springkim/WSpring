::
::  install_tensorrt.bat
::  WSpring
::
::  Created by kimbomm on 2020. 08. 14...
::  Copyright 2020 kimbomm. All rights reserved.
::
<# :
@echo on
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
title install_tensorRT
echo Please download and select the correct version of tensorRT zip file. If the version is different, it may not work.

set TENSORRTZIP=""

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    set TENSORRTZIP=%%~I
)
if not exist "%TENSORRTZIP%" (
	echo No file selected.
	pause
	exit /b
)

echo %TENSORRTZIP%

echo Installing...
call :SafeRMDIR "%TEMP%\cuda"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%TENSORRTZIP%', '%TEMP%'); }"

cd /D %TEMP%\TensorRT*

call :GetCudaPath
echo %cudapath%


xcopy /Y "include\*.*" "%cudapath%\include\" /e /h /k 2>&1 >NUL
xcopy /Y "lib\*.lib" "%cudapath%\lib\x64\" /e /h /k 2>&1 >NUL
xcopy /Y "lib\*.dll" "%cudapath%\bin\" /e /h /k 2>&1 >NUL

set trtdir=%CD%
cd /D %TEMP%
call :SafeRMDIR "%trtdir%"

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:GetCudaPath
where nvcc > "%temp%\nvccpath.txt"
if "%ERRORLEVEL%" eq "0" (
    pushd %CD%
    set /p "nvccpath="<"%TEMP%\nvccpath.txt"
    For %%A in ("%nvccpath%") do (set cudapath=%%~dpA)
    echo %cudapath%
    set cudapath=%cudapath%\..
    cd /D %cudapath%
    set cudapath=%CD%
    echo %cudapath%
    popd
) else (
    echo No Cuda
    exit
)
exit /b
::https://stackoverflow.com/questions/15885132/file-folder-chooser-dialog-from-a-windows-batch-script
:  #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "tensorRT zip files (*.zip)|*.zip"
$f.ShowHelp = $true
$f.Multiselect = $false
[void]$f.ShowDialog()
if ($f.Multiselect) { $f.FileNames } else { $f.FileName }
