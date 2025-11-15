# Script to update Traefik routers.yml with Windows host IP or hostname from .env file
# This replaces WINDOWS_HOST_PLACEHOLDER in traefik/dynamic/routers.yml
# Supports both IP addresses and hostnames (e.g., DESKTOP-29IGLER)

param(
    [string]$WindowsHost = ""
)

$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$RoutersFile = Join-Path $RepoRoot "traefik\dynamic\routers.yml"
$EnvFile = Join-Path $RepoRoot ".env"

# Read Windows host from .env if not provided
if ([string]::IsNullOrEmpty($WindowsHost)) {
    if (Test-Path $EnvFile) {
        $envContent = Get-Content $EnvFile
        foreach ($line in $envContent) {
            if ($line -match "^WINDOWS_HOST_IP=(.+)$") {
                $WindowsHost = $matches[1].Trim()
                break
            }
        }
    }
    
    if ([string]::IsNullOrEmpty($WindowsHost) -or $WindowsHost -eq "192.168.1.XXX") {
        Write-Host "ERROR: Windows host not found in .env file or still set to placeholder." -ForegroundColor Red
        Write-Host "Please set WINDOWS_HOST_IP in .env file first (can be IP or hostname like DESKTOP-29IGLER)," -ForegroundColor Yellow
        Write-Host "or provide it as a parameter:" -ForegroundColor Yellow
        Write-Host "  .\scripts\setup-traefik-windows-ip.ps1 -WindowsHost 192.168.1.100" -ForegroundColor Yellow
        Write-Host "  .\scripts\setup-traefik-windows-ip.ps1 -WindowsHost DESKTOP-29IGLER" -ForegroundColor Yellow
        exit 1
    }
}

# Check if routers.yml exists
if (-not (Test-Path $RoutersFile)) {
    Write-Host "ERROR: routers.yml not found at: $RoutersFile" -ForegroundColor Red
    exit 1
}

# Read and replace
$content = Get-Content $RoutersFile -Raw
$updatedContent = $content -replace 'WINDOWS_HOST_PLACEHOLDER', $WindowsHost

# Write back
Set-Content -Path $RoutersFile -Value $updatedContent -NoNewline

Write-Host "Successfully updated Traefik routers.yml with Windows host: $WindowsHost" -ForegroundColor Green
Write-Host "Updated file: $RoutersFile" -ForegroundColor Green
Write-Host ""
Write-Host "Note: If using hostname, ensure your Linux host can resolve it." -ForegroundColor Yellow
Write-Host "If hostname doesn't work, use the IP address instead." -ForegroundColor Yellow

