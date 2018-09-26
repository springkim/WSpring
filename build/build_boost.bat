@echo off
call :AbsoluteDownloadCurl
call :Download7z
set BOOST=boost_1_68_0
curlw -L "https://dl.bintray.com/boostorg/release/1.68.0/source/%BOOST%.7z" -o "%BOOST%.7z"
call :SafeRMDIR %BOOST%
7z x "%BOOST%.7z" -y -o"."
cd %BOOST%
call bootstrap.bat
b2.exe --toolset=msvc-14.0 variant=debug,release address-model=64 threading=multi link=static runtime-link=shared --with-date_time --with-system --with-filesystem --with-thread

xcopy /Y "boost\*.*" ..\include\boost\ /e /h /k 2>&1 >NUL
xcopy /Y "stage\lib\*.*" ..\lib\ /e /h /k 2>&1 >NUL

exit /b
::gcc          MinGW64
::msvc-12.0	   Visual Studio 2013
::msvc-14.0	   Visual Studio 2015
::msvc-14.1	   Visual Studio 2017


:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.exe" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.dll" -o "%WINDIR%\system32\7z.dll"
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
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b