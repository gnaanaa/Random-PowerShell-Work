[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$LocalTempDir = "C:\Temp\agent_install"; 
$serverHost = "thor.theitteam.co.nz"
$CustomerID = "101"
$CustomerName = "The IT Team"
$params = '/i', '"Windows Agent.msi"', '/quiet', 'SERVERPROTOCOL=HTTPS', 'SERVERADDRESS="thor.theitteam.co.nz"', 'SERVERPORT=443', 'CUSTOMERID=101', 'CUSTOMERNAME="The IT Team"'
	
New-Item -ItemType Directory -Force -Path $LocalTempDir
$AgentInstaller = "WindowsAgentSetup.exe"; (new-object    System.Net.WebClient).DownloadFile('https://thor.theitteam.co.nz/download/12.2.1.280/winnt/N-central/WindowsAgentSetup.exe', "$LocalTempDir\$AgentInstaller"); 
cd $LocalTempDir; .\WindowsAgentSetup.exe /s /x /b".\" /v"/qn"
$p = Start-Process 'msiexec.exe' -ArgumentList $params -NoNewWindow -Wait -PassThru
Write-Output $p.exitcode
