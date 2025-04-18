# Define paths and file name

# Local user name variable
$localUser = $env:USERNAME

# Local machine name variable
#$localMachine = $env:COMPUTERNAME

# Network path to search for RIMS.ID file
#$rimsNetPath = "\\server-02.homelab.local\homelab-public\user\$localUser.HOMELAB"

# RIMS.ID file name
$rimsID = "RIMS.ID"

# RIMS & RIMSMap Registry paths
<#$registryPaths = @(
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMS"; AppName = "RIMS" },
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMSMap"; AppName = "RIMSMap" }
)#>

#Search network path first
$rimsNetPath = "\\server-02.homelab.local\homelab-public\user\$localUser.HOMELAB"

if (Test-Path -Path $rimsNetPath) {
    $networkFilePath = Get-ChildItem -Path $rimsNetPath -Recurse -Filter $rimsID -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($networkFilePath) {
        Write-Host "Found $rimsID at: $($networkFilePath.FullName) (Literal Path: $($networkFilePath.PSPath))" -ForegroundColor Green
        # Display the content of the RIMS.ID file
        try {
            $fileContent = Get-Content -Path $networkFilePath.FullName -ErrorAction Stop
            Write-Host "Filename '${rimsID}' contains TerminalNumber:" $fileContent -ForegroundColor Green
        } catch {
            Write-Host "Failed to read the content of $rimsID. Error: $_" -ForegroundColor Green
        }
        return
    } else {
        Write-Host "$rimsID not found in network path: $rimsNetPath" -ForegroundColor Green
    }
Write-Host "Network path $rimsNetPath does not exist or is inaccessible." -ForegroundColor Green
} else {
    Write-Host "Network path $rimsNetPath does not exist or is inaccessible." -ForegroundColor Green
}
# Search local host for RIMS.ID file
$localDrives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

foreach ($drive in $localDrives) {
    $filePath = Get-ChildItem -Path $drive -Recurse -Filter $rimsID -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($filePath) {
        Write-Host "Found $rimsID at: $($filePath.FullName) (Literal Path: $($filePath.PSPath))" -ForegroundColor Yellow
        # Display the content of the RIMS.ID file
        try {
            $fileContent = Get-Content -Path $filePath.FullName -ErrorAction Stop
            Write-Host "Filename '${rimsID}' contains TerminalNUmber:" $fileContent -ForegroundColor Yellow
        } catch {
            Write-Host "Failed to read the content of $rimsID. Error: $_" -ForegroundColor Yellow
        }
        break
    }
}

if (-not $filePath) {
    Write-Host "$rimsID not found on local host."
}
