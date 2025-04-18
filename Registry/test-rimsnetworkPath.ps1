
#$localUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1] -replace '\.HOMELAB$', ''

$localUser = $env:USERNAME

#$rimsnetworkPath = "\\homelab.local\homelab-public\user\$localUser.HOMELAB\"

$userProfilePath = "C:\Users\$localUser.HOMELAB"

if (Test-Path -Path $userProfilePath) {
    Write-Host "The user profile path exists: $userProfilePath3" -ForegroundColor Green
    $rimsIdFile = Get-ChildItem -Path $userProfilePath -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue
    if ($rimsIdFile) {
        Write-Host "Found RIMS.ID file at: $($rimsIdFile.FullName)" -ForegroundColor Cyan
    } else {
        Write-Host "RIMS.ID file not found in the user profile path." -ForegroundColor Yellow
    }
} else {
    Write-Host "The user profile path $userProfilePath does not exist.4" -ForegroundColor Red
}