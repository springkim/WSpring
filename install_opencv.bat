::
::  install_opencv.bat
::  WSpring
::
::  Created by kimbomm on 2018. 04. 26...
::  Copyright 2017-2018 kimbomm. All rights reserved.
::
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Get admin permission...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
call :AbsoluteDownloadCurl
::start
title install_opencv
echo Downloading...
cd %TEMP%
call :SafeRMDIR "build_opencv"
::GOTO DOWNLOADSKIP
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/opencv/opencv/releases';($HTML.ParsedHtml.getElementsByTagName('a') | %% href) > opencv.txt"
powershell "get-content opencv.txt -ReadCount 1000 | foreach { $_ -match 'archive' } | out-file -encoding ascii opencv_link.txt"
powershell "get-content opencv_link.txt -ReadCount 1000 | foreach { $_ -match 'zip' } | out-file -encoding ascii opencv_link_zip.txt"
powershell "get-content opencv_link.txt -ReadCount 1000 | foreach { $_ -notmatch 'cvsdk' } | out-file -encoding ascii opencv_link_zip2.txt"
::Verify latest opecv 3 and 2.
powershell "get-content opencv_link_zip2.txt -ReadCount 1000 | foreach { $_ -match '/3.' } | out-file -encoding ascii opencv_link3.txt"
powershell "get-content opencv_link_zip2.txt -ReadCount 1000 | foreach { $_ -match '/2.' } | out-file -encoding ascii opencv_link2.txt"
set /p "cv2="<"opencv_link2.txt"
set /p "cv3="<"opencv_link3.txt"
curlw -L "https://github.com%cv3:~6%" -o "cv3.zip"
set cv3c=/opencv/opencv_contrib%cv3:~20%
curlw -L "https://github.com%cv3c%" -o "cv3c.zip"
curlw -L "https://github.com%cv2:~6%" -o "cv2.zip"

powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cv2.zip', 'build_opencv'); }"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cv3c.zip', 'build_opencv'); }"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('cv3.zip', 'build_opencv'); }"
cd build_opencv
git clone https://github.com/RLovelett/eigen
cd ..
:DOWNLOADSKIP

cd build_opencv


setlocal EnableDelayedExpansion
set CCC=0
if exist "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include" (
	set CC[%CCC%]="Visual Studio 12 2013 Win64"
	set CCDIR[%CCC%]="vc12"
	set dst_include_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include\"
	set dst_lib_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\amd64\"
	set src_lib_dir[%CCC%]=vc12
	set extension[%CCC%]=lib
	set /a CCC=%CCC%+1
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include" (
	set CC[%CCC%]="Visual Studio 14 2015 Win64"
	set CCDIR[%CCC%]="vc14"
	set dst_include_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\"
	set dst_lib_dir[%CCC%]="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\"
	set src_lib_dir[%CCC%]=vc14
	set extension[%CCC%]=lib
	set /a CCC=%CCC%+1
)
if exist "C:\MinGW64\" (
	set CC[%CCC%]="MinGW Makefiles"
	set CCDIR[%CCC%]=""
	set dst_include_dir[%CCC%]="C:\MinGW64\x86_64-w64-mingw32\include\"
	set dst_lib_dir[%CCC%]="C:\MinGW64\x86_64-w64-mingw32\lib\"
	set src_lib_dir[%CCC%]=mingw
	set extension[%CCC%]=a
	set /a CCC=%CCC%+1
)
set /a CCC=%CCC%-1
::CC = C Compiler
::CCC = C Compiler Count

call :GetDirName "." "contrib" "null" cv3c_dir
call :GetDirName "." "opencv-3" "contrib" cv3_dir
call :GetDirName "." "opencv-2" "contrib" cv2_dir

call :RemovePython %cv2_dir%\CMakeLists.txt
call :RemovePython %cv3_dir%\CMakeLists.txt

setlocal EnableDelayedExpansion

set ver[0]=2
set ver[1]=3
set ver[2]=3
set dir[0]=build2
set dir[1]=build3c
set dir[2]=build3w
set cv_dir[0]=%cv2_dir%
set cv_dir[1]=%cv3_dir%
set cv_dir[2]=%cv3_dir%
set op_eigen[0]=
set op_eigen[1]=-DEIGEN_INCLUDE_PATH=../../eigen
set op_eigen[2]=-DEIGEN_INCLUDE_PATH=../../eigen
set op_world[0]=
set op_world[1]=-DBUILD_opencv_world=OFF
set op_world[2]=-DBUILD_opencv_world=ON
set op_contrib[0]=-DOPENCV_EXTRA_MODULES_PATH=
set op_contrib[1]=-DOPENCV_EXTRA_MODULES_PATH=../../%cv3c_dir%/modules
set op_contrib[2]=-DOPENCV_EXTRA_MODULES_PATH=

del "C:\Windows\System32\opencv_*" 2>&1 >NUL
del "C:\Windows\System32\libopencv_*" 2>&1 >NUL

