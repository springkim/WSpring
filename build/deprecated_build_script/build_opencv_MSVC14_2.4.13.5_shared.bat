::
::  MSVC14/build_opencv_MSVC14_2.4.13.5_shared.bat
::  WSpring
::
::  Created by kimbom on 2018. 01. 21...
::  Copyright 2017 kimbom. All rights reserved.
::
mkdir build_opencv_MSVC14_2.4.13.6_static2
cd build_opencv_MSVC14_2.4.13.6_static2

powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/opencv/opencv/archive/2.4.13.6.zip','opencv.zip')"

powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv.zip', '.'); }"
DEL "opencv.zip"
mkdir build
cd build
cmake ../opencv2.4.13.6^
 -G "Visual Studio 14 2015 Win64"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_DOCS=OFF^
 -DBUILD_TESTS=OFF^
 -DBUILD_PERF_TESTS=OFF^
 -DBUILD_PACKAGE=OFF^
 -DBUILD_IPP_IW=OFF^
 -DBUILD_opencv_world=OFF^
 -DWITH_OPENMP=OFF^
 -DWITH_CUDA=OFF^
 -DWITH_OPENCL=OFF^
 -DBUILD_SHARED_LIBS=OFF^
 -DENABLE_PRECOMPILED_HEADERS=OFF^
 -DBUILD_opencv_python=OFF
;

cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL
pause
exit /b