
#$localUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1] -replace '\.HOMELAB$', ''
<#
$localUser = $env:USERNAME

$rimsnetworkPath = "\\homelab.local\homelab-public\user\$localUser.HOMELAB\"

if (Test-Path -Path $userProfilePath) {
    Write-Host "The user profile path exists: $userProfilePath3" -ForegroundColor Green
    $rimsIdFile = Get-ChildItem -Path $userProfilePath -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
    if ($rimsIdFile) {
        Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
    } else {
        Write-Host "RIMS.ID file not found in the user profile path." -ForegroundColor Yellow
    }
    Write-Host "Local User: $localUser" -ForegroundColor Magenta
    Write-Host "RIMS Network Path: $rimsnetworkPath" -ForegroundColor Magenta
} else {
    Write-Host "The user profile path $userProfilePath does not exist.4" -ForegroundColor Red
}
#>

<#
class RimsNetworkPathChecker {
    [string]$LocalUser
    [string]$RimsNetworkPath
    [string]$UserProfilePath

    RimsNetworkPathChecker([string]$userProfilePath) {
        $this.LocalUser = $env:USERNAME
        $this.RimsNetworkPath = "\\homelab.local\homelab-public\user\$($this.LocalUser).HOMELAB\"
        $this.UserProfilePath = $userProfilePath
    }

    [void]CheckPath() {
        if (Test-Path -Path $this.UserProfilePath) {
            Write-Host "The user profile path exists: $($this.UserProfilePath)" -ForegroundColor Green
            $rimsIdFile = Get-ChildItem -Path $this.UserProfilePath -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
            if ($rimsIdFile) {
                Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
            } else {
                Write-Host "RIMS.ID file not found in the user profile path." -ForegroundColor Yellow
            }
            Write-Host "Local User: $($this.LocalUser)" -ForegroundColor Magenta
            Write-Host "RIMS Network Path: $($this.RimsNetworkPath)" -ForegroundColor Magenta
        } else {
            Write-Host "The user profile path $($this.UserProfilePath) does not exist." -ForegroundColor Red
        }
    }
}

# Example usage:
$userProfilePath = "C:\Users\$env:USERNAME"
$rimsChecker = [RimsNetworkPathChecker]::new($userProfilePath)
$rimsChecker.CheckPath()
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
                Write-Host "RIMS.ID file not found in $localUser's profile path." -ForegroundColor Red
            }
        } else {
            Write-Host "The path $localUserPath does not exist." -ForegroundColor Red
        }
    }
} else {
    Write-Host "The path $usernetPath does not exist." -ForegroundColor Red
}