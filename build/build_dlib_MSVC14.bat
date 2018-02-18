::
::  MSVC14/build_opencv_MSVC14_world_shared.bat
::  WSpring
::
::  Created by kimbom on 2018. 01. 21...
::  Copyright 2017 kimbom. All rights reserved.
::
mkdir build_opencv_MSVC14_world_shared
cd build_opencv_MSVC14_world_shared
git clone https://github.com/opencv/opencv
git clone https://github.com/RLovelett/eigen
mkdir build
cd build
cmake ../opencv^
 -G "Visual Studio 14 2015 Win64"^
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
 -DENABLE_PRECOMPILED_HEADERS=ON^
 -DBUILD_opencv_python2=OFF^
 -DBUILD_opencv_python3=ON^
 -DPYTHON3_EXECUTABLE=C:/Python36/python3.exe^
 -DPYTHON3_INCLUDE_DIR=C:/Python36/include^
 -DPYTHON_LIBRARY=C:/Python36/libs/python36.lib^
 -DPYTHON_NUMPY_INCLUDE_DIRS=C:/Python36/Lib/site-packages/numpy/core/include^
 -DPYTHON_PACKAGES_PATH=C:/Python36/Lib/site-packages^
;
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL

pause
exit /b

::https://stackoverflow.com/questions/46298845/building-opencv-3-3-using-mingw-make-gives-error-2-at-47