@echo off
REM Fix Update Schedule Time
REM This script updates the scheduled task to run at 3 AM instead of 2 AM

echo Fixing Homelab Update schedule to 3:00 AM...

REM Get the current directory
set HOMELAB_DIR=%CD%
set UPDATE_SCRIPT=%HOMELAB_DIR%\scripts\ansible-runner.bat update

REM Delete existing task if it exists
schtasks /delete /tn "Homelab Update" /f >nul 2>&1

REM Create new task at 3 AM
schtasks /create /tn "Homelab Update" /tr "cmd /c cd /d %HOMELAB_DIR% && %UPDATE_SCRIPT%" /sc daily /st 03:00 /ru "SYSTEM" /f

if %errorlevel% equ 0 (
    echo ✓ Updated scheduled task to run at 3:00 AM daily
    echo.
    echo The task will now run at 3:00 AM local time regardless of DST changes
) else (
    echo ✗ Failed to update scheduled task
    echo.
    echo Please run this script as Administrator:
    echo   1. Right-click this file
    echo   2. Select "Run as administrator"
    echo   3. Or run: schtasks /create /tn "Homelab Update" /tr "cmd /c cd /d %HOMELAB_DIR% && %UPDATE_SCRIPT%" /sc daily /st 03:00 /ru "SYSTEM" /f
    exit /b 1
)

echo.
echo Schedule fixed! Updates will run at 3:00 AM starting tomorrow.

