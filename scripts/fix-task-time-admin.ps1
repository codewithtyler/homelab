# Run this script in PowerShell as Administrator
# Right-click PowerShell -> Run as Administrator, then run this script

$taskName = "Homelab Automated Updates"
$homelabDir = "D:\dev\homelab"
$updateScript = "$homelabDir\scripts\ansible-runner.bat update"

Write-Host "Fixing scheduled task time from 2 AM to 3 AM..." -ForegroundColor Cyan
Write-Host ""

# Delete existing task
Write-Host "Deleting existing task..." -ForegroundColor Yellow
schtasks /delete /tn $taskName /f 2>&1 | Out-Null

Start-Sleep -Seconds 2

# Create new task at 3 AM
Write-Host "Creating new task at 3:00 AM..." -ForegroundColor Yellow
$result = schtasks /create /tn $taskName /tr "cmd /c cd /d $homelabDir && $updateScript" /sc daily /st 03:00 /ru "SYSTEM" /f 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Success! Task recreated at 3:00 AM" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifying..." -ForegroundColor Yellow
    schtasks /query /tn $taskName /fo list | Select-String -Pattern "Next Run Time|Last Run Time|Task To Run"
} else {
    Write-Host ""
    Write-Host "Error: $result" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure you are running PowerShell as Administrator" -ForegroundColor Yellow
}

