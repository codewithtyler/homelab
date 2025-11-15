# Script to test connectivity from Windows to verify services are accessible
# This helps verify that Traefik on Linux can reach Windows services
# Usage: .\scripts\test-traefik-connectivity.ps1

param(
    [string]$LinuxIP = ""
)

$ErrorActionPreference = "Continue"

Write-Host "Testing Windows service connectivity" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Test local services
$services = @(
    @{Name="Open WebUI"; Port=5000; URL="http://localhost:5000"},
    @{Name="Stable Diffusion"; Port=7860; URL="http://localhost:7860"},
    @{Name="Remotion"; Port=4000; URL="http://localhost:4000"},
    @{Name="Ollama"; Port=11434; URL="http://localhost:11434"}
)

Write-Host "Testing local service ports:" -ForegroundColor Yellow
foreach ($service in $services) {
    $result = Test-NetConnection -ComputerName localhost -Port $service.Port -WarningAction SilentlyContinue -InformationLevel Quiet
    if ($result) {
        Write-Host "  ✓ $($service.Name) (port $($service.Port)) - Accessible" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($service.Name) (port $($service.Port)) - Not accessible" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "To test from Linux host, run on Linux:" -ForegroundColor Yellow
Write-Host "  ./scripts/test-traefik-connectivity.sh <windows-ip>" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or manually test each port:" -ForegroundColor Yellow
Write-Host "  telnet <windows-ip> 5000" -ForegroundColor Cyan
Write-Host "  telnet <windows-ip> 7860" -ForegroundColor Cyan
Write-Host "  telnet <windows-ip> 4000" -ForegroundColor Cyan
Write-Host "  telnet <windows-ip> 11434" -ForegroundColor Cyan

