# Start Stable Diffusion Service (PowerShell)
# This script starts the Stable Diffusion service and downloads models if needed

Write-Host "Starting Stable Diffusion with Automatic1111..." -ForegroundColor Green
Write-Host ""

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if models exist
$modelPath = "data\stable-diffusion\models\realisticVisionV51_v51BakedVAE.safetensors"
if (!(Test-Path $modelPath)) {
    Write-Host "⚠ Realistic Vision v5.1 model not found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Would you like to download models now? (This will take 30-60 minutes)" -ForegroundColor Cyan
    $choice = Read-Host "Download models? (Y/N)"
    
    if ($choice -eq "Y" -or $choice -eq "y") {
        Write-Host ""
        Write-Host "Starting model download..." -ForegroundColor Yellow
        & "scripts\setup-stable-diffusion.ps1"
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "Starting Stable Diffusion without models..." -ForegroundColor Yellow
        Write-Host "You can download models later by running: scripts\setup-stable-diffusion.ps1" -ForegroundColor Cyan
        Write-Host ""
    }
}

# Start Stable Diffusion service
Write-Host "Starting Stable Diffusion service..." -ForegroundColor Cyan
docker-compose up -d stable-diffusion

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to start Stable Diffusion service" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Stable Diffusion service started successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 Stable Diffusion is now running!" -ForegroundColor Green
Write-Host ""
Write-Host "Access points:" -ForegroundColor Cyan
Write-Host "- WebUI: http://localhost:7860" -ForegroundColor White
Write-Host "- API Docs: http://localhost:7860/docs" -ForegroundColor White
Write-Host ""
Write-Host "Your RTX 3080 10GB is optimized for:" -ForegroundColor Cyan
Write-Host "- SDXL generation: 5-8 seconds per image" -ForegroundColor White
Write-Host "- SD 1.5 generation: 2-3 seconds per image" -ForegroundColor White
Write-Host "- Batch processing: 4-8 images simultaneously" -ForegroundColor White
Write-Host ""
Write-Host "Ready for n8n integration and automation workflows!" -ForegroundColor Green
Write-Host ""
Write-Host "To stop: docker-compose stop stable-diffusion" -ForegroundColor Yellow
Write-Host "To view logs: docker-compose logs -f stable-diffusion" -ForegroundColor Yellow

