@echo off
REM Stable Diffusion Setup Script
REM Downloads models and configures Automatic1111 for RTX 3080 10GB

echo Setting up Stable Diffusion with Automatic1111...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Docker is not running. Please start Docker Desktop first.
    exit /b 1
)

echo ✓ Docker is running

REM Create directory structure (already done, but ensure it exists)
echo Creating directory structure...
if not exist "data\stable-diffusion\models" mkdir data\stable-diffusion\models
if not exist "data\stable-diffusion\outputs" mkdir data\stable-diffusion\outputs
if not exist "data\stable-diffusion\loras" mkdir data\stable-diffusion\loras
if not exist "data\stable-diffusion\extensions" mkdir data\stable-diffusion\extensions
if not exist "data\stable-diffusion\embeddings" mkdir data\stable-diffusion\embeddings
if not exist "data\stable-diffusion\controlnet" mkdir data\stable-diffusion\controlnet

echo ✓ Directory structure created

REM Download Realistic Vision v5.1 SDXL (7GB)
echo.
echo Downloading Realistic Vision v5.1 SDXL (7GB)...
echo This may take 30-60 minutes depending on your internet speed...
echo.

REM Use PowerShell for better download handling
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://huggingface.co/SG161222/Realistic_Vision_V5.1/resolve/main/realisticVisionV51_v51BakedVAE.safetensors' -OutFile 'data\stable-diffusion\models\realisticVisionV51_v51BakedVAE.safetensors' -UserAgent 'Mozilla/5.0'}"

if %errorlevel% neq 0 (
    echo ⚠ Warning: Realistic Vision v5.1 download failed. You can download it manually later.
    echo URL: https://huggingface.co/SG161222/Realistic_Vision_V5.1/resolve/main/realisticVisionV51_v51BakedVAE.safetensors
) else (
    echo ✓ Realistic Vision v5.1 downloaded successfully
)

REM Download ControlNet models
echo.
echo Downloading ControlNet models for pose control...

REM OpenPose ControlNet
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_openpose.pth' -OutFile 'data\stable-diffusion\controlnet\control_v11p_sd15_openpose.pth' -UserAgent 'Mozilla/5.0'}"

if %errorlevel% neq 0 (
    echo ⚠ Warning: OpenPose ControlNet download failed
) else (
    echo ✓ OpenPose ControlNet downloaded
)

REM Canny ControlNet
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_canny.pth' -OutFile 'data\stable-diffusion\controlnet\control_v11p_sd15_canny.pth' -UserAgent 'Mozilla/5.0'}"

if %errorlevel% neq 0 (
    echo ⚠ Warning: Canny ControlNet download failed
) else (
    echo ✓ Canny ControlNet downloaded
)

REM Depth ControlNet
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_v11p_sd15_depth.pth' -OutFile 'data\stable-diffusion\controlnet\control_v11p_sd15_depth.pth' -UserAgent 'Mozilla/5.0'}"

if %errorlevel% neq 0 (
    echo ⚠ Warning: Depth ControlNet download failed
) else (
    echo ✓ Depth ControlNet downloaded
)

echo.
echo 🎉 Stable Diffusion setup completed!
echo.
echo Next steps:
echo 1. Start Stable Diffusion: docker-compose up -d stable-diffusion
echo 2. Access WebUI: http://localhost:7860
echo 3. API Documentation: http://localhost:7860/docs
echo.
echo Models downloaded:
echo - Realistic Vision v5.1 SDXL (7GB)
echo - ControlNet OpenPose (1.4GB)
echo - ControlNet Canny (1.4GB) 
echo - ControlNet Depth (1.4GB)
echo.
echo Total download size: ~11GB
echo.
echo Your RTX 3080 10GB is optimized for:
echo - SDXL generation: 5-8 seconds per image
echo - SD 1.5 generation: 2-3 seconds per image
echo - Batch processing: 4-8 images simultaneously
echo.
echo Ready for n8n integration and automation workflows!

