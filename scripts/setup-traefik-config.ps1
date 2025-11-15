# Script to generate Traefik routers.yml from template using .env variables
# This replaces all placeholders in traefik/dynamic/routers.yml.template
# and generates traefik/dynamic/routers.yml

$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$TemplateFile = Join-Path $RepoRoot "traefik\dynamic\routers.yml.template"
$RoutersFile = Join-Path $RepoRoot "traefik\dynamic\routers.yml"
$EnvFile = Join-Path $RepoRoot ".env"

# Read environment variables from .env
$envVars = @{}
if (Test-Path $EnvFile) {
    $envContent = Get-Content $EnvFile
    foreach ($line in $envContent) {
        if ($line -match "^([^#=]+)=(.+)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            if (-not [string]::IsNullOrEmpty($key) -and -not [string]::IsNullOrEmpty($value)) {
                $envVars[$key] = $value
            }
        }
    }
} else {
    Write-Host "ERROR: .env file not found at: $EnvFile" -ForegroundColor Red
    exit 1
}

# Required variables
$requiredVars = @(
    "WINDOWS_HOST_IP",
    "DOMAIN_PRIMARY",
    "OPEN_WEBUI_SUBDOMAIN",
    "STABLE_DIFFUSION_SUBDOMAIN",
    "REMOTION_SUBDOMAIN",
    "OLLAMA_SUBDOMAIN"
)

# Check for required variables
$missingVars = @()
foreach ($var in $requiredVars) {
    if (-not $envVars.ContainsKey($var) -or [string]::IsNullOrEmpty($envVars[$var])) {
        $missingVars += $var
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host "ERROR: Missing required environment variables:" -ForegroundColor Red
    foreach ($var in $missingVars) {
        Write-Host "  - $var" -ForegroundColor Yellow
    }
    Write-Host "Please set these in your .env file." -ForegroundColor Yellow
    exit 1
}

# Check if template exists
if (-not (Test-Path $TemplateFile)) {
    Write-Host "ERROR: Template file not found at: $TemplateFile" -ForegroundColor Red
    exit 1
}

# Read template
$content = Get-Content $TemplateFile -Raw

# Replace placeholders
$content = $content -replace 'WINDOWS_HOST_IP_PLACEHOLDER', $envVars["WINDOWS_HOST_IP"]
$content = $content -replace 'DOMAIN_PRIMARY_PLACEHOLDER', $envVars["DOMAIN_PRIMARY"]
$content = $content -replace 'OPEN_WEBUI_SUBDOMAIN_PLACEHOLDER', $envVars["OPEN_WEBUI_SUBDOMAIN"]
$content = $content -replace 'STABLE_DIFFUSION_SUBDOMAIN_PLACEHOLDER', $envVars["STABLE_DIFFUSION_SUBDOMAIN"]
$content = $content -replace 'REMOTION_SUBDOMAIN_PLACEHOLDER', $envVars["REMOTION_SUBDOMAIN"]
$content = $content -replace 'OLLAMA_SUBDOMAIN_PLACEHOLDER', $envVars["OLLAMA_SUBDOMAIN"]

# Write generated file
Set-Content -Path $RoutersFile -Value $content -NoNewline

Write-Host "Successfully generated Traefik routers.yml from template" -ForegroundColor Green
Write-Host "Updated file: $RoutersFile" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  Windows Host: $($envVars['WINDOWS_HOST_IP'])" -ForegroundColor White
Write-Host "  Domain: $($envVars['DOMAIN_PRIMARY'])" -ForegroundColor White
Write-Host "  Open WebUI: $($envVars['OPEN_WEBUI_SUBDOMAIN']).$($envVars['DOMAIN_PRIMARY'])" -ForegroundColor White
Write-Host "  Stable Diffusion: $($envVars['STABLE_DIFFUSION_SUBDOMAIN']).$($envVars['DOMAIN_PRIMARY'])" -ForegroundColor White
Write-Host "  Remotion: $($envVars['REMOTION_SUBDOMAIN']).$($envVars['DOMAIN_PRIMARY'])" -ForegroundColor White
Write-Host "  Ollama: $($envVars['OLLAMA_SUBDOMAIN']).$($envVars['DOMAIN_PRIMARY'])" -ForegroundColor White

