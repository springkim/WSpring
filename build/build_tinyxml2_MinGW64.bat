::
::  build_tinyxml2_MinGW64.bat
::  WSpring
::
::  Created by kimbomm on 2018. 01. 22...
::  Copyright 2017 kimbomm. All rights reserved.
::
mkdir build_tinyxml2_MinGW64
cd build_tinyxml2_MinGW64
git clone https://github.com/leethomason/tinyxml2
mkdir build
cd build
cmake ..\tinyxml2^
 -G "MinGW Makefiles"^
 -DCMAKE_INSTALL_PREFIX=build^
 -DBUILD_SHARED_LIBS:BOOL=ON^
 -DBUILD_STATIC_LIBS:BOOL=OFF^
 -DBUILD_TESTS:BOOL=OFF^
;
cmake .. -G %CC% -DCMAKE_BUILD_TYPE=RELEASE
cmake --build . --config Release
cmake --build . --target install
pause
exit /b