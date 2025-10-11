#!/bin/bash
# Cross-platform homelab shutdown script
# This script stops all homelab services

echo "Stopping Homelab services..."

# Stop main services
echo "Stopping main services..."
docker-compose down

# Stop MCP services
echo "Stopping MCP services..."
docker-compose -f docker-compose-mcp.yml down

echo "✓ Homelab services stopped!"
