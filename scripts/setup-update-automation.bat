@echo off
REM Windows Update Automation Setup
REM This script sets up automatic homelab updates with Windows

echo Setting up Windows update automation...

REM Get the current directory
set HOMELAB_DIR=%CD%
set UPDATE_SCRIPT=%HOMELAB_DIR%\scripts\ansible-runner.bat update

REM Create logs directory if it doesn't exist
if not exist "logs" mkdir logs

echo Setting up Windows Task Scheduler for updates...

REM Create a scheduled task for updates at 3 AM daily
REM Note: The task needs to run in the homelab directory so Ansible can find inventory.ini
schtasks /create /tn "Homelab Update" /tr "cmd /c cd /d %HOMELAB_DIR% && %UPDATE_SCRIPT%" /sc daily /st 03:00 /ru "SYSTEM" /f

if %errorlevel% equ 0 (
    echo ✓ Created Windows Task Scheduler entry for updates
    echo ✓ Homelab will update automatically at 3:00 AM daily using Ansible
    echo.
    echo Note: The task runs with SYSTEM privileges to avoid UAC prompts
    echo Updates are checked via GitHub releases API and docker-compose.yml is updated automatically
) else (
    echo ✗ Failed to create scheduled task
    echo You may need to run this script as Administrator
    echo.
    echo Manual setup:
    echo 1. Open Task Scheduler
    echo 2. Create Basic Task named "Homelab Update"
    echo 3. Trigger: "Daily at 3:00 AM"
    echo 4. Action: "Start a program"
    echo 5. Program: cmd
    echo 6. Arguments: /c cd /d %HOMELAB_DIR% && %UPDATE_SCRIPT%
    echo 7. Start in: %HOMELAB_DIR%
    echo 8. Run with highest privileges: Yes
)

echo.
echo Update automation setup complete!
echo Check logs\activity.log for update information.
