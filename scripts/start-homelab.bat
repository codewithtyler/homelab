@echo off
REM Cross-platform homelab startup script
REM This script starts all homelab services

echo Starting Homelab services...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Docker is not running. Please start Docker first.
    exit /b 1
)

echo ✓ Docker is running

REM Start main services
echo Starting main services...
docker-compose up -d

REM Start MCP services (if API keys are available)
echo Starting MCP services...
call scripts\start-mcp.bat

echo ✓ Homelab services started!
echo.
echo Services available at:
echo   - Ollama: http://localhost:11434
echo   - Open WebUI: http://localhost:5000
echo   - n8n: http://localhost:5678
echo   - Coolify: http://localhost:6000
