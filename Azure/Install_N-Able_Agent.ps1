Set-ExecutionPolicy Bypass -Scope Process -Force; 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$LocalTempDir = $env:TEMP; 
$software = "Windows Agent*";
$RegHives = "HKLM:\Software","HKLM:\Software\WOW6432Node","HKCU:\Software"
$serverHost = "thor.theitteam.co.nz"
$CustomerID = "101"
$CustomerName = "The IT Team"
$Apps = @()

ForEach ($Hive in $RegHives)
{
    $Apps += Get-ItemProperty $Hive\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | Where { $_.DisplayName -like $software }
}

if ($Apps -ne $null){
	$installed = $true
} Else{
	$installed = $false
}
	
If(-Not $installed) {
	Write-Host "'$software' NOT is installed.";
	$AgentInstaller = "WindowsAgentSetup.exe"; (new-object    System.Net.WebClient).DownloadFile('https://thor.theitteam.co.nz/download/12.2.1.280/winnt/N-central/WindowsAgentSetup.exe', "$LocalTempDir\$AgentInstaller"); & "$LocalTempDir\$AgentInstaller" /silent /install /v " /qn SERVERPROTOCOL=HTTPS SERVERADDRESS='" + $serverHost + "' SERVERPORT=443 CUSTOMERID=" + $CustomerID + " CUSTOMERNAME= '" + $CustomerName + "'"; $Process2Monitor =  "AgentInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$AgentInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
} else {
	Write-Host "'$software' is installed."
}
