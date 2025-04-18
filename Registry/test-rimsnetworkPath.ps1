# Define paths and file name

# Local user name variable
#$localUser = $env:USERNAME

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
# Search local host for RIMS.ID file
$localDrives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

foreach ($drive in $localDrives) {
    $filePath = Get-ChildItem -Path $drive -Recurse -Filter $rimsID -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($filePath) {
        Write-Host "Found $rimsID at: $($filePath.FullName)"
        break
    }
}

if (-not $filePath) {
    Write-Host "$rimsID not found on local host."
}
