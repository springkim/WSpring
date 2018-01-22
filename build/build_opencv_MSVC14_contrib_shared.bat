::
::  install_opencv.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 2...
::  Copyright 2017 kimbom. All rights reserved.
::
mkdir opencv_contrib_dynamic
cd opencv_contrib_dynamic
git clone https://github.com/opencv/opencv
git clone https://github.com/opencv/opencv_contrib
git clone https://github.com/RLovelett/eigen
::git clone https://github.com/01org/tbb
mkdir build_release
cd build_release
cmake ../opencv^
 -G "Visual Studio 14 2015 Win64"^
 -DCMAKE_BUILD_TYPE=RELEASE^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_DOCS=OFF^
 -DBUILD_TESTS=OFF^
 -DBUILD_PERF_TESTS=OFF^
 -DBUILD_PACKAGE=OFF^
 -DBUILD_IPP_IW=OFF^
 -DBUILD_opencv_world=OFF^
 -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules^
 -DEIGEN_INCLUDE_PATH=../eigen^
 -DWITH_OPENMP=ON^
 -DBUILD_opencv_saliency=OFF^
 -DWITH_CUBLAS=ON^
 -DWITH_OPENCL_SVM=ON^
 -DBUILD_SHARED_LIBS=ON^
;
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL
pause
exit /b



:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1"
)
exit /b
::world build ¾ÈµÊ
::https://www.learnopencv.com/install-opencv3-on-windows/
::https://stackoverflow.com/questions/8558703/building-msvc-project-with-cmake-and-command-line