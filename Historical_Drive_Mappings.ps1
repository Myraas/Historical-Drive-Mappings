Function Get-ActiveDriveMaps {
    Write-Host "Current Drive Mappings" -ForegroundColor Green
    $MappedDrives = Get-WmiObject -Query "SELECT Caption, ProviderName FROM Win32_MappedLogicalDisk" | 
                    Select-Object @{ Name = 'DriveLetter'; Expression = { $_.Caption } }, 
                                  @{ Name = 'NetworkPath'; Expression = { $_.ProviderName } } | 
                    Format-Table -Property @{ e='DriveLetter'; width = 2 }, NetworkPath -HideTableHeaders
    
    if ($null -eq $MappedDrives) {
        ""
        Write-Host "No drives are currently mapped" -ForegroundColor Red
        ""
    } else {
        $MappedDrives
    }
}

function Get-PreviousDriveMaps {
    Write-Host "Previous Drive Mappings" -ForegroundColor Green
    $HistoricalDrives = Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\*" | 
                        Where-Object { $_.Name -like "*##*" } | 
                        ForEach-Object { (Split-Path -Path $_.Name -Leaf).Replace("#", "\") }
    
    if ($null -eq $HistoricalDrives -or $HistoricalDrives.Count -eq 0) {
        ""
        Write-Host "No previous drive maps were found" -ForegroundColor Red
        ""
    } else {
        ""
        foreach ($Drive in $HistoricalDrives) {
            Write-Host $Drive
        }
        ""
    }
}

Clear-Host
Get-ActiveDriveMaps
Get-PreviousDriveMaps
Pause
