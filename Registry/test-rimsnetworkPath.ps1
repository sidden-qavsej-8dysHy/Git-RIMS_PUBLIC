
$localUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1]

$rimsnetworkPath = "\\homelab.local\homelab-public\user\$localUser\"

write-host "The logged on Local user is: $localUser" -ForegroundColor Green

if (Test-Path -Path $rimsnetworkPath) {
    Get-ChildItem -Path $rimsnetworkPath | ForEach-Object {
        Write-Host $_.Name -ForegroundColor Cyan
    }
} else {
    Write-Host "The path $rimsnetworkPath does not exist or is inaccessible." -ForegroundColor Red
}