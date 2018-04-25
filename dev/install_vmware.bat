powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://www.vmware.com/kr/products/workstation-player.html' -UseBasicParsing;($HTML.Links.href) > vmware_latest.txt"

https://download3.vmware.com/software/player/file/VMware-player-14.1.1-7528167.exe

https://www.vmware.com/kr/products/workstation-player.html
이 사이트에서 주소 알아낸다음
들어가서 버전알아오고 위에 URL에 붙여서 다운로드


https://my.vmware.com/en/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/14_0
