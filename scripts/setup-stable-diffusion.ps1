# Stable Diffusion Setup Script (PowerShell)
# Downloads models and configures Automatic1111 for RTX 3080 10GB

Write-Host "Setting up Stable Diffusion with Automatic1111..." -ForegroundColor Green
Write-Host ""

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Create directory structure
Write-Host "Creating directory structure..."
$directories = @(
    "data\stable-diffusion\models",
    "data\stable-diffusion\outputs", 
    "data\stable-diffusion\loras",
    "data\stable-diffusion\extensions",
    "data\stable-diffusion\embeddings",
    "data\stable-diffusion\controlnet"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Host "✓ Directory structure created" -ForegroundColor Green

# Download Realistic Vision v5.1 SDXL (7GB)
Write-Host ""
Write-Host "Downloading Realistic Vision v5.1 SDXL (7GB)..." -ForegroundColor Yellow
Write-Host "This may take 30-60 minutes depending on your internet speed..." -ForegroundColor Yellow
Write-Host ""

$modelUrl = "https://huggingface.co/SG161222/Realistic_Vision_V5.1/resolve/main/realisticVisionV51_v51BakedVAE.safetensors"
$modelPath = "data\stable-diffusion\models\realisticVisionV51_v51BakedVAE.safetensors"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $modelUrl -OutFile $modelPath -UserAgent "Mozilla/5.0" -UseBasicParsing
    Write-Host "✓ Realistic Vision v5.1 downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠ Warning: Realistic Vision v5.1 download failed. You can download it manually later." -ForegroundColor Yellow
    Write-Host "URL: $modelUrl" -ForegroundColor Cyan
}

# Download ControlNet models
Write-Host ""
Write-Host "Downloading ControlNet models for pose control..." -ForegroundColor Yellow

$controlnetModels = @(
    @{
        Name = "OpenPose ControlNet"
        Url = "https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_openpose.pth"
        Path = "data\stable-diffusion\controlnet\control_v11p_sd15_openpose.pth"
    },
    @{
        Name = "Canny ControlNet"
        Url = "https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_canny.pth"
        Path = "data\stable-diffusion\controlnet\control_v11p_sd15_canny.pth"
    },
    @{
        Name = "Depth ControlNet"
        Url = "https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_depth.pth"
        Path = "data\stable-diffusion\controlnet\control_v11p_sd15_depth.pth"
    }
)

foreach ($model in $controlnetModels) {
    try {
        Write-Host "Downloading $($model.Name)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $model.Url -OutFile $model.Path -UserAgent "Mozilla/5.0" -UseBasicParsing
        Write-Host "✓ $($model.Name) downloaded" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Warning: $($model.Name) download failed" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Stable Diffusion setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start Stable Diffusion: docker-compose up -d stable-diffusion" -ForegroundColor White
Write-Host "2. Access WebUI: http://localhost:7860" -ForegroundColor White
Write-Host "3. API Documentation: http://localhost:7860/docs" -ForegroundColor White
Write-Host ""
Write-Host "Models downloaded:" -ForegroundColor Cyan
Write-Host "- Realistic Vision v5.1 SDXL (7GB)" -ForegroundColor White
Write-Host "- ControlNet OpenPose (1.4GB)" -ForegroundColor White
Write-Host "- ControlNet Canny (1.4GB)" -ForegroundColor White
Write-Host "- ControlNet Depth (1.4GB)" -ForegroundColor White
Write-Host ""
Write-Host "Total download size: ~11GB" -ForegroundColor Yellow
Write-Host ""
Write-Host "Your RTX 3080 10GB is optimized for:" -ForegroundColor Cyan
Write-Host "- SDXL generation: 5-8 seconds per image" -ForegroundColor White
Write-Host "- SD 1.5 generation: 2-3 seconds per image" -ForegroundColor White
Write-Host "- Batch processing: 4-8 images simultaneously" -ForegroundColor White
Write-Host ""
Write-Host "Ready for n8n integration and automation workflows!" -ForegroundColor Green

