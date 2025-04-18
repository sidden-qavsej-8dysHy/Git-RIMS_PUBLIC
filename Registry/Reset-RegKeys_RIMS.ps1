# Launch RIMS.exe, wait for 5 seconds, then close it
Start-Process -FilePath "C:\RIMS\RIMS.exe" -PassThru | ForEach-Object {
    Start-Sleep -Seconds 5
    Stop-Process -Id $_.Id -ErrorAction Ignore
}

# Reset DBUserID and DBUserPassword in the registry
$registryPath = "HKLM:\SOFTWARE\WOW6432Node\DAI\RIMS"
Set-ItemProperty -Path $registryPath -Name "DBUserID" -Value ""
Set-ItemProperty -Path $registryPath -Name "DBUserPassword" -Value ""
