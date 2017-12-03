::
::  download_opencv_contrib.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 03...
::  Copyright 2017 kimbom. All rights reserved.
::

::start
echo Download opencv
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/sgvhfluh5v2n05e/opencv_contrib331_dynamic%28wspring%29.zip?dl=1','opencv_contrib331_dynamic(wspring).zip')"
echo Unzip opencv
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv_contrib331_dynamic(wspring).zip', 'opencv_contrib331_dynamic(wspring)'); }"
echo Done!
pause