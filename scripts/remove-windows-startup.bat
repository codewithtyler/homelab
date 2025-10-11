@echo off
REM Remove Windows Startup Automation
REM This script removes the automatic homelab startup

echo Removing Windows startup automation...

REM Remove the scheduled task
schtasks /delete /tn "Homelab Startup" /f

if %errorlevel% equ 0 (
    echo ✓ Removed Windows Task Scheduler entry
    echo ✓ Homelab will no longer start automatically with Windows
) else (
    echo ✗ Failed to remove scheduled task
    echo The task may not exist or you may need Administrator privileges
)

REM Remove the startup script
if exist "scripts\windows-startup.bat" (
    del "scripts\windows-startup.bat"
    echo ✓ Removed startup script
)

echo.
echo Manual startup removed. You can now start homelab manually with:
echo   scripts\start-homelab.bat
