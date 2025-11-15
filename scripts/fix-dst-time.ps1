# Fix DST Time Issue in Scheduled Task
# This fixes the Windows Task Scheduler bug where task shows 3 AM but runs at 2 AM

$taskName = "Homelab Automated Updates"

Write-Host "Fixing DST time issue for task: $taskName" -ForegroundColor Cyan
Write-Host ""

try {
    # Get the task
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
    
    Write-Host "Current trigger settings:" -ForegroundColor Yellow
    $task.Triggers | ForEach-Object {
        Write-Host "  Start Time: $($_.StartBoundary)" -ForegroundColor Gray
        Write-Host "  Next Run: $($task.NextRunTime)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "Fixing trigger time..." -ForegroundColor Yellow
    
    # Get the trigger
    $trigger = $task.Triggers[0]
    
    # Force recalculation by changing time slightly then back
    $originalTime = [DateTime]::Parse($trigger.StartBoundary)
    Write-Host "Original time: $originalTime" -ForegroundColor Gray
    
    # Set to 3:01 AM temporarily
    $tempTime = Get-Date -Year $originalTime.Year -Month $originalTime.Month -Day $originalTime.Day -Hour 3 -Minute 1 -Second 0
    $trigger.StartBoundary = $tempTime.ToString("yyyy-MM-ddTHH:mm:ss")
    
    # Save the change
    $task.Triggers[0] = $trigger
    Set-ScheduledTask -Task $task -ErrorAction Stop
    
    Write-Host "  Set to 3:01 AM temporarily..." -ForegroundColor Green
    
    # Now set it back to exactly 3:00 AM
    $correctTime = Get-Date -Year $originalTime.Year -Month $originalTime.Month -Day $originalTime.Day -Hour 3 -Minute 0 -Second 0
    $trigger.StartBoundary = $correctTime.ToString("yyyy-MM-ddTHH:mm:ss")
    
    # Save the corrected time
    $task.Triggers[0] = $trigger
    Set-ScheduledTask -Task $task -ErrorAction Stop
    
    Write-Host "  Set to 3:00 AM..." -ForegroundColor Green
    
    # Verify
    $updatedTask = Get-ScheduledTask -TaskName $taskName
    Write-Host ""
    Write-Host "Updated trigger settings:" -ForegroundColor Green
    $updatedTask.Triggers | ForEach-Object {
        Write-Host "  Start Time: $($_.StartBoundary)" -ForegroundColor Gray
    }
    Write-Host "  Next Run: $($updatedTask.NextRunTime)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Task time fixed! It should now run at 3:00 AM correctly." -ForegroundColor Green
    
} catch {
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please ensure you are running PowerShell as Administrator" -ForegroundColor Yellow
    Write-Host "Task name should be: $taskName" -ForegroundColor Yellow
    exit 1
}