FOR /L %%i in (0,1,%CCC%) do (
	if not exist !CC[%%i]! md !CC[%%i]!
	cd !CC[%%i]!
	FOR /L %%j in (0,1,2) do (
		if not exist !dir[%%j]! md !dir[%%j]!
		cd !dir[%%j]!
	 	cmake ../../!cv_dir[%%j]!^
		 -G !CC[%%i]!^
		 -DCMAKE_BUILD_TYPE=RELEASE^
		 -DCMAKE_INSTALL_PREFIX=build^
		 -DBUILD_DOCS=OFF^
		 -DBUILD_TESTS=OFF^
		 -DBUILD_PERF_TESTS=OFF^
		 -DBUILD_PACKAGE=OFF^
		 -DBUILD_IPP_IW=OFF^
		 -DBUILD_SHARED_LIBS=ON^
		 -DWITH_CUDA=OFF^
		 -DWITH_OPENCL=OFF^
		 -DBUILD_opencv_python=OFF^
		 -DCPU_DISPATCH=AVX,AVX2^
		 !op_eigen[%%j]!^
		 !op_world[%%j]!^
		 !op_contrib[%%j]!

		if !CC[%%i]! == "MinGW Makefiles"  (
			cmake --build . --config Release
			cmake --build . --target install
		) else (
			cmake --build . --config Release --target ALL_BUILD
			cmake --build . --config Release --target INSTALL
			cmake --build . --config Debug --target ALL_BUILD
			cmake --build . --config Debug --target INSTALL
		)
		cd ..
	)
	if not !CCDIR[%%i]! == "" (
		call :MakeOpenCVLib "!dir[0]!\build\x64\!CCDIR[%%i]!\lib" "..\..\..\..\..\lib2c.txt"
		call :MakeOpenCVLib "!dir[1]!\build\x64\!CCDIR[%%i]!\lib" "..\..\..\..\..\lib3c.txt"
	)else (
		::for MinGW64
		call :SetOpenCVEnvValue "build2\build\x64\!src_lib_dir[%%i]!\lib" opencv2
		call :SetOpenCVEnvValue "build3c\build\x64\!src_lib_dir[%%i]!\lib" opencv3
	)
	call :MakeOpenCVInclude
	if not !CC[%%i]! == "MinGW Makefiles"  (
		call :DownloadIConv
		call :ChangeEncoding
	)
	call :SafeRMDIR "!dst_include_dir[%%i]:~1,-1!opencv"
	call :SafeRMDIR "!dst_include_dir[%%i]:~1,-1!opencv2"
	if exist "!dst_lib_dir[%%i]:~1,-1!opencv_*" del "!dst_lib_dir[%%i]:~1,-1!opencv_*" 2>&1 >NUL
	if exist "!dst_lib_dir[%%i]:~1,-1!libopencv_*" del "!dst_lib_dir[%%i]:~1,-1!libopencv_*" 2>&1 >NUL


	xcopy /Y "include\*.*" !dst_include_dir[%%i]! /e /h /k 2>&1 >NUL
	xcopy /Y "build2\build\x64\!src_lib_dir[%%i]!\lib\*.!extension[%%i]!" !dst_lib_dir[%%i]! 2>&1 >NUL
	xcopy /Y "build3c\build\x64\!src_lib_dir[%%i]!\lib\*.!extension[%%i]!" !dst_lib_dir[%%i]! 2>&1 >NUL
	xcopy /Y "build3w\build\x64\!src_lib_dir[%%i]!\lib\*.!extension[%%i]!" !dst_lib_dir[%%i]! 2>&1 >NUL
	xcopy /Y "build2\build\x64\!src_lib_dir[%%i]!\bin\*.dll" "C:\Windows\System32\" 2>&1 >NUL
	xcopy /Y "build3c\build\x64\!src_lib_dir[%%i]!\bin\*.dll" "C:\Windows\System32\" 2>&1 >NUL
	xcopy /Y "build3w\build\x64\!src_lib_dir[%%i]!\bin\*.dll" "C:\Windows\System32\" 2>&1 >NUL
	cd ..
)
endlocal
cd ..
del opencv.txt
del opencv_link.txt
del opencv_link_zip.txt
del opencv_link2.txt
del opencv_link3.txt
del cv2.zip
del cv3.zip
del cv3c.zip
pause
exit /b


