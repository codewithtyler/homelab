@echo off
REM Fix DST Time Issue in Scheduled Task
REM This script fixes the Windows Task Scheduler DST bug where the task shows 3 AM
REM but actually runs at 2 AM after DST ends

echo Fixing DST time issue in Homelab Automated Updates task...
echo.

REM Get the current directory
set HOMELAB_DIR=%CD%
set UPDATE_SCRIPT=%HOMELAB_DIR%\scripts\ansible-runner.bat update

REM Export current task to see what's wrong
echo Current task configuration:
schtasks /query /tn "Homelab Automated Updates" /fo list /v | findstr /i "time\|trigger\|next"

echo.
echo Deleting and recreating task with correct 3 AM time...
echo.

REM Delete the existing task
schtasks /delete /tn "Homelab Automated Updates" /f

REM Wait a moment
timeout /t 2 /nobreak >nul

REM Create new task with explicit 3 AM time
REM Using /st 03:00 forces it to 3 AM local time
schtasks /create /tn "Homelab Automated Updates" /tr "cmd /c cd /d %HOMELAB_DIR% && %UPDATE_SCRIPT%" /sc daily /st 03:00 /ru "SYSTEM" /f

if %errorlevel% equ 0 (
    echo.
    echo ✓ Task recreated successfully
    echo.
    echo Verifying the new schedule:
    schtasks /query /tn "Homelab Automated Updates" /fo list | findstr /i "time\|trigger\|next"
    echo.
    echo The task should now run at 3:00 AM correctly.
) else (
    echo.
    echo ✗ Failed to recreate task
    echo Please ensure you're running as Administrator
    exit /b 1
)

