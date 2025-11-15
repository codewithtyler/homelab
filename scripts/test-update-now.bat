@echo off
REM Test the update script manually to verify it works
REM This runs the update immediately instead of waiting for 3 AM

echo Testing update script...
echo.

docker exec homelab-scheduler /scripts/run-update.sh

if %errorlevel% equ 0 (
    echo.
    echo ✓ Update script test completed successfully!
    echo Check logs\activity.log for results
) else (
    echo.
    echo ✗ Update script test failed
    echo Check the output above for errors
)

