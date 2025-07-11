# Check if 'intranet' network exists; create it if it doesn't
if (-not (docker network ls --format "{{.Name}}" | Select-String -Pattern "^intranet$")) {
  docker network create intranet
  Write-Output "Created 'intranet' network."
}
else {
  Write-Output "'intranet' network already exists."
}

# Run Docker Compose
docker-compose up -d