::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
::Param 1 : dir
::Param 2 : match string
::Param 3 : not match string
::Param 4 : return value
:GetDirName
pushd %CD%
cd %~1
dir /B > "%TEMP%\dir.txt"
powershell "get-content %TEMP%\dir.txt -ReadCount 1000 | foreach { $_ -match '%~2' } | out-file -encoding ascii %TEMP%\dir_match.txt"
powershell "get-content %TEMP%\dir_match.txt -ReadCount 1000 | foreach { $_ -notMatch '%~3' } | out-file -encoding ascii %TEMP%\dir_notmatch.txt"
set /p "value="<"%TEMP%\dir_notmatch.txt"
set %~4=%value%
popd
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:RemovePython
powershell "get-content %~1 -ReadCount 10000 | foreach { $_ -notmatch 'OpenCVDetectPython.cmake' } | out-file -encoding ascii %TEMP%\CMakeListsWithoutPython.txt"
copy /Y "%TEMP%\CMakeListsWithoutPython.txt" "%~1" 2>&1 >NUL
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:MakeOpenCVInclude
if exist "include" rmdir /S /Q include
cd build2\build\include\
call :CurrDirList > ..\..\..\cv2_include.txt
cd ..\..\..\
cd build3c\build\include\
call :CurrDirList > ..\..\..\cv3_include.txt
cd ..\..\..\
SETLOCAL EnableDelayedExpansion
for /F "tokens=*" %%A in (cv2_include.txt) do (
	set file=%%A
	set file2=build2\build\include\%%A
	set file3=build3c\build\include\%%A
	if not exist "include\!file:%%~nxA=!" md "include\!file:%%~nxA=!"
	echo #ifndef __cplusplus >> include\!file!
	echo. >> include\!file!
	if exist "lib2c.txt" type lib2c.txt >> include\!file!
	type !file2! >> include\!file!
	echo. >> include\!file!
	echo #else >> include\!file!
	echo. >> include\!file!
	if exist !file3! (
		if exist "lib3c.txt" type lib3c.txt >> include\!file!
		type !file3! >> include\!file!
		echo. >> include\!file!
	)
	echo #endif >> include\!file!
)
for /F "tokens=*" %%A in (cv3_include.txt) do (
	if not exist include\%%A (
		set file=%%A
		set file2=build2\build\include\%%A
		set file3=build3c\build\include\%%A
		if not exist "include\!file:%%~nxA=!" md "include\!file:%%~nxA=!"
		echo #ifdef __cplusplus >> include\!file!
		echo. >> include\!file!
		if exist "lib3c.txt" type lib3c.txt >> include\!file!
		type !file3! >> include\!file!
		echo. >> include\!file!
		echo #endif >> include\!file!
	)
)
ENDLOCAL
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:CurrDirList
SETLOCAL EnableDelayedExpansion
set currdir=%CD%\
FOR /R %%E IN (./*.*) DO (
	 set full_path=%%E
	 echo !full_path:%currdir%=!
)
ENDLOCAL
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:: Param 1 : Visual Studio version(e.g vc14 vc12)
:: Param 2 : text file path(e.g. ..\..\..\..\..\libc.txt)
:MakeOpenCVLib
pushd %cd%
cd %~1
SETLOCAL EnableDelayedExpansion
set currdir=%CD%\
dir /B | findstr ".*[0-9].lib" > lib.txt
echo #ifndef _DEBUG > %~2
for /F "tokens=*" %%A in (lib.txt) do (
	set lib=%%A
	echo #pragma comment^(lib,"!lib!"^) >> %~2
)
echo #else >> %~2
FOR /R %%E IN (./*d.lib) DO (
	 set lib=%%~nxE
	 echo #pragma comment^(lib,"!lib!"^) >> %~2
)
echo #endif >>%~2
ENDLOCAL
popd
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:: Param 1 : lib directory
:: Param 2 : env value name
:SetOpenCVEnvValue
SETLOCAL EnableDelayedExpansion
pushd %cd%
cd %~1
set currdir=%CD%\
set value=
FOR /R %%E IN (./*.a) DO (
	set file=%%~nxE
	set file=!file:.a=!
	set file=!file:.dll=!
	set "value=!value! -l!file:~3!"
)
setx /m %~2 "%value%" 2>&1 >NUL
ENDLOCAL
popd
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:DownloadIConv
::Do not use [where] command for search iconv. Because Strawberry has also iconv.
if not exist "%WINDIR%\system32te\iconv.exe" (
	curlw -L "https://www.dropbox.com/s/2ybjknzhc1cjdj3/iconv.exe?dl=1" -o "%WINDIR%\system32\iconv.exe"
	curlw -L "https://www.dropbox.com/s/xvsdm13dg9yu1x3/libcharset1.dll?dl=1" -o "%WINDIR%\SysWOW64\libcharset1.dll"
	curlw -L "https://www.dropbox.com/s/ixynh3op3sf8h0x/libiconv2.dll?dl=1" -o "%WINDIR%\SysWOW64\libiconv2.dll"
	curlw -L "https://www.dropbox.com/s/2zkuv5kinarqb9j/libintl3.dll?dl=1" -o "%WINDIR%\SysWOW64\libintl3.dll"
	curlw -L "https://www.dropbox.com/s/vg7ou16vs0qytxi/enca.exe?dl=1" -o "%WINDIR%\system32\enca.exe"
)
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:ChangeEncoding
set dst="include"
set ascii=ASCII
set utf8=UTF-8
set unknown=unkno
SETLOCAL EnableDelayedExpansion
for /f "delims=" %%f in ('dir %dst% /a-d /s /b') do (
	call enca -L none -e "%%f" > tmp.txt
	set /p encoding=<tmp.txt
	set encoding=!encoding:~0,5!
	if !encoding! EQU %ascii% (
		iconv -c -f ASCII -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %utf8% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	if !encoding! EQU %unknown% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	del tmp.txt
)
endlocal
exit /b

::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/xytowp38v6d61lh/curl.exe?dl=1','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ibgh7o7do1voctb/ca-bundle.crt?dl=1','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
