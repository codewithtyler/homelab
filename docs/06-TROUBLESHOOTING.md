# Troubleshooting Guide

## Common Issues

### Docker Not Running

**Symptoms**: Containers won't start, "Docker daemon not running" errors

**Solutions**:
```bash
# Check Docker Desktop status
Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

# Start Docker Desktop manually
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

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
```

**Prevention**: Configure Docker Desktop to start with Windows

---

### Port Conflicts

**Symptoms**: "Port already in use" errors, services can't bind to ports

**Solutions**:
```bash
# Check what's using the port
netstat -an | findstr :5000
netstat -an | findstr :5678
netstat -an | findstr :6000

# Kill process using port
taskkill /PID <process_id> /F

# Check Docker containers using ports
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

**Prevention**: Ensure ports are available before starting services

---

### Container Won't Start

**Symptoms**: Container exits immediately, "Exited (1)" status

**Solutions**:
```bash
# Check container logs
docker-compose logs service-name

# Check container status
docker-compose ps

# Restart specific service
docker-compose restart service-name

# Recreate container
docker-compose up -d --force-recreate service-name
```

**Common Causes**:
- Missing environment variables
- Port conflicts
- Volume mount issues
- Resource constraints

---

### GPU Not Detected

**Symptoms**: Ollama/Open-WebUI can't access GPU, slow inference

**Solutions**:
```bash
# Check NVIDIA drivers
nvidia-smi

# Check Docker GPU support
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# Check container GPU access
docker exec ollama nvidia-smi
docker exec open-webui nvidia-smi

# Restart with GPU support
docker-compose down
docker-compose up -d
```

**Prevention**: Ensure NVIDIA drivers and Docker GPU support are properly configured

---

### Cloudflare Tunnel Issues

**Symptoms**: Remote access not working, tunnel connection failed

**Solutions**:
```bash
# Check tunnel status
docker logs cloudflared

# Verify tunnel token
echo $CLOUDFLARED_TUNNEL_TOKEN

# Test tunnel connection
docker exec cloudflared cloudflared tunnel info

# Restart tunnel
docker-compose restart cloudflared
```

**Common Causes**:
- Invalid tunnel token
- Network connectivity issues
- Cloudflare configuration problems

---

### n8n Authentication Problems

**Symptoms**: Can't login to n8n, authentication failed

**Solutions**:
```bash
# Check n8n logs
docker-compose logs n8n

# Verify environment variables
echo $N8N_USERNAME
echo $N8N_PASSWORD

# Reset n8n data (will lose workflows)
docker-compose down
rm -rf ./data/n8n
docker-compose up -d n8n
```

**Prevention**: Ensure credentials are set correctly in `.env` file

---

### API Rate Limiting (MCP Services)

**Symptoms**: MCP services failing, API quota exceeded

**Solutions**:
```bash
# Check MCP service logs
docker-compose -f docker-compose-mcp.yml logs tiktok-mcp
docker-compose -f docker-compose-mcp.yml logs youtube-mcp

# Verify API keys
docker-compose -f docker-compose-mcp.yml config

# Restart MCP services
docker-compose -f docker-compose-mcp.yml restart
```

**Prevention**: Monitor API usage, implement rate limiting

---

### Network Connectivity Issues

**Symptoms**: Services can't communicate, DNS resolution failed

**Solutions**:
```bash
# Check Docker networks
docker network ls
docker network inspect intranet

# Test internal connectivity
docker exec ollama ping open-webui
docker exec n8n ping coolify

# Recreate networks
docker network rm intranet
docker network create intranet
docker-compose up -d
```

**Prevention**: Ensure Docker networks are properly configured

---

### Disk Space Management

**Symptoms**: "No space left on device" errors, containers failing

**Solutions**:
```bash
# Check disk usage
docker system df
df -h

# Clean up Docker resources
docker system prune -a

# Check data directory sizes
du -sh ./data/*

# Clean up old logs
find ./data -name "*.log" -mtime +30 -delete
```

**Prevention**: Regular cleanup, monitor disk usage

---

### Performance Issues

**Symptoms**: Slow response times, high CPU/memory usage

**Solutions**:
```bash
# Monitor resource usage
docker stats

# Check specific service resources
docker stats ollama open-webui n8n coolify

# Check GPU usage
nvidia-smi

# Restart services
docker-compose restart
```

**Optimization**:
- Limit container resources
- Optimize database queries
- Use SSD storage
- Ensure adequate RAM

## Diagnostic Commands

### System Health Check
```bash
# Check all services
docker-compose ps

# Check resource usage
docker stats --no-stream

# Check disk usage
docker system df

# Check network status
docker network ls
```

### Service-Specific Diagnostics
```bash
# Ollama diagnostics
docker exec ollama ollama list
docker exec ollama ollama ps

# n8n diagnostics
curl -u username:password http://localhost:5678/api/v1/workflows

# Coolify diagnostics
curl http://localhost:6000/api/health

# Database diagnostics
docker exec coolify-db psql -U coolify -d coolify -c "SELECT version();"
```

### Log Analysis
```bash
# Search for errors
docker-compose logs | grep -i error

# Search for specific patterns
docker-compose logs | grep -i "connection refused"
docker-compose logs | grep -i "timeout"

# Monitor logs in real-time
docker-compose logs -f
```

## Recovery Procedures

### Complete System Recovery
```bash
# Stop all services
docker-compose down
docker-compose -f docker-compose-mcp.yml down

# Clean up Docker resources
docker system prune -a

# Restore from backup
tar -xzf homelab-backup-20240101.tar.gz

# Restart services
docker-compose up -d
docker-compose -f docker-compose-mcp.yml up -d
```

### Service-Specific Recovery
```bash
# Recreate specific service
docker-compose up -d --force-recreate ollama

# Restore service data
docker-compose down
rm -rf ./data/ollama
# Restore from backup
tar -xzf ollama-backup.tar.gz
docker-compose up -d
```

### Network Recovery
```bash
# Recreate networks
docker network rm intranet mcp-network
docker network create intranet
docker network create mcp-network

# Restart services
docker-compose up -d
```

## Prevention Strategies

### Regular Maintenance
- **Daily**: Check service health
- **Weekly**: Update containers, clean up resources
- **Monthly**: Full backup, security review

### Monitoring Setup
- **Health checks**: Automated service monitoring
- **Log monitoring**: Error detection and alerting
- **Resource monitoring**: CPU, memory, disk usage

### Backup Strategy
- **Automated backups**: Daily database and data backups
- **Offsite storage**: Cloud backup for critical data
- **Recovery testing**: Regular disaster recovery drills

## Getting Help

### Log Collection
```bash
# Collect all logs
docker-compose logs > homelab-logs.txt
docker-compose -f docker-compose-mcp.yml logs >> homelab-logs.txt

# Collect system info
docker info > docker-info.txt
docker-compose config > docker-config.txt
```

### Support Resources
- **Docker Documentation**: https://docs.docker.com/
- **n8n Documentation**: https://docs.n8n.io/
- **Ollama Documentation**: https://ollama.ai/docs
- **Coolify Documentation**: https://coolify.io/docs
- **Cloudflare Documentation**: https://developers.cloudflare.com/

### Community Support
- **GitHub Issues**: Report bugs and feature requests
- **Discord/Slack**: Community support channels
- **Stack Overflow**: Technical questions and answers
