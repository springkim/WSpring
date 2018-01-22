::
::  MSVC/build_openblas.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
::  Copyright 2017 kimbomm. All rights reserved.
::
mkdir build_openblas_MSVC14
cd build_openblas_MSVC14
git clone https://github.com/xianyi/OpenBLAS
mkdir build
cd build
cmake ..\OpenBLAS^
 -G "Visual Studio 14 2015 Win64"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
pause
exit /b