Function Get-CurrentDriveMaps{

	Write-Host "Current Drive Mappings" -ForegroundColor Green
	$MappedDrives = Get-WmiObject -Query "SELECT Caption, ProviderName FROM Win32_MappedLogicalDisk" | Select-Object @{ Name = 'DriveLetter'; Expression = { $_.Caption } }, @{ Name = 'NetworkPath'; Expression = { $_.ProviderName } } | format-table -Property @{ e='DriveLetter'; width = 2}, NetworkPath -hidetableheaders
	
	if ($MappedDrives -eq $null){
		""
		Write-Host "No drives are currently mapped" -ForegroundColor Red
		""
	} else {
		Get-WmiObject -Query "SELECT Caption, ProviderName FROM Win32_MappedLogicalDisk" | Select-Object @{ Name = 'DriveLetter'; Expression = { $_.Caption } }, @{ Name = 'NetworkPath'; Expression = { $_.ProviderName } } | format-table -Property @{ e='DriveLetter'; width = 2}, NetworkPath -hidetableheaders
	}
}
Function Get-HistoricalDriveMaps{

	Write-Host "Historical Drive Mappings" -ForegroundColor Green
	$HistoricalDrives = Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\*" | Where-Object { $_.Name -like "*##*" } | ForEach-Object { ( Split-Path -Path $_.Name -Leaf ).Replace("#", "\") }
	
	if($HistoricalDrives -eq $null){
		""
		Write-Host "No historical drive maps were found" -ForegroundColor Red
		""
	} else {
		""
		Write-Host $HistoricalDrives
		""
		""
	}
}

Clear-Host
Get-CurrentDriveMaps
Get-HistoricalDriveMaps
Pause
