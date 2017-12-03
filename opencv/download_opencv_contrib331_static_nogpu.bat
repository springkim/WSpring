::
::  download_opencv_contrib.bat
::  WSpring
::
::  Created by kimbom on 2017. 12. 03...
::  Copyright 2017 kimbom. All rights reserved.
::

::start
echo Download opencv
powershell "(New-Object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/ojkcger0nch6ij5/opencv_contrib331_static_nogpu%28wspring%29.zip?dl=1','opencv_contrib331_static_nogpu(wspring).zip')"
echo Unzip opencv
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('opencv_contrib331_static_nogpu(wspring).zip', 'opencv_contrib331_static_nogpu(wspring)'); }"
echo Done!
pause