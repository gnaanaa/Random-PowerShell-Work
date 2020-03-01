$LocalTempDir = $env:TEMP; 
$software = "*Chrome*";
$RegHives = "HKLM:\Software","HKLM:\Software\WOW6432Node","HKCU:\Software"
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
	Write-Host "'$software' is NOT installed.";
	$ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
} else {
	Write-Host "'$software' is installed."
}
