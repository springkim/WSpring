::
::  MinGW64/build_openblas.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
::  Copyright 2017 kimbomm. All rights reserved.
::
mkdir build_openblas_MinGW64
cd build_openblas_MinGW64
git clone https://github.com/xianyi/OpenBLAS
mkdir build
cd build
cmake ..\OpenBLAS^
 -G "MinGW Makefiles"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build
cmake --build . --config Release
cmake --install .
pause
exit /b