#!/bin/bash
# Cross-platform homelab startup script
# This script starts all homelab services

echo "Starting Homelab services..."

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "✗ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✓ Docker is running"

# Start main services
echo "Starting main services..."
docker-compose up -d

# Start MCP services (if API keys are available)
echo "Starting MCP services..."
./scripts/start-mcp.sh

echo "✓ Homelab services started!"
echo ""
echo "Services available at:"
echo "  - Ollama: http://localhost:11434"
echo "  - Open WebUI: http://localhost:5000"
echo "  - n8n: http://localhost:5678"
echo "  - Coolify: http://localhost:6000"
