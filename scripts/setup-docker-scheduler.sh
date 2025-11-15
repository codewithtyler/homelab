#!/bin/bash
# Setup Docker-based scheduler to replace Windows Task Scheduler
# This avoids DST bugs and works cross-platform

echo "Setting up Docker-based scheduler..."
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "✗ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✓ Docker is running"
echo ""

# Make the script executable
chmod +x scripts/run-update.sh

echo "Starting scheduler container..."
docker-compose -f docker-compose-scheduler.yml up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Docker scheduler started successfully!"
    echo ""
    echo "The scheduler will run updates at 3:00 AM daily (no DST issues!)"
    echo ""
    echo "To view scheduler logs:"
    echo "  docker logs homelab-scheduler"
    echo ""
    echo "To stop the scheduler:"
    echo "  docker-compose -f docker-compose-scheduler.yml down"
else
    echo ""
    echo "✗ Failed to start scheduler"
    echo "Check Docker logs for details"
    exit 1
fi

