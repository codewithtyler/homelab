@echo off
REM Windows Startup Automation Setup
REM This script sets up automatic homelab startup with Windows

echo Setting up Windows startup automation...

REM Get the current directory
set HOMELAB_DIR=%CD%
set STARTUP_SCRIPT=%HOMELAB_DIR%\scripts\windows-startup.bat

echo Creating startup script...

REM Create the startup script
(
echo @echo off
echo REM Automatic Homelab Startup
echo REM This script runs at Windows startup
echo.
echo echo Starting Homelab services at %date% %time%...
echo.
echo REM Wait for Docker Desktop to start
echo timeout /t 30 /nobreak ^>nul
echo.
echo REM Check if Docker is running
echo docker info ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo Docker not ready yet, waiting...
echo     timeout /t 60 /nobreak ^>nul
echo ^)
echo.
echo REM Start homelab services
echo cd /d "%HOMELAB_DIR%"
echo call scripts\start-homelab.bat
echo.
echo echo Homelab startup completed at %date% %time% ^>^> "%HOMELAB_DIR%\logs\startup.log"
) > "%STARTUP_SCRIPT%"

echo Created startup script: %STARTUP_SCRIPT%

REM Create logs directory if it doesn't exist
if not exist "logs" mkdir logs

echo Setting up Windows Task Scheduler...

REM Create a scheduled task for startup
schtasks /create /tn "Homelab Startup" /tr "%STARTUP_SCRIPT%" /sc onstart /ru "SYSTEM" /f

if %errorlevel% equ 0 (
    echo ✓ Created Windows Task Scheduler entry
    echo ✓ Homelab will start automatically with Windows
    echo.
    echo Note: The task runs with SYSTEM privileges to avoid UAC prompts
    echo Services will start approximately 1-2 minutes after Windows startup
) else (
    echo ✗ Failed to create scheduled task
    echo You may need to run this script as Administrator
    echo.
    echo Manual setup:
    echo 1. Open Task Scheduler
    echo 2. Create Basic Task named "Homelab Startup"
    echo 3. Trigger: "When the computer starts"
    echo 4. Action: "Start a program"
    echo 5. Program: %STARTUP_SCRIPT%
    echo 6. Run with highest privileges: Yes
)

echo.
echo Setup complete! Your homelab will start automatically with Windows.
echo Check logs\startup.log for startup information.
