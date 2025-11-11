@echo off
setlocal enabledelayedexpansion
REM Homelab Update Script
REM This script checks for and applies updates to homelab services

echo === Homelab Update Process ===
for /f "tokens=*" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd hh:mm tt'"') do set TIMESTAMP=%%i
echo Timestamp: %TIMESTAMP%
echo.

echo Checking for available updates...
REM Get list of services from docker-compose
docker-compose config --services > services_list.tmp 2>nul

REM Check each service individually to see if it needs updating
set SERVICES_TO_UPDATE=
for /f "usebackq tokens=*" %%s in ("services_list.tmp") do (
    REM Try to pull just this service quietly and check if anything was downloaded
    docker-compose pull --quiet %%s > pull_check.tmp 2>&1
    findstr /C:"Downloaded" /C:"Pulling" pull_check.tmp >nul 2>&1
    if !errorlevel! equ 0 (
        REM Check if it actually downloaded (not just "Image is up to date")
        findstr /C:"Downloaded" pull_check.tmp >nul 2>&1
        if !errorlevel! equ 0 (
            if not defined SERVICES_TO_UPDATE (
                set SERVICES_TO_UPDATE=%%s
            ) else (
                set SERVICES_TO_UPDATE=!SERVICES_TO_UPDATE! %%s
            )
            echo   %%s - Update available
        ) else (
            echo   %%s - Up to date
        )
    )
)

del services_list.tmp pull_check.tmp 2>nul

if not defined SERVICES_TO_UPDATE (
    echo.
    echo Generating Summary...
    echo All images are up to date - no updates needed.

    REM Log no updates
    for /f "tokens=*" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd hh:mm tt'"') do set LOGTIME=%%i
    echo Update process completed at !LOGTIME! - No updates available>> logs\activity.log
    endlocal
    exit /b 0
)

REM Pull only the services that need updates
echo.
echo Pulling updated images for: !SERVICES_TO_UPDATE!
docker-compose pull !SERVICES_TO_UPDATE! > pull_output.tmp 2>&1

REM Show what was updated
echo.
echo Updated images:
findstr /C:"Downloaded" pull_output.tmp

REM Only recreate containers whose images changed
echo.
echo Restarting containers with updated images...
docker-compose up -d !SERVICES_TO_UPDATE! > update_output.tmp 2>&1

REM Extract which containers were actually recreated
set UPDATED_CONTAINERS=
for /f "tokens=2 delims= " %%a in ('findstr /C:"Recreating" /C:"Creating" update_output.tmp 2^>nul') do (
    if not defined UPDATED_CONTAINERS (
        set UPDATED_CONTAINERS=%%a
    ) else (
        set UPDATED_CONTAINERS=!UPDATED_CONTAINERS!, %%a
    )
)

if defined UPDATED_CONTAINERS (
    echo Updated containers: !UPDATED_CONTAINERS!
) else (
    echo No containers were recreated.
)

echo.
echo Cleaning up old images...
docker image prune -f

REM Clean up temp files
del pull_output.tmp update_output.tmp 2>nul

REM Log with accurate timestamp and update info
for /f "tokens=*" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd hh:mm tt'"') do set LOGTIME=%%i
if defined UPDATED_CONTAINERS (
    echo Update process completed at !LOGTIME! - Updated containers: !UPDATED_CONTAINERS!>> logs\activity.log
) else (
    echo Update process completed at !LOGTIME! - Images updated but no containers recreated>> logs\activity.log
)
endlocal
