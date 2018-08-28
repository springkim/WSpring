@echo off
git config --get remote.origin.url > git_url.txt
set /p "url="<"git_url.txt"

if "%url%" == "" (
	echo This directory is not git repository
	pause
	exit /b
)
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri '%url%' -UseBasicParsing;($HTML.Content) > gfu_html.txt"
powershell "get-content gfu_html.txt -ReadCount 10000 | foreach { $_ -match 'forked from' } | out-file -encoding ascii gfu_url.txt"
powershell "$SRC=get-content gfu_url.txt -ReadCount 1;[regex]::match($SRC,'(<a.+</a>)').Groups[1].Value | out-file -encoding ascii gfu_url2.txt"
powershell "$SRC=get-content gfu_url2.txt -ReadCount 1;[regex]::match($SRC,'\"(.+)\"').Groups[1].Value | out-file -encoding ascii gfu_url3.txt"
set /p "origin_url="<"gfu_url3.txt"

DEL gfu_html.txt
DEL git_url.txt
DEL gfu_url.txt
DEL gfu_url2.txt
DEL gfu_url3.txt

if "%origin_url%" == "" (
	echo Failed to get origin repository
	pause
	exit /b
)

git remote add upstream https://github.com%origin_url%
git remote -v
git fetch upstream
git checkout master
git merge upstream/master
git push
pause