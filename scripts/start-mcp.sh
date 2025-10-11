#!/bin/bash
# Cross-platform MCP Services Startup Script
# This script checks for required API keys and starts only the services that have them

echo "Loading environment variables..."

# Load environment variables from mcp.env file
if [ -f "mcp.env" ]; then
    export $(grep -v '^#' mcp.env | xargs)
    echo "✓ Loaded environment variables from mcp.env"
else
    echo "✗ mcp.env file not found"
    exit 1
fi

echo "Checking for MCP service API keys..."

# Check which services have their required API keys
available_profiles=()

# Check TikTok API keys
if [ -n "$TIKTOK_API_KEY" ] && [ -n "$TIKTOK_API_SECRET" ] && [ -n "$TIKTOK_ACCESS_TOKEN" ]; then
    echo "✓ TikTok API keys found"
    available_profiles+=("tiktok")
else
    echo "✗ TikTok API keys missing - skipping tiktok-mcp"
fi

# Check YouTube API keys
if [ -n "$YOUTUBE_API_KEY" ] && [ -n "$YOUTUBE_CLIENT_ID" ] && [ -n "$YOUTUBE_CLIENT_SECRET" ] && [ -n "$YOUTUBE_REFRESH_TOKEN" ]; then
    echo "✓ YouTube API keys found"
    available_profiles+=("youtube")
else
    echo "✗ YouTube API keys missing - skipping youtube-mcp"
fi

# Check Twitter API keys
if [ -n "$TWITTER_API_KEY" ] && [ -n "$TWITTER_API_SECRET" ] && [ -n "$TWITTER_ACCESS_TOKEN" ] && [ -n "$TWITTER_ACCESS_TOKEN_SECRET" ] && [ -n "$TWITTER_BEARER_TOKEN" ]; then
    echo "✓ Twitter API keys found"
    available_profiles+=("twitter")
else
    echo "✗ Twitter API keys missing - skipping twitter-mcp"
fi

# Check n8n MCP API keys
if [ -n "$N8N_API_URL" ] && [ -n "$N8N_API_KEY" ]; then
    echo "✓ n8n MCP API keys found"
    available_profiles+=("n8n-mcp")
else
    echo "✗ n8n MCP API keys missing - skipping n8n-mcp"
fi

# Always add dashboard if we have any MCP services
if [ ${#available_profiles[@]} -gt 0 ]; then
    available_profiles+=("dashboard")
    echo "✓ Dashboard will be started"
fi

# Start services with available profiles
if [ ${#available_profiles[@]} -gt 0 ]; then
    profiles_arg=$(IFS=,; echo "${available_profiles[*]}")
    echo "Starting MCP services with profiles: $profiles_arg"

    docker-compose -f docker-compose-mcp.yml --env-file mcp.env --profile "$profiles_arg" up -d

    echo "✓ MCP services started successfully!"
else
    echo "✗ No MCP services have the required API keys. Please set the environment variables and try again."
    echo "Required environment variables:"
    echo "  TikTok: TIKTOK_API_KEY, TIKTOK_API_SECRET, TIKTOK_ACCESS_TOKEN"
    echo "  YouTube: YOUTUBE_API_KEY, YOUTUBE_CLIENT_ID, YOUTUBE_CLIENT_SECRET, YOUTUBE_REFRESH_TOKEN"
    echo "  Twitter: TWITTER_API_KEY, TWITTER_API_SECRET, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET, TWITTER_BEARER_TOKEN"
    echo "  n8n MCP: N8N_API_URL, N8N_API_KEY"
fi
