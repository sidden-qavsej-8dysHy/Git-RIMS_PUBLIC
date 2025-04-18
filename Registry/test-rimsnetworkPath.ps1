

$rimsnetworkPath = "\\homelab.local\homelab-public\user\%USERNAME%\"

$localUser = $env:USERNAME
write-host "Local user: $localUser" -ForegroundColor Green

if ($rimsnetworkPath -like "*$localUser*") {
    Write-Output "The username '$localUser' was found in the network path."
    $userFolderContents = Get-ChildItem -Path $rimsnetworkPath -ErrorAction SilentlyContinue
    if ($userFolderContents) {
        Write-Output "Contents of the user folder:"
        $userFolderContents | ForEach-Object { Write-Output $_.Name }
    } else {
        Write-Output "Unable to retrieve the contents of the user folder. The path might not exist or is inaccessible."
    }
} else {
    Write-Output "The username '$localUser' was not found in the network path."
}