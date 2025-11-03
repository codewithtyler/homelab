@echo off
REM Cross-platform homelab shutdown script
REM This script stops all homelab services

echo Stopping Homelab services...

REM Stop main services
echo Stopping main services...
docker-compose down

REM Stop MCP services
echo Stopping MCP services...
docker-compose -f docker-compose-mcp.yml down

REM Stop Stable Diffusion (local installation)
echo Stopping Stable Diffusion...
taskkill /F /FI "WINDOWTITLE eq launch.py*" >nul 2>&1
taskkill /F /IM python.exe /FI "COMMANDLINE eq *launch.py*" >nul 2>&1
echo ✓ Stable Diffusion stopped...

echo ✓ Homelab services stopped!
