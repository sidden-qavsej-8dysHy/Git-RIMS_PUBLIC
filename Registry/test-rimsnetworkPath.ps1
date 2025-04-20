<#
.SYNOPSIS
Searches for a specific file (identified by the variable `$rimsID`) across all local drives and displays its content if found.

.DESCRIPTION
This script iterates through all local drives on the system and searches for a file matching the name stored in the `$rimsID` variable. 
It uses the `Get-ChildItem` cmdlet to perform a recursive search on each drive. If the file is found, the script outputs its full path 
and attempts to read and display its content. If the file cannot be read, an error message is displayed. If the file is not found on 
any drive, a message indicating this is shown.

.PARAMETER $rimsID
The name of the file to search for. This variable must be defined before running the script.

.OUTPUTS
- If the file is found:
    - The full path of the file.
    - The content of the file.
- If the file is not found:
    - A message indicating that the file was not found.
- If an error occurs while reading the file:
    - An error message describing the issue.

.NOTES
- "Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root" is used to get all local drives.
- The script uses `Get-ChildItem` with the `-Recurse` parameter to search through all directories and subdirectories of each drive.
- The script uses `-ErrorAction SilentlyContinue` to suppress errors during the search process.
- The `Select-Object -First 1` ensures that only the first matching file is processed.
- The script stops searching once the file is found on any drive.

.EXAMPLE
# Example usage:
# Define the file name to search for $rimsID = "RIMS.ID" //this file must be hardcoded in the script

# Run the script
# This will search for the file named "RIMS.ID" across all local drives and display its content if found.
#>

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

#Search network path first
#$rimsNetPath = "\\server-02.homelab.local\homelab-public\user\$localUser.HOMELAB"

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