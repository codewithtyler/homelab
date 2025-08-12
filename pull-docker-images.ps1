# List of Docker images that use 'latest' tag (edit this list as needed)
$images = @(
    "ollama/ollama:latest",
    "n8nio/n8n:latest",
    "coollabsio/coolify:latest",
    "cloudflare/cloudflared:latest",
    "ghcr.io/czlonkowski/n8n-mcp:latest"
)

# Helper: Check if Docker is running
Write-Host "Checking if Docker is running..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "Docker is running." -ForegroundColor Green
} catch {
    Write-Error "Docker does not appear to be running. Please start Docker Desktop and try again."
    exit 1
}

# Stop all containers defined in both docker-compose files
Write-Host "Stopping all containers..." -ForegroundColor Green
docker-compose down
docker-compose -f docker-compose-mcp.yml down
Write-Host "All containers stopped." -ForegroundColor Green

# Pull latest versions of images
Write-Host "Pulling latest versions of Docker images..." -ForegroundColor Green
foreach ($image in $images) {
    $imageParts = $image.Split(":")
    $imageName = $imageParts[0]
    $imageTag = if ($imageParts.Count -gt 1) { $imageParts[1] } else { "latest" }
    $fullImage = "$imageName`:$imageTag"

    Write-Host "Pulling $fullImage..." -ForegroundColor Yellow
    try {
        docker pull $fullImage
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully pulled $fullImage" -ForegroundColor Green
        } else {
            Write-Host "Failed to pull $fullImage" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error pulling $fullImage : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Start all containers defined in both docker-compose files
Write-Host "Starting all containers..." -ForegroundColor Green
docker-compose up -d
Write-Host "Main containers started." -ForegroundColor Green

# Start MCP services with conditional startup
Write-Host "Starting MCP services (only those with API keys)..." -ForegroundColor Green
& .\start-mcp.ps1

# Clean up outdated images (images that are no longer referenced by any container)
Write-Host "Cleaning up outdated images..." -ForegroundColor Green
try {
    # Remove dangling images first (images with <none> tag)
    $danglingImages = docker images -f "dangling=true" -q
    if ($danglingImages) {
        Write-Host "Removing dangling images..." -ForegroundColor Yellow
        foreach ($danglingImage in $danglingImages) {
            try {
                docker rmi $danglingImage 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Removed dangling image: $danglingImage" -ForegroundColor Green
                }
            } catch {
                Write-Host "Could not remove dangling image $danglingImage (may be in use)" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "No dangling images found." -ForegroundColor Green
    }

    # Remove unused images (not used by any container) - this is safer than prune
    Write-Host "Checking for unused images..." -ForegroundColor Yellow
    $allImages = docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -ne "<none>:<none>" }
    $unusedImages = @()

    foreach ($image in $allImages) {
        # Skip images that are in our target list (we want to keep these)
        if ($images -contains $image) {
            continue
        }

        # Check if any containers are using this image (including stopped containers)
        $containers = docker ps -a --filter "ancestor=$image" --format "{{.Names}}"
        if (-not $containers) {
            # Double check - also look for containers that might be using this image by ID
            $imageId = docker images --format "{{.ID}}" --filter "reference=$image"
            $containersById = docker ps -a --filter "ancestor=$imageId" --format "{{.Names}}"
            if (-not $containersById) {
                $unusedImages += $image
            }
        }
    }

    if ($unusedImages) {
        Write-Host "Removing unused images..." -ForegroundColor Yellow
        foreach ($unusedImage in $unusedImages) {
            try {
                docker rmi $unusedImage 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Removed unused image: $unusedImage" -ForegroundColor Green
                } else {
                    Write-Host "Could not remove image $unusedImage (may still be in use)" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "Could not remove unused image $unusedImage" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "No unused images found." -ForegroundColor Green
    }

    Write-Host "Cleanup completed." -ForegroundColor Green
} catch {
    Write-Host "Error during cleanup: $($_.Exception.Message)" -ForegroundColor Red
}

# Optional: Show summary of pulled images
Write-Host "`nSummary of Docker images:" -ForegroundColor Green
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" | Out-String

Write-Host "Docker image update complete!" -ForegroundColor Green
