@echo off
REM Cross-platform MCP Services Startup Script
REM This script checks for required API keys and starts only the services that have them

echo Loading environment variables...

REM Load environment variables from mcp.env file
if exist mcp.env (
    for /f "usebackq tokens=1,2 delims==" %%a in (mcp.env) do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
        )
    )
    echo ✓ Loaded environment variables from mcp.env
) else (
    echo ✗ mcp.env file not found
    exit /b 1
)

echo Checking for MCP service API keys...

REM Check which services have their required API keys
set available_profiles=

REM Check TikTok API keys
if defined TIKTOK_API_KEY if defined TIKTOK_API_SECRET if defined TIKTOK_ACCESS_TOKEN (
    echo ✓ TikTok API keys found
    set available_profiles=%available_profiles%tiktok,
) else (
    echo ✗ TikTok API keys missing - skipping tiktok-mcp
)

REM Check YouTube API keys
if defined YOUTUBE_API_KEY if defined YOUTUBE_CLIENT_ID if defined YOUTUBE_CLIENT_SECRET if defined YOUTUBE_REFRESH_TOKEN (
    echo ✓ YouTube API keys found
    set available_profiles=%available_profiles%youtube,
) else (
    echo ✗ YouTube API keys missing - skipping youtube-mcp
)

REM Check Twitter API keys
if defined TWITTER_API_KEY if defined TWITTER_API_SECRET if defined TWITTER_ACCESS_TOKEN if defined TWITTER_ACCESS_TOKEN_SECRET if defined TWITTER_BEARER_TOKEN (
    echo ✓ Twitter API keys found
    set available_profiles=%available_profiles%twitter,
) else (
    echo ✗ Twitter API keys missing - skipping twitter-mcp
)

REM Check n8n MCP API keys
if defined N8N_API_URL if defined N8N_API_KEY (
    echo ✓ n8n MCP API keys found
    set available_profiles=%available_profiles%n8n-mcp,
) else (
    echo ✗ n8n MCP API keys missing - skipping n8n-mcp
)

REM Always add dashboard if we have any MCP services
if not "%available_profiles%"=="" (
    set available_profiles=%available_profiles%dashboard
    echo ✓ Dashboard will be started
)

REM Start services with available profiles
if not "%available_profiles%"=="" (
    echo Starting MCP services with profiles: %available_profiles%

    docker-compose -f docker-compose-mcp.yml --env-file mcp.env --profile "%available_profiles%" up -d

    echo ✓ MCP services started successfully!
) else (
    echo ✗ No MCP services have the required API keys. Please set the environment variables and try again.
    echo Required environment variables:
    echo   TikTok: TIKTOK_API_KEY, TIKTOK_API_SECRET, TIKTOK_ACCESS_TOKEN
    echo   YouTube: YOUTUBE_API_KEY, YOUTUBE_CLIENT_ID, YOUTUBE_CLIENT_SECRET, YOUTUBE_REFRESH_TOKEN
    echo   Twitter: TWITTER_API_KEY, TWITTER_API_SECRET, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET, TWITTER_BEARER_TOKEN
    echo   n8n MCP: N8N_API_URL, N8N_API_KEY
)
