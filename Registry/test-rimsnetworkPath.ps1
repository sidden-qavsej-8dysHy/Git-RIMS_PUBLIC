<#
.SYNOPSIS
Searches for a file named "RIMS.ID" in various predefined locations.

.DESCRIPTION
This script attempts to locate a file named "RIMS.ID" by searching in the following order:
1. A network path specific to the current user.
2. The local user profile directory.
3. The root directory of the C: drive.

If the file is found, its full path is displayed, and its content is read and output to the console. 
If the file is not found in one location, the script proceeds to search in the next location.

.OUTPUTS
- Writes the full path of the located "RIMS.ID" file to the console.
- Outputs the content of the "RIMS.ID" file if found.
- Displays appropriate messages indicating the search status.

.NOTES
- The script uses the `$env:USERNAME` environment variable to determine the current user's name.
- The network path is constructed using the current user's name and a predefined network share.

.EXAMPLE
# Run the script to search for the "RIMS.ID" file:
.\test-rimsnetworkPath.ps1

# Output:
# Found RIMS.ID file at: \\server-02.homelab.local\homelab-public\user\JohnDoe.HOMELAB\RIMS.ID
# <Content of the RIMS.ID file>

# If the file is not found, the script will display messages indicating the search status and locations checked.
#>

$localUser = $env:USERNAME

$usernetPath = "\\server-02.homelab.local\homelab-public\user\$localUser.HOMELAB\"

if (Test-Path -Path $usernetPath) {
    $rimsIdFile = Get-ChildItem -Path $usernetPath -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
    if ($rimsIdFile) {
        Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
        Get-Content -Path $rimsIdFile.FullName
    } else {
        Write-Host "RIMS.ID file not found in $usernetPath. Searching in $localUser's profile path..." -ForegroundColor Yellow
        $localUserPath = "C:\Users\$localUser.HOMELAB\"
        # Check if the local user path exists
        if (Test-Path -Path $localUserPath) {
            $rimsIdFile = Get-ChildItem -Path $localUserPath -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
            if ($rimsIdFile) {
                Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
                Get-Content -Path $rimsIdFile.FullName
            } else {
                Write-Host "RIMS.ID file not found in $localUser's profile path. Searching in C:\..." -ForegroundColor Yellow
                $rimsIdFile = Get-ChildItem -Path "C:\" -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
                if ($rimsIdFile) {
                    Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
                    Get-Content -Path $rimsIdFile.FullName
                } else {
                    Write-Host "RIMS.ID file not found in C:\." -ForegroundColor Red
                }
            }
        } else {
            Write-Host "The path $localUserPath does not exist. Searching in C:\..." -ForegroundColor Yellow
            $rimsIdFile = Get-ChildItem -Path "C:\" -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
            if ($rimsIdFile) {
                Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
                Get-Content -Path $rimsIdFile.FullName
            } else {
                Write-Host "RIMS.ID file not found in C:\." -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "The path $usernetPath does not exist. Searching in C:\..." -ForegroundColor Yellow
    $rimsIdFile = Get-ChildItem -Path "C:\" -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
    if ($rimsIdFile) {
        Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
        Get-Content -Path $rimsIdFile.FullName
    } else {
        Write-Host "RIMS.ID file not found in C:\." -ForegroundColor Red
    }
}