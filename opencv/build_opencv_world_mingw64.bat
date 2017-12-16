::
::  MinGW/build_opencv.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 16...
::  Copyright 2017 kimbom. All rights reserved.
::
mkdir opencv_MinGW
cd opencv_MinGW
git clone https://github.com/opencv/opencv
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
 -DBUILD_opencv_world=ON^
 -DEIGEN_INCLUDE_PATH=../eigen^
 -DWITH_OPENMP=OFF^
 -DWITH_CUDA=OFF^
 -DWITH_OPENCL=OFF^
 -DBUILD_SHARED_LIBS=ON^
 -DENABLE_PRECOMPILED_HEADERS=OFF^
";

cmake --build . --config Release
cmake --build . --target install
pause
exit /b

::https://stackoverflow.com/questions/46298845/building-opencv-3-3-using-mingw-make-gives-error-2-at-47