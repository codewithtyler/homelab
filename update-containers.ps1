# List of containers to update (edit this list as needed)
$containersToUpdate = @(
    "open-webui"
    # Add other containers here as needed:
    # "ollama"
    # "n8n"
    # "coolify"
    # "cloudflared"
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

# Check if containers are specified
if ($containersToUpdate.Count -eq 0) {
    Write-Host "No containers specified for update. Please edit the `$containersToUpdate list in this script." -ForegroundColor Yellow
    exit 1
}

Write-Host "Containers to update: $($containersToUpdate -join ', ')" -ForegroundColor Cyan

# Process each container
foreach ($container in $containersToUpdate) {
    Write-Host "`nProcessing container: $container" -ForegroundColor Green

    # Check if container exists and is running
    $containerStatus = docker ps --filter "name=$container" --format "{{.Names}}"
    if (-not $containerStatus) {
        Write-Host "Container '$container' not found or not running. Skipping..." -ForegroundColor Yellow
        continue
    }

    Write-Host "Stopping container: $container" -ForegroundColor Yellow
    try {
        docker-compose stop $container
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully stopped $container" -ForegroundColor Green
        } else {
            Write-Host "Failed to stop $container" -ForegroundColor Red
            continue
        }
    } catch {
        Write-Host "Error stopping $container : $($_.Exception.Message)" -ForegroundColor Red
        continue
    }

    Write-Host "Pulling latest image for: $container" -ForegroundColor Yellow
    try {
        docker-compose pull $container
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully pulled latest image for $container" -ForegroundColor Green
        } else {
            Write-Host "Failed to pull latest image for $container" -ForegroundColor Red
            # Try to start the container anyway with existing image
            Write-Host "Attempting to start $container with existing image..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error pulling latest image for $container : $($_.Exception.Message)" -ForegroundColor Red
        # Try to start the container anyway with existing image
        Write-Host "Attempting to start $container with existing image..." -ForegroundColor Yellow
    }

    Write-Host "Starting container: $container" -ForegroundColor Yellow
    try {
        docker-compose up -d $container
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully started $container" -ForegroundColor Green
        } else {
            Write-Host "Failed to start $container" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error starting $container : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Optional: Clean up old images for the updated containers
Write-Host "`nCleaning up old images for updated containers..." -ForegroundColor Green
try {
    foreach ($container in $containersToUpdate) {
        # Get the image name for this container
        $imageName = docker-compose config --services | ForEach-Object {
            if ($_ -eq $container) {
                # Get the image from docker-compose config
                $config = docker-compose config --format json | ConvertFrom-Json
                $serviceConfig = $config.services.$container
                if ($serviceConfig.image) {
                    return $serviceConfig.image
                }
            }
        }

        if ($imageName) {
            # Remove old versions of this image (keep only the latest)
            $oldImages = docker images $imageName --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -ne $imageName }
            if ($oldImages) {
                Write-Host "Removing old versions of $imageName..." -ForegroundColor Yellow
                foreach ($oldImage in $oldImages) {
                    try {
                        docker rmi $oldImage 2>$null
                        if ($LASTEXITCODE -eq 0) {
                            Write-Host "Removed old image: $oldImage" -ForegroundColor Green
                        }
                    } catch {
                        Write-Host "Could not remove old image $oldImage (may still be in use)" -ForegroundColor Yellow
                    }
                }
            }
        }
    }
} catch {
    Write-Host "Error during cleanup: $($_.Exception.Message)" -ForegroundColor Red
}

# Show final status
Write-Host "`nFinal container status:" -ForegroundColor Green
docker-compose ps

Write-Host "`nContainer update process complete!" -ForegroundColor Green
