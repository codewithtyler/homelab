@echo off
REM Manual Windows Startup Setup Instructions
REM This script provides instructions for setting up automatic homelab startup

echo Setting up Windows startup automation...
echo.

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
echo echo Starting Homelab services at %%date%% %%time%%...
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
echo echo Homelab startup completed at %%date%% %%time%% ^>^> "%HOMELAB_DIR%\logs\startup.log"
) > "%STARTUP_SCRIPT%"

echo Created startup script: %STARTUP_SCRIPT%

REM Create logs directory if it doesn't exist
if not exist "logs" mkdir logs

echo.
echo ========================================
echo MANUAL SETUP REQUIRED
echo ========================================
echo.
echo To complete the setup, you need to manually create a Windows Task Scheduler entry:
echo.
echo 1. Press Win+R, type "taskschd.msc" and press Enter
echo 2. Click "Create Basic Task..." in the right panel
echo 3. Name: "Homelab Startup"
echo 4. Description: "Automatically start homelab services with Windows"
echo 5. Click "Next"
echo 6. Trigger: "When the computer starts"
echo 7. Click "Next"
echo 8. Action: "Start a program"
echo 9. Program/script: %STARTUP_SCRIPT%
echo 10. Click "Next" then "Finish"
echo.
echo 11. IMPORTANT: Right-click the task and select "Properties"
echo 12. Check "Run with highest privileges"
echo 13. Check "Run whether user is logged on or not"
echo 14. Click "OK"
echo.
echo ========================================
echo.
echo After setup, your homelab will start automatically with Windows!
echo Check logs\startup.log for startup information.
echo.
echo To remove auto-startup later, run: scripts\remove-windows-startup.bat
