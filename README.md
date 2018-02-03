## <img src="http://i65.tinypic.com/241uzhc.png" width="64"> <img src="http://i65.tinypic.com/2a95tdy.png" width="64"> WSpring 

## Windows(x64) Programming Library & Tool Setup Project

### Global/Local

Global install is installing library on compiler directory. It can run directly your source code without any settings.
Local library is installing library on your project directory. You have to use local library if you consider move or release your project.

For example in MSVC14(Visual Studio 2015), you need include directory and library directory. You can check below. This scripts will download modules in this directory.

### x86/x64
Drop x86(32bit application). x86 is past technology on desktop computer.
Actually many libraries don't support x86 system.

### Shared/Static

This option is actually not important. But consider if you want use independent executable file. 
But static library depends on compiler. MSVC14's library will not work on MSVC15.
So we use shared library.
### Global directories
**Dll location** : `C:\Windows\System32`
##### MSVC14(Visual Studio 2015)
**Include directory** : `C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include\`
**Library directory** : `C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib\amd64\`
##### MSVC12(Visual Studio 2013)
**Include directory** : `C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include\`
**Library directory** : `C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib\amd64\`
##### MinGW64
**Include directory** : `C:\MinGW64\x86_64-w64-mingw32\include\`
**Library directory** : `C:\MinGW64\x86_64-w64-mingw32\lib\`


## Programming Language & Tools
### <img src="http://i64.tinypic.com/ravog1.png" width="64">Bandizip
**[Bandizip](https://www.bandisoft.co.kr/bandizip/)** is a lightweight, fast and free All-In-One Zip Archiver.
Bandizip has a very fast Zip algorithm for compression & extraction with Fast Drag and Drop, High Speed Archiving, and Multi-core compression. It handles the most popular compression formats, including Zip, 7z, Rar, and so on.

### <img src="http://i64.tinypic.com/2qmzon4.png" width="64">CMake
**[CMake](https://cmake.org/)** is an open-source, cross-platform tools to build. Maybe you are using cmake as CLI(Command-Line-Interface) in Linux. Windows is same with Linux.
You have to install this script before every build scripts.
### <img src="http://i68.tinypic.com/15axee.png" width="64">MinGW64
**[MinGW-w64](https://mingw-w64.org/doku.php)** is an advancement of the original mingw.org project, Created to support the GCC compiler on Windows system. You can use this compiler on Windows **[CLion](https://www.jetbrains.com/clion/)**.
### <img src="http://i67.tinypic.com/2dcd7x0.png" width="64">Python2.7.14
**[Python](https://www.python.org/)** is light-weight script language. I don't like python. But many interfaces of deep-learning libraries are python2 or python3. So we need both of them as python2.exe and python3.exe.
This script will install Python2.7.14 at `C:\Python27\`.
You can run python2.X as `python2.exe` and `pip2.exe`.
### <img src="http://i65.tinypic.com/r1klsl.png" width="64">Python3.6.4
This script will install Python3.6.4 at `C:\Python36\`.
You can run python3.X as `python3.exe` and `pip3.exe`.
### <img src="https://i.imgur.com/KOubi5z.png" width="64">WSL
Windows Subsystem for Linux (WSL) is a compatibility layer for running Linux binary executables (in ELF format) natively on Windows 10.
Do not install WSL from Windows store if you are korean.
This script will install WSL(current locale) and Xming(for GUI) automatically.




## Libraries

### <img src="http://i64.tinypic.com/4hcxp3.png" width="64">OpenCV
**[OpenCV](https://opencv.org/)** is open source computer vision library. Please install opencv correctly way. Many people installed opencv strange way *(e.g. C:/Opencv)* . Also OpenCV dropped C interface after version 3.0. So you need to install both 2.4.X and 3.X if you are C/C++ programmer. And i prepare contrib build scripts too.
This script will install opencv3.4.0,2.4.13.5 *(prebuilt)* library in **VS2015,VS2013,VS2012,VS2010,MinGW64,Python2** and **Python3**.

You don't have to any settings for Visual Studio and Python. But you need link libraries in MinGW64.
It automatically selects opencv version. For example in gcc or Visual Studio(/TC) it will use opencv 2.4.13.5. and g++ or Visual Studio(/TP) it will use opencv 3.4.0.


### <img src="http://i67.tinypic.com/33ua5p3.png" width="64"> OpenBLAS
**[OpenBLAS](http://www.openblas.net/)** is an optimized BLAS library based on GotoBLAS2 1.13 BSD version. Usually we use BLAS for Matrix Multiplication in C. C++ has [Eigen](eigen.tuxfamily.org/) and Python has numpy.


### <img src="http://i63.tinypic.com/14cqwx3.png" width="64"> TinyXML2
**[TinyXML-2](http://www.grinninglizard.com/tinyxml2/)** is a simple, small, efficient, C++ XML parser that can be easily integrating into other programs.