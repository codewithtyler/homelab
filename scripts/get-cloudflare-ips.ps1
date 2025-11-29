# Script to fetch and display Cloudflare IP ranges for firewall configuration
# These are the IP ranges that should be allowed to access ports 80/443

Write-Host "Cloudflare IPv4 Ranges (for port forwarding/firewall rules):" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green

$ipv4Ranges = Invoke-RestMethod -Uri "https://www.cloudflare.com/ips-v4"
$ipv4Ranges -split "`n" | ForEach-Object {
    if ($_.Trim()) {
        Write-Host $_.Trim()
    }
}

Write-Host "`nTotal IPv4 ranges: $($ipv4Ranges -split "`n" | Where-Object { $_.Trim() } | Measure-Object | Select-Object -ExpandProperty Count)" -ForegroundColor Yellow

Write-Host "`n" + ("=" * 60) -ForegroundColor Green
Write-Host "`nNote: Your router may need these entered one at a time," -ForegroundColor Yellow
Write-Host "or you may need to use a firewall rule instead of port forwarding." -ForegroundColor Yellow

