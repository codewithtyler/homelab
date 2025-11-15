@echo off
REM Setup Docker-based scheduler to replace Windows Task Scheduler
REM This avoids DST bugs and works cross-platform

echo Setting up Docker-based scheduler...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Docker is not running. Please start Docker first.
    exit /b 1
)

echo ✓ Docker is running
echo.

REM Make the script executable (for WSL/Linux compatibility)
if exist "scripts\run-update.sh" (
    echo Making update script executable...
    wsl chmod +x scripts/run-update.sh 2>nul
)

echo Starting scheduler container...
docker-compose -f docker-compose-scheduler.yml up -d

if %errorlevel% equ 0 (
    echo.
    echo ✓ Docker scheduler started successfully!
    echo.
    echo The scheduler will run updates at 3:00 AM daily (no DST issues!)
    echo.
    echo To view scheduler logs:
    echo   docker logs homelab-scheduler
    echo.
    echo To stop the scheduler:
    echo   docker-compose -f docker-compose-scheduler.yml down
    echo.
    echo You can now disable or delete the Windows Task Scheduler entries:
    echo   - Homelab Automated Updates
    echo   - Homelab Update
) else (
    echo.
    echo ✗ Failed to start scheduler
    echo Check Docker logs for details
    exit /b 1
)

