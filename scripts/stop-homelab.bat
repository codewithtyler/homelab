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

echo ✓ Homelab services stopped!
