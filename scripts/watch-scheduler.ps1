# Watch scheduler logs in real-time
# This will show when the update runs at 3 AM

Write-Host "Watching scheduler logs... (Press Ctrl+C to stop)" -ForegroundColor Cyan
Write-Host "The update should run at 3:00 AM" -ForegroundColor Yellow
Write-Host ""

docker logs -f homelab-scheduler

