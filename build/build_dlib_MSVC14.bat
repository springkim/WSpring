::
::  MSVC14/build_dlib_MSVC14.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 19...
::  Copyright 2017 kimbomm. All rights reserved.
::
@echo off
set COMPILER="Visual Studio 15 2017 Win64"

call :SafeRMDIR "build_dlib"
mkdir "build_dlib"
cd "build_dlib"

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/davisking/dlib/releases' -UseBasicParsing;($HTML.Links.href) > dlib_releases.txt"
powershell "get-content dlib_releases.txt -ReadCount 1000 | foreach { $_ -match 'archive' } | out-file -encoding ascii dlib_releases2.txt"
powershell "get-content dlib_releases2.txt -ReadCount 1000 | foreach { $_ -match 'zip' } | out-file -encoding ascii dlib_releases3.txt"

set /p "dlibver="<"dlib_releases3.txt"
echo "https://github.com%dlibver%"
curlw -L "https://github.com%dlibver%" -o "dlib.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('dlib.zip', '.'); }"
move dlib-* dlib


mkdir build
cd build
cmake ../dlib^
 -G %COMPILER%^
 -T host=x64^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DCUDA_USE_STATIC_CUDA_RUNTIME=ON^
 -DDLIB_USE_CUDA=ON^
 -Dcudnn=..\cuda\lib\x64\cudnn.lib^
 -Dcudnn_include=..\cuda\include\^
 -DUSE_AVX_INSTRUCTIONS=ON^
 -DUSE_SSE2_INSTRUCTIONS=ON^
 -DUSE_SSE2_INSTRUCTIONS=ON^
;
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL

pause
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b