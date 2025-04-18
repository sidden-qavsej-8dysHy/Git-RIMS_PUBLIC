# Define paths and file name

# Local user name variable
#$localUser = $env:USERNAME

# Local machine name variable
#$localMachine = $env:COMPUTERNAME
$localCDrive = "C:\"

# Network path to search for RIMS.ID file
#$rimsNetPath = "\\server-02.homelab.local\homelab-public\user\$localUser.HOMELAB"

# RIMS.ID file name
$rimsID = "RIMS.ID"

# RIMS & RIMSMap Registry paths
$registryPaths = @(
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMS"; AppName = "RIMS" },
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMSMap"; AppName = "RIMSMap" }
)

# Search for $rimsID in $localCDrive

# Search for RIMS.ID in C:\ drive
Write-Host "Searching for $rimsID in $localCDrive..."
$rimsFilePath = Get-ChildItem -Path $localCDrive -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $rimsID }

if ($rimsFilePath) {
    Write-Host "File found at: $($rimsFilePath.FullName)" -ForegroundColor Yellow
    Write-Host "Displaying content of $($rimsID):" -ForegroundColor Yellow
    Get-Content -Path $rimsFilePath.FullName | ForEach-Object { Write-Host $_ -ForegroundColor Green }
} else {
    Write-Host "File not found in $localCDrive." -ForegroundColor Red
}
# If the file was found, use its content to update TerminalNumber in the registry paths
if ($rimsFilePath) {
    $terminalNumber = Get-Content -Path $rimsFilePath.FullName | Select-Object -First 1

    foreach ($registryPath in $registryPaths) {
        $path = $registryPath.Path
        $appName = $registryPath.AppName

        Write-Host "Updating TerminalNumber for $appName in $path..." -ForegroundColor Yellow 
        # Check if the registry path exists
        if (-not (Test-Path $path)) {
            Write-Host "Registry path $path does not exist. Skipping update for $appName." -ForegroundColor Red
            continue
        }
        try {
            Set-ItemProperty -Path $path -Name "TerminalNumber" -Value $terminalNumber -ErrorAction Stop
            Write-Host "TerminalNumber updated."
        } catch {
            Write-Host "Failed to update TerminalNumber in $path. Error: $_"
        }
    }
}