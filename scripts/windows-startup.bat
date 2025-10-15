@echo off
REM Automatic Homelab Startup
REM This script runs at Windows startup

echo Starting Homelab services at %date% %time%...

REM Wait for Docker Desktop to start
timeout /t 30 /nobreak >nul

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker not ready yet, waiting...
    timeout /t 60 /nobreak >nul
)

REM Start homelab services
cd /d "D:\dev\homelab"
call scripts\start-homelab.bat

echo Homelab startup completed at %date% %time%>> "D:\dev\homelab\logs\activity.log"
