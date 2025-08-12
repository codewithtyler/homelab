# MCP Services Startup Script
# This script checks for required API keys and starts only the services that have them

Write-Host "Loading environment variables..." -ForegroundColor Green

# Load N8N_API_KEY from .env file
if (Test-Path ".env") {
    $envContent = Get-Content ".env"
    foreach ($line in $envContent) {
        if ($line -match "^N8N_API_KEY=(.+)$") {
            $apiKey = $matches[1].Trim()
            if ($apiKey -and $apiKey -ne "your_n8n_api_key_here") {
                $env:N8N_API_KEY = $apiKey
                Write-Host "  ✓ Loaded N8N_API_KEY from .env" -ForegroundColor Gray
            }
        }
    }
}

# Load other variables from mcp.env file
if (Test-Path "mcp.env") {
    $mcpContent = Get-Content "mcp.env"
    foreach ($line in $mcpContent) {
        if ($line -match "^([^#][^=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()

            # Skip placeholder values
            if ($value -notmatch "^your_.*_here$") {
                Set-Item -Path "env:$name" -Value $value
                Write-Host "  ✓ Loaded $name" -ForegroundColor Gray
            }
        }
    }
} else {
    Write-Host "✗ mcp.env file not found" -ForegroundColor Red
    exit 1
}

Write-Host "Checking for MCP service API keys..." -ForegroundColor Green

# Check which services have their required API keys
$availableProfiles = @()

# Check TikTok API keys
if ($env:TIKTOK_API_KEY -and $env:TIKTOK_API_SECRET -and $env:TIKTOK_ACCESS_TOKEN) {
    Write-Host "✓ TikTok API keys found" -ForegroundColor Green
    $availableProfiles += "tiktok"
} else {
    Write-Host "✗ TikTok API keys missing - skipping tiktok-mcp" -ForegroundColor Yellow
}

# Check YouTube API keys
if ($env:YOUTUBE_API_KEY -and $env:YOUTUBE_CLIENT_ID -and $env:YOUTUBE_CLIENT_SECRET -and $env:YOUTUBE_REFRESH_TOKEN) {
    Write-Host "✓ YouTube API keys found" -ForegroundColor Green
    $availableProfiles += "youtube"
} else {
    Write-Host "✗ YouTube API keys missing - skipping youtube-mcp" -ForegroundColor Yellow
}

# Check Twitter API keys
if ($env:TWITTER_API_KEY -and $env:TWITTER_API_SECRET -and $env:TWITTER_ACCESS_TOKEN -and $env:TWITTER_ACCESS_TOKEN_SECRET -and $env:TWITTER_BEARER_TOKEN) {
    Write-Host "✓ Twitter API keys found" -ForegroundColor Green
    $availableProfiles += "twitter"
} else {
    Write-Host "✗ Twitter API keys missing - skipping twitter-mcp" -ForegroundColor Yellow
}

# Check n8n MCP API keys
if ($env:N8N_API_URL -and $env:N8N_API_KEY) {
    Write-Host "✓ n8n MCP API keys found" -ForegroundColor Green
    $availableProfiles += "n8n-mcp"
} else {
    Write-Host "✗ n8n MCP API keys missing - skipping n8n-mcp" -ForegroundColor Yellow
}

# Always add dashboard if we have any MCP services
if ($availableProfiles.Count -gt 0) {
    $availableProfiles += "dashboard"
    Write-Host "✓ Dashboard will be started" -ForegroundColor Green
}

# Start services with available profiles
if ($availableProfiles.Count -gt 0) {
    Write-Host "`nStarting MCP services with profiles: $($availableProfiles -join ', ')" -ForegroundColor Green

    $profilesArg = $availableProfiles -join ","
    docker-compose -f docker-compose-mcp.yml --env-file mcp.env --profile $profilesArg up -d

    Write-Host "MCP services started successfully!" -ForegroundColor Green
} else {
    Write-Host "`nNo MCP services have the required API keys. Please set the environment variables and try again." -ForegroundColor Red
    Write-Host "`nRequired environment variables:" -ForegroundColor Yellow
    Write-Host "  TikTok: TIKTOK_API_KEY, TIKTOK_API_SECRET, TIKTOK_ACCESS_TOKEN" -ForegroundColor Yellow
    Write-Host "  YouTube: YOUTUBE_API_KEY, YOUTUBE_CLIENT_ID, YOUTUBE_CLIENT_SECRET, YOUTUBE_REFRESH_TOKEN" -ForegroundColor Yellow
    Write-Host "  Twitter: TWITTER_API_KEY, TWITTER_API_SECRET, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET, TWITTER_BEARER_TOKEN" -ForegroundColor Yellow
    Write-Host "  n8n MCP: N8N_API_URL, N8N_API_KEY" -ForegroundColor Yellow
}
