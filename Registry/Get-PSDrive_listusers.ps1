
# Get a list of users from the system
$users = Get-ChildItem -Path "C:\Users" -Directory | Select-Object -ExpandProperty Name
Write-Host "Available users:" -ForegroundColor Cyan
for ($i = 0; $i -lt $users.Count; $i++) {
    Write-Host "$($i + 1): $($users[$i])"
}
$userChoiceIndex = Read-Host "Enter the number corresponding to the user you want to select"

if ($userChoiceIndex -match '^\d+$' -and $userChoiceIndex -ge 1 -and $userChoiceIndex -le $users.Count) {
    $userChoice = $users[$userChoiceIndex - 1]
} else {
    $userChoice = $null
}
if (-not $userChoice) {
    Write-Host "No user selected. Exiting script." -ForegroundColor Red
    exit
}

# Narrow down the search to the selected user
$userPath = "C:\Users\$userChoice"

# Check if the user directory exists
if (Test-Path -Path $userPath) {
    # Search for "RIMS.ID" file in the user's directory
    $rimsIDFile = Get-ChildItem -Path $userPath -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "RIMS.ID" } | Select-Object -First 1

    if ($rimsIDFile) {
        Write-Host "Found RIMS.ID at: $($rimsIDFile.FullName) (Literal Path: $($rimsIDFile.PSPath))" -ForegroundColor Yellow
    } else {
        Write-Host "RIMS.ID file not found in the selected user's directory." -ForegroundColor Red
    }
} else {
    Write-Host "The directory for the selected user does not exist." -ForegroundColor Red
}
# If the file was not found, display a message