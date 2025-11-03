@echo off
REM Simple Homelab Setup Script
REM This script sets up the homelab environment

echo Setting up Homelab environment...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Docker is not running. Please start Docker Desktop first.
    exit /b 1
)

echo ✓ Docker is running

REM Create necessary directories
echo Creating directory structure...
if not exist "logs" mkdir logs
if not exist "backups" mkdir backups
if not exist "scripts" mkdir scripts
if not exist "data\ollama" mkdir data\ollama
if not exist "data\open-webui" mkdir data\open-webui
if not exist "data\n8n" mkdir data\n8n
if not exist "data\coolify" mkdir data\coolify
if not exist "data\coolify-redis" mkdir data\coolify-redis
if not exist "data\coolify-db" mkdir data\coolify-db
if not exist "data\mcp-servers\tiktok" mkdir data\mcp-servers\tiktok
if not exist "data\mcp-servers\youtube" mkdir data\mcp-servers\youtube
if not exist "data\mcp-servers\twitter" mkdir data\mcp-servers\twitter
if not exist "data\mcp-servers\n8n-mcp" mkdir data\mcp-servers\n8n-mcp
if not exist "data\mcp-servers\dashboard" mkdir data\mcp-servers\dashboard
if not exist "data\stable-diffusion\models" mkdir data\stable-diffusion\models
if not exist "data\stable-diffusion\outputs" mkdir data\stable-diffusion\outputs
if not exist "data\stable-diffusion\loras" mkdir data\stable-diffusion\loras
if not exist "data\stable-diffusion\extensions" mkdir data\stable-diffusion\extensions
if not exist "data\stable-diffusion\embeddings" mkdir data\stable-diffusion\embeddings
if not exist "data\stable-diffusion\controlnet" mkdir data\stable-diffusion\controlnet

echo ✓ Directory structure created

REM Create Docker networks
echo Creating Docker networks...
docker network create intranet 2>nul
docker network create mcp-network 2>nul

echo ✓ Docker networks created

REM Pull required images
echo Pulling Docker images...
docker pull ollama/ollama:latest
docker pull ghcr.io/open-webui/open-webui:v0.6.33
docker pull n8nio/n8n:latest
docker pull coollabsio/coolify:latest
docker pull redis:7-alpine
docker pull postgres:15-alpine
docker pull cloudflare/cloudflared:latest
docker pull node:18-alpine
docker pull nginx:alpine
docker pull ghcr.io/czlonkowski/n8n-mcp:latest
REM Stable Diffusion will be built from Dockerfile.stable-diffusion

echo ✓ Docker images pulled

echo.
echo 🎉 Homelab setup completed successfully!
echo.
echo Next steps:
echo 1. Start services: scripts\start-homelab.bat
echo 2. Check health: scripts\ansible-runner.bat health
echo 3. Test updates: scripts\ansible-runner.bat update
