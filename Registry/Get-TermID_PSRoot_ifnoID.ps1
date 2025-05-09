<#
.SYNOPSIS
This PowerShell script searches for a file named "RIMS.ID" in the C:\ drive, displays its location, reads its content, 
and updates the "TerminalNumber" property in specified registry paths based on the selected file content.

.DESCRIPTION
The script performs the following tasks:
1. Defines a list of registry paths and their associated application names.
2. Checks each registry path for the current "TerminalNumber" value and displays it.
3. Searches recursively for "RIMS.ID" files in the C:\ drive.
4. If one or more "RIMS.ID" files are found:
    - Displays the file paths and their contents.
    - Prompts the user to select one file if multiple files are found.
    - Updates the "TerminalNumber" property in the specified registry paths with the content of the selected file.
5. Handles errors, such as missing registry paths or inaccessible files.

.PARAMETER registryPaths
An array containing registry paths.

.PARAMETER rimsIdFiles
A collection of "RIMS.ID" files found in the C:\ drive.

.NOTES
- The script uses `Get-ItemProperty` to retrieve registry values and `Set-ItemProperty` to update them.
- It uses `Get-ChildItem` to search for files and `Get-Content` to read file contents.
- Error handling is implemented to manage missing registry paths, inaccessible files, and invalid user input.

.EXAMPLE
#Run the script to search for "RIMS.ID" files and update registry values:
.\Get-TermID.ps1

.MISCELLANEOUS
Jose Jimenez
#DATE: 04-09-2025
#VERSION: 2.4
#CHANGELOG:
- 04-14-2025: Modified script to include validation of multiple files.
- 04-15-2025: Changed the search scope for $rimsIdFiles to only include C:\Users and C:\RIMS direcotories to reduce the search time. 
#>

#Get computer name to help define search scope
$hostname = $env:COMPUTERNAME

#Registry paths
$registryPaths = @(
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMS"; AppName = "RIMS" },
    @{ Path = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMSMap"; AppName = "RIMSMap" }
)
#Search for "RIMS.ID" in \\$hostname\C$
$rimsIdFiles = Get-ChildItem -Path "\\$hostname\C$\Users", "\\$hostname\C$\RIMS" -Filter "RIMS.ID" -Recurse -ErrorAction SilentlyContinue

#Loop through each registry path and prompt user for terminal number
if ($registryPaths) {
    foreach ($registryPath in $registryPaths) {
        # Check if the registry path exists and retrieve the current TerminalNumber
        $currentTerminalNumber = if (Test-Path $registryPath.Path) {
            (Get-ItemProperty -Path $registryPath.Path).TerminalNumber
        } else {
            "Blank"
        }

        # Display the current TerminalNumber for each registry key
        if ([string]::IsNullOrEmpty($currentTerminalNumber)) {
            Write-Output "Current TerminalNumber for $($registryPath.AppName): Blank"
        } else {
            Write-Output "Current TerminalNumber for $($registryPath.AppName): $currentTerminalNumber"
        }

        # Notify the user that the script is searching for the updated file
        Write-Host "Searching for $($registryPath.AppName) 'RIMS.ID' in C:\..." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
    }
} else {
    Write-Output "No registry paths defined. Exiting script."
}

#Search for "RIMS.ID" files in the specified directories
if ($rimsIdFiles) {
    $firstFile = $rimsIdFiles | Select-Object -First 1
    Write-Output "`nFound 'RIMS.ID: $($content)' in {$($firstFile.FullName)}"

    try {
        $content = Get-Content -Path $firstFile.FullName -ErrorAction Stop

        #Update TerminalNumber for each registry key
        foreach ($registryPath in $registryPaths) {
            if (Test-Path $registryPath.Path) {
                try {
                    Set-ItemProperty -Path $registryPath.Path -Name "TerminalNumber" -Value $content
                    Write-Output "Updated TerminalNumber for $($registryPath.AppName) to $content"
                } catch {
                    Write-Output "Failed to update TerminalNumber for $($registryPath.AppName). Error: $_"
                }
            } else {
                Write-Output "Registry path $($registryPath.Path) does not exist. Skipping update for $($registryPath.AppName)."
            }
        }
    } catch {
        Write-Output "Unable to read the content of '$($firstFile.FullName)'. Error: $_"
    }
} else {
    Write-Output "'RIMS.ID' file not found in C:\"
    $userInput = Read-Host "Please enter the TerminalNumber to update the registry"
    
    #Update TerminalNumber for each registry key with user input
    foreach ($registryPath in $registryPaths) {
        if (Test-Path $registryPath.Path) {
            try {
                Set-ItemProperty -Path $registryPath.Path -Name "TerminalNumber" -Value $userInput
                Write-Output "Updated TerminalNumber for $($registryPath.AppName) to $userInput"
            } catch {
                Write-Output "Failed to update TerminalNumber for $($registryPath.AppName). Error: $_"
            }
        } else {
            Write-Output "Registry path $($registryPath.Path) does not exist. Skipping update for $($registryPath.AppName)."
        }
    }
}