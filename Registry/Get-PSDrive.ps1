# Get all PSDrives that use the FileSystem provider
Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root | ForEach-Object {
    # Get the drive letter (e.g., C:\, D:\, etc.)
    $driveLetter = $_.Substring(0, 2)

    # Get all files in the root directory of the drive
    $files = Get-ChildItem -Path $driveLetter -Recurse -ErrorAction SilentlyContinue

    # Filter for files named "RIMS.ID"
    $rimsIDFile = $files | Where-Object { $_.Name -eq "RIMS.ID" } | Select-Object -First 1

    if ($rimsIDFile) {
        Write-Host "Found RIMS.ID at: $($rimsIDFile.FullName) (Literal Path: $($rimsIDFile.PSPath))" -ForegroundColor Yellow
        break
    }
}
# If the file was not found, display a message