::
::  OpenCV3/MinGW64/World/Static
::  WSpring
::
::  Created by kimbom on 2018. 10. 28...
::  Copyright 2017 kimbom. All rights reserved.
::
@echo off
call :AbsoluteDownloadCurl
set name=build_opencv4_msvc14_world_static
set opencv_version=4.0.0
call :SafeRMDIR %name%
mkdir %name%
cd %name%
curlw -L "https://github.com/opencv/opencv/archive/%opencv_version%.zip" -o "opencv-%opencv_version%.zip"
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv-%opencv_version%.zip', '.'); }"
mkdir build
cd build
cmake ../opencv-%opencv_version%^
 -G "Visual Studio 14 2015 Win64"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_DOCS=OFF^
 -DBUILD_TESTS=OFF^
 -DBUILD_PERF_TESTS=OFF^
 -DBUILD_PACKAGE=OFF^
 -DBUILD_IPP_IW=OFF^
 -DBUILD_opencv_world=ON^
 -DWITH_OPENMP=OFF^
 -DWITH_CUDA=OFF^
 -DWITH_OPENCL=OFF^
 -DBUILD_SHARED_LIBS=OFF^
 -DENABLE_PRECOMPILED_HEADERS=OFF^
 -DWITH_OPENEXR=OFF^
 -DBUILD_OPENEXR=OFF^
;

cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL
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