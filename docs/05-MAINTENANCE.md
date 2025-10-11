# Maintenance Procedures

## Container Updates

### Individual Container Updates
Use `update-containers.ps1` for targeted updates:

```bash
# Edit the script to specify which containers to update
$containersToUpdate = @(
    "open-webui"
    # Add other containers as needed
)

# Run the update script
.\update-containers.ps1
```

### Bulk Image Updates
Use `pull-docker-images.ps1` for comprehensive updates:

```bash
# Update all images and restart services
.\pull-docker-images.ps1
```

### Update Process
1. **Stop containers** gracefully
2. **Pull latest images** from registry
3. **Start containers** with new images
4. **Clean up old images** to save space
5. **Verify services** are running correctly

## Ollama Model Management

### Model Synchronization
Use `pull-ollama-models.ps1` to manage models:

```bash
# Sync models with desired list
.\pull-ollama-models.ps1
```

### Model Operations
```bash
# List installed models
docker exec ollama ollama list

# Pull specific model
docker exec ollama ollama pull llama3.1:8b

# Remove model
docker exec ollama ollama rm old-model:tag

# Test model
docker exec ollama ollama run llama3.1:8b "Hello, world!"
```

### Model Configuration
Edit `pull-ollama-models.ps1` to modify desired models:
```powershell
$models = @(
    "deepseek-r1:14b",
    "llama3.2-vision:11b",
    "llama3.1:8b",
    "nomic-embed-text:latest"
)
```

## Backup Strategies

### Database Backups
```bash
# PostgreSQL backup
docker exec coolify-db pg_dump -U coolify coolify > backup-$(date +%Y%m%d).sql

# Redis backup
docker exec coolify-redis redis-cli BGSAVE
```

### Application Data Backups
```bash
# Full data backup
tar -czf homelab-backup-$(date +%Y%m%d).tar.gz ./data/

# Individual service backups
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz ./data/n8n/
tar -czf ollama-backup-$(date +%Y%m%d).tar.gz ./data/ollama/
```

### Configuration Backups
```bash
# Backup configuration files
cp docker-compose.yml docker-compose.yml.backup
cp docker-compose-mcp.yml docker-compose-mcp.yml.backup
cp .env .env.backup
cp mcp.env mcp.env.backup
```

## Database Maintenance

### PostgreSQL Maintenance
```bash
# Connect to database
docker exec -it coolify-db psql -U coolify -d coolify

# Check database size
docker exec coolify-db psql -U coolify -d coolify -c "SELECT pg_size_pretty(pg_database_size('coolify'));"

# Vacuum database
docker exec coolify-db psql -U coolify -d coolify -c "VACUUM ANALYZE;"

# Check for long-running queries
docker exec coolify-db psql -U coolify -d coolify -c "SELECT * FROM pg_stat_activity WHERE state = 'active';"
```

### Redis Maintenance
```bash
# Connect to Redis
docker exec -it coolify-redis redis-cli

# Check memory usage
docker exec coolify-redis redis-cli INFO memory

# Flush database (use with caution)
docker exec coolify-redis redis-cli FLUSHDB

# Check key count
docker exec coolify-redis redis-cli DBSIZE
```

## Cleanup Procedures

### Docker Cleanup
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Complete cleanup
docker system prune -a
```

### Log Cleanup
```bash
# Check log sizes
docker-compose logs --tail 0

# Rotate logs (if using logrotate)
sudo logrotate -f /etc/logrotate.d/docker

# Clean application logs
find ./data -name "*.log" -mtime +30 -delete
```

### Disk Space Management
```bash
# Check disk usage
docker system df

# Check data directory sizes
du -sh ./data/*

# Clean up old backups
find . -name "*.tar.gz" -mtime +30 -delete
```

## Automated Maintenance

### Scheduled Updates
Create Windows Task Scheduler task:
- **Name**: "Homelab Updates"
- **Trigger**: Daily at 3:00 AM
- **Action**: Run PowerShell script
- **Script**: `.\pull-docker-images.ps1`

### Health Monitoring
```bash
# Create health check script
# check-health.ps1
$services = @("ollama", "open-webui", "n8n", "coolify")
foreach ($service in $services) {
    $status = docker-compose ps $service --format "{{.Status}}"
    if ($status -notmatch "Up") {
        Write-Host "Service $service is not running"
        # Send alert or restart service
    }
}
```

### Automated Backups
```bash
# Create backup script
# backup-homelab.ps1
$date = Get-Date -Format "yyyyMMdd"
$backupFile = "homelab-backup-$date.tar.gz"

# Create backup
tar -czf $backupFile ./data/

# Upload to cloud storage (optional)
# aws s3 cp $backupFile s3://your-bucket/backups/
```

## Performance Optimization

### Resource Monitoring
```bash
# Monitor container resources
docker stats --no-stream

# Check GPU usage
nvidia-smi

# Monitor disk I/O
iostat -x 1
```

### Container Optimization
```bash
# Limit container resources
docker-compose up -d --scale ollama=1 --scale open-webui=1

# Optimize database connections
# Edit docker-compose.yml to add resource limits
```

### Network Optimization
```bash
# Check network performance
docker network inspect intranet

# Monitor network usage
docker exec ollama netstat -i
```

## Security Maintenance

### Secret Rotation
```bash
# Rotate API keys
# Update .env and mcp.env files
# Restart affected services

# Rotate database passwords
# Update COOLIFY_DB_PASSWORD in .env
# Restart coolify and coolify-db
```

### Access Review
```bash
# Review n8n users
# Check n8n authentication logs

# Review Coolify access
# Check Coolify user management

# Review API key usage
# Monitor MCP service logs
```

### Vulnerability Scanning
```bash
# Scan container images
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image ollama/ollama:latest

# Update base images
docker-compose pull
```

## Disaster Recovery

### Recovery Procedures
```bash
# Restore from backup
tar -xzf homelab-backup-20240101.tar.gz

# Restore database
docker exec -i coolify-db psql -U coolify -d coolify < backup.sql

# Restart services
docker-compose up -d
```

### Service Recovery
```bash
# Recreate networks
docker network rm intranet mcp-network
docker network create intranet
docker network create mcp-network

# Recreate volumes
docker volume rm homelab_ollama homelab_open-webui
# Restore from backup
```

## Maintenance Schedule

### Daily
- [ ] Check service health
- [ ] Review error logs
- [ ] Monitor resource usage

### Weekly
- [ ] Update containers
- [ ] Clean up old images
- [ ] Backup critical data
- [ ] Review security logs

### Monthly
- [ ] Full system backup
- [ ] Security review
- [ ] Performance optimization
- [ ] Update documentation

### Quarterly
- [ ] Disaster recovery test
- [ ] Security audit
- [ ] Capacity planning
- [ ] Technology updates
