::
::  MinGW/build_opencv.bat
::  WSpring
::
::  Created by kimbom on 2018. 01. 05...
::  Copyright 2017 kimbom. All rights reserved.
::
mkdir opencv_MinGW_CAPI
cd opencv_MinGW_CAPI

powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/tcrapcv1epp8azv/opencv2.4.13.5.zip?dl=1','opencv.zip')"
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv.zip', 'opencv'); }"
DEL "opencv.zip"
git clone https://github.com/RLovelett/eigen
mkdir build
cd build
cmake ../opencv^
 -G "MinGW Makefiles"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_DOCS=OFF^
 -DBUILD_TESTS=OFF^
 -DBUILD_PERF_TESTS=OFF^
 -DBUILD_PACKAGE=OFF^
 -DBUILD_IPP_IW=OFF^
 -DBUILD_opencv_world=OFF^
 -DEIGEN_INCLUDE_PATH=../eigen^
 -DWITH_OPENMP=OFF^
 -DWITH_CUDA=OFF^
 -DWITH_OPENCL=OFF^
 -DBUILD_SHARED_LIBS=ON^
 -DENABLE_PRECOMPILED_HEADERS=OFF^
 -DBUILD_opencv_python=OFF
;

cmake --build . --config Release
cmake --build . --target install
pause
exit /b

::https://stackoverflow.com/questions/46298845/building-opencv-3-3-using-mingw-make-gives-error-2-at-47