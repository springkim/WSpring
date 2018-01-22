::
::  build_tinyxml2_MSVC.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
::  Copyright 2017 kimbomm. All rights reserved.
::
mkdir build_tinyxml2_MSVC
cd build_tinyxml2_MSVC
git clone https://github.com/leethomason/tinyxml2
mkdir build
cd build
cmake ..\tinyxml2^
 -G "Visual Studio 14 2015 Win64"^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_SHARED_LIBS:BOOL=ON^
 -DBUILD_STATIC_LIBS:BOOL=OFF^
 -DBUILD_TESTS:BOOL=OFF^
;
cmake .. -G %CC% -DCMAKE_BUILD_TYPE=RELEASE
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target ALL_BUILD
cmake --build . --config Debug --target INSTALL
pause
exit /b