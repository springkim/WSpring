::
::  OpenCV3/MinGW64/World/Static
::  WSpring
::
::  Created by kimbom on 2018. 10. 28...
::  Copyright 2017 kimbom. All rights reserved.
::
@echo off
call :AbsoluteDownloadCurl
set name=build_opencv3_mingw64_world_static
set opencv_version=3.4.3
call :SafeRMDIR %name%
mkdir %name%
cd %name%
curlw -L "https://github.com/opencv/opencv/archive/%opencv_version%.zip" -o "opencv-%opencv_version%.zip"
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv-%opencv_version%.zip', '.'); }"
mkdir build
cd build
cmake ../opencv-%opencv_version%^
 -G "MinGW Makefiles"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_DOCS=OFF^
 -DBUILD_TESTS=OFF^
 -DBUILD_PERF_TESTS=OFF^
 -DBUILD_PACKAGE=OFF^
 -DBUILD_IPP_IW=ON^
 -DBUILD_opencv_world=ON^
 -DWITH_OPENMP=OFF^
 -DWITH_CUDA=OFF^
 -DWITH_OPENCL=OFF^
 -DBUILD_SHARED_LIBS=OFF^
 -DENABLE_PRECOMPILED_HEADERS=OFF^
;

cmake --build . --config Release
cmake --build . --target install
pause
exit /b

::https://stackoverflow.com/questions/46298845/building-opencv-3-3-using-mingw-make-gives-error-2-at-47
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
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