@if (@CodeSection == @Batch) @then
::
::  install_terminal_theme.bat
::  WSpring
::
::  Created by kimbomm on 2018. 10. 28...
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
call :TerminalThemeSelect
call :AbsoluteDownloadCurl
call :DownloadSetw
::start
cd %TEMP%
title install_terminal_theme
echo Downloading...
set DIR=%USERPROFILE%\colortool
call :SafeRMDIR %DIR%
md %DIR%
cd %DIR%
curlw -L "https://github.com/springkim/WSpring/releases/download/program/colortool.zip" -o "colortool.zip"
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('colortool.zip', '.'); }"
setw %DIR%
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
  /t REG_EXPAND_SZ /d "%"USERPROFILE"%\init.cmd" /f

echo @echo off > %USRPROFILE%\init.cmd
echo colortool.exe -q %TERMINALTHEME%.itermcolors >> %USRPROFILE%\init.cmd

echo Finish!!
pause
exit /b

:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b

:DownloadSetw
if not exist "%WINDIR%\system32\setw.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/setw.exe" -o "%WINDIR%\system32\setw.exe"
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
::https://www.windowscentral.com/how-change-command-prompts-color-scheme-windows-10
::https://stackoverflow.com/questions/17404165/how-to-run-a-command-on-command-prompt-startup-in-windows
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::reference : http://reboot.pro/topic/20968-basic-batch-menu-using-arrows-keys/
:TerminalThemeSelect
TITLE TerminalThemeSelect
setlocal EnableDelayedExpansion
set numOpts=0
if "%1" equ "" set OPT="OneHalfDark" "OneHalfLight" "solarized_dark" "solarized_light"
if not "%1" equ "" set OPT=%*
for %%a in (%OPT%) do set /A numOpts+=1&&set option[!numOpts!]=%%~a
rem Clear previous doskey history
doskey /LISTSIZE=!numOpts!
rem Fill doskey history with menu options
cscript //nologo /E:JScript "%~f0" EnterOpts
for /L %%i in (1,1,%numOpts%) do set /P "TERMINALTHEME="
:nextOpt
cls
rem echo MULTI-LINE MENU WITH OPTIONS SELECTION
rem echo/
rem Send a F7 key to open the selection menu
cscript //nologo /E:JScript "%~f0" > nul
set TERMINALTHEME=
set /P "TERMINALTHEME=Select the desired option: " > nul
endlocal & set TERMINALTHEME="%TERMINALTHEME%"
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