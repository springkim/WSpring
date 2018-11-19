@echo off
git clone --recursive https://github.com/peirick/VS2015_Tesseract
cd VS2015_Tesseract
powershell "(Get-Content build_tesseract.bat).replace('Platform=x86', 'Platform=x64') | Set-Content build_tesseract.bat"

pushd %CD%
cd tesseract_3.05\ccmain
iconv -c -f UTF-8 -t UTF-16LE equationdetect.cpp > equationdetect.cpp.temp
move /Y equationdetect.cpp.temp equationdetect.cpp 2>&1 >NUL
popd

call build_jbig2enc.bat
call build_tesseract.bat




pause
exit /b


::https://github.com/DanBloomberg/leptonica/releases

::https://github.com/tesseract-ocr/tesseract



::http://copynull.tistory.com/160


::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:DownloadIConv
::Do not use [where] command for search iconv. Because Strawberry has also iconv.
if not exist "%WINDIR%\system32\iconv.exe" (
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/iconv.exe" -o "%WINDIR%\system32\iconv.exe"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libcharset1.dll" -o "%WINDIR%\SysWOW64\libcharset1.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libiconv2.dll" -o "%WINDIR%\SysWOW64\libiconv2.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/libintl3.dll" -o "%WINDIR%\SysWOW64\libintl3.dll"
	curlw -L "https://github.com/springkim/WSpring/releases/download/bin/enca.exe" -o "%WINDIR%\system32\enca.exe"
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
		
	)
	if !encoding! EQU %unknown% (
		iconv -c -f UTF-8 -t UTF-16LE "%%f" > "%%f.txt"
		move /Y "%%f.txt" "%%f" >nul
	)
	del tmp.txt
)
endlocal
exit /b