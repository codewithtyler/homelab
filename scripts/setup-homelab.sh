#!/bin/bash
# Simple Homelab Setup Script
# This script sets up the homelab environment

echo "Setting up Homelab environment..."

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "✗ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✓ Docker is running"

# Create necessary directories
echo "Creating directory structure..."
mkdir -p logs backups scripts
mkdir -p data/ollama data/open-webui data/n8n data/coolify
mkdir -p data/coolify-redis data/coolify-db
mkdir -p data/mcp-servers/{tiktok,youtube,twitter,n8n-mcp,dashboard}

echo "✓ Directory structure created"

# Create Docker networks
echo "Creating Docker networks..."
docker network create intranet 2>/dev/null || true
docker network create mcp-network 2>/dev/null || true

echo "✓ Docker networks created"

# Pull required images
echo "Pulling Docker images..."
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

echo "✓ Docker images pulled"

echo ""
echo "🎉 Homelab setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Start services: ./scripts/start-homelab.sh"
echo "2. Check health: ./scripts/ansible-runner.sh health"
echo "3. Test updates: ./scripts/ansible-runner.sh update"
