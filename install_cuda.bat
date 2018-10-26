@if (@CodeSection == @Batch) @then
::
::  install_cuda.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 27...
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
call :CUDASelect
call :AbsoluteDownloadHtmlAgilityPack
echo Downloading...
md "%TEMP%\%CUDAVER%" >nul 2>&1

if not x%CUDAVER:8.0=%==x%CUDAVER% ( 
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_8.0.61_win10.exe" -o "%TEMP%/%CUDAVER%/cuda8.0.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_8.0.61.2_windows.exe" -o "%TEMP%/%CUDAVER%/cuda8.0_1.exe"
)
if not x%CUDAVER:9.0=%==x%CUDAVER% ( 
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.0.176_win10.exe" -o "%TEMP%/%CUDAVER%/cuda9.0.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.0.176.1_windows.exe" -o "%TEMP%/%CUDAVER%/cuda9.0_1.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.0.176.2_windows.exe" -o "%TEMP%/%CUDAVER%/cuda9.0_2.exe"
)
if not x%CUDAVER:9.1=%==x%CUDAVER% ( 
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85_win10.exe" -o "%TEMP%/%CUDAVER%/cuda9.1.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.1_windows.exe" -o "%TEMP%/%CUDAVER%/cuda9.1_1.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.2_windows.exe" -o "%TEMP%/%CUDAVER%/cuda9.1_2.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_9.1.85.3_windows.exe" -o "%TEMP%/%CUDAVER%/cuda9.1_3.exe"
)
if not x%CUDAVER:10.0=%==x%CUDAVER% (
	call :Download7z
	curlw -L "https://github.com/springkim/WSpring/releases/download/cuda/cuda_10.0.130_411.31_win10.7z" -o "%TEMP%/%CUDAVER%/cuda10.0.7z"
	7z x "%TEMP%\%CUDAVER%\cuda10.0.7z" -y -o"%TEMP%\%CUDAVER%"
	cd "%TEMP%\%CUDAVER%"
	move cuda_10.0* cuda10.0.exe
)

cd "%TEMP%\%CUDAVER%"
SETLOCAL EnableDelayedExpansion
FOR /R %%E IN (*.exe) DO (
	set file=%%~nxE
	call !file! -s -noreboot
)
endlocal

pause
exit /b

::Encoding convert
call :DownloadIConv
::ASCII -> Unicode
set dst="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0\include"
set ascii=ASCII
set utf8=UTF-8
set unknown=unkno
SETLOCAL EnableDelayedExpansion
for /f "delims=" %%f in ('dir %dst% /a-d /s /b') do (
	call enca -L none -e "%%f" > tmp.txt
	set /p encoding=<tmp.txt
	set encoding=!encoding:~0,5!
	if !encoding! EQU %ascii% (
		iconv -c -f ASCII -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %utf8% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %unknown% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	del tmp.txt
)
endlocal
pause
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.exe" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.dll" -o "%WINDIR%\system32\7z.dll"
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:DownloadIConv
::Do not use [where] command for search iconv. Because Strawberry has also iconv.
if not exist "%WINDIR%\system32\iconv.exe" (
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/iconv.exe" -o "%WINDIR%\system32\iconv.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libcharset1.dll" -o "%WINDIR%\SysWOW64\libcharset1.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libiconv2.dll" -o "%WINDIR%\SysWOW64\libiconv2.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libintl3.dll" -o "%WINDIR%\SysWOW64\libintl3.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/enca.exe" -o "%WINDIR%\system32\enca.exe"
)
exit /b

::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:AbsoluteDownloadHtmlAgilityPack
:loop_adhap
call :GetFileSize "%SystemRoot%\System32\HtmlAgilityPack.dll"
if %FILESIZE% neq 134656 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/HtmlAgilityPack.dll','%WINDIR%\System32\HtmlAgilityPack.dll')"
	goto :loop_adhap
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::reference : http://reboot.pro/topic/20968-basic-batch-menu-using-arrows-keys/
:CUDASelect
TITLE CUDASelecter
setlocal EnableDelayedExpansion
set numOpts=0
if "%1" equ "" set OPT="CUDA8.0" "CUDA9.0" "CUDA9.1" "CUDA10.0"
if not "%1" equ "" set OPT=%*
for %%a in (%OPT%) do set /A numOpts+=1&&set option[!numOpts!]=%%~a
rem Clear previous doskey history
doskey /LISTSIZE=!numOpts!
rem Fill doskey history with menu options
cscript //nologo /E:JScript "%~f0" EnterOpts
for /L %%i in (1,1,%numOpts%) do set /P "CUDAVER="
:nextOpt
cls
rem echo MULTI-LINE MENU WITH OPTIONS SELECTION
rem echo/
rem Send a F7 key to open the selection menu
cscript //nologo /E:JScript "%~f0" > nul
set CUDAVER=
set /P "CUDAVER=Select the desired option: " > nul
endlocal & set CUDAVER="%CUDAVER%"
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