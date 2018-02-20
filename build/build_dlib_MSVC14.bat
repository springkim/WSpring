::
::  MSVC14/build_dlib_MSVC14.bat
::  WSpring
::
::  Created by kimbomm on 2018. 02. 19...
::  Copyright 2017 kimbomm. All rights reserved.
::
mkdir build_dlib_MSVC14
cd build_dlib_MSVC14
git clone https://github.com/davisking/dlib
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/0xnfdiht524ezd6/cudnn-8.0-windows10-x64-v7.zip?dl=1','cudnn-8.0-windows10-x64-v7.zip')"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cudnn-8.0-windows10-x64-v7.zip', '.\'); }"
mkdir build
cd build
cmake ../dlib^
 -G "Visual Studio 14 2015 Win64"^
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
md build\bin\
xcopy /d /i /Y "..\cuda\bin\*" "build\bin\"
pause
exit /b
