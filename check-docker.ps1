# Check for internet connection
function Test-InternetConnection {
    try {
        $request = Invoke-WebRequest -Uri "https://www.google.com" -UseBasicParsing -TimeoutSec 5
        return $true
    } catch {
        return $false
    }
}

# Check if Docker Desktop is running
function Test-DockerDesktop {
    $dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
    return $null -ne $dockerProcess
}

# Start Docker Desktop if not running
function Start-DockerDesktop {
    Start-Process "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
    Start-Sleep -Seconds 30 # Wait for Docker to start
}

# Check if containers are running
function Test-Containers {
    $result = docker ps --filter "status=running" --format "{{.Names}}"
    return $result -match "ollama|open-webui|n8n"
}

# Start containers if not running
function Start-Containers {
    cd "D:\\dev\\homelab"
    docker-compose up -d
}

# Main logic
if (Test-InternetConnection) {
    if (-not (Test-DockerDesktop)) {
        Write-Output "Starting Docker Desktop..."
        Start-DockerDesktop
    }
    # Wait for Docker to be ready
    $dockerReady = $false
    for ($i=0; $i -lt 10; $i++) {
        try {
            docker info | Out-Null
            $dockerReady = $true
            break
        } catch {
            Start-Sleep -Seconds 5
        }
    }
    if ($dockerReady) {
        if (-not (Test-Containers)) {
            Write-Output "Starting containers..."
            Start-Containers
        } else {
            Write-Output "Containers are already running."
        }
    } else {
        Write-Output "Docker is not ready after waiting."
    }
} else {
    Write-Output "No internet connection. Skipping checks."
}
