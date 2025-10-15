@echo off
REM Homelab Update Script
REM This script checks for and applies updates to homelab services

echo === Homelab Update Process ===
echo Timestamp: %date% %time%
echo.

echo Checking for service updates...

REM Pull latest images and restart services
echo Pulling latest Docker images...
docker-compose pull

echo Restarting services with latest images...
docker-compose up -d

echo Update completed successfully!

REM Clean up old images
echo Cleaning up old images...
docker image prune -f

echo Update process completed at %date% %time%>> logs\activity.log
echo ✓ Homelab services updated successfully
