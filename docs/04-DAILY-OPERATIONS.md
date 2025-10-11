# Daily Operations

## Starting Services

### Main Stack Startup
```bash
# Windows
.\start.ps1

# Linux
docker-compose up -d
```

### MCP Stack Startup
```bash
# Windows (conditional startup based on API keys)
.\start-mcp.ps1

# Linux (manual startup)
docker-compose -f docker-compose-mcp.yml --env-file mcp.env up -d
```

### Automated Startup
The `check-docker.ps1` script provides automated startup:
- Checks internet connection
- Starts Docker Desktop if not running
- Starts containers if not running
- Runs automatically via Windows Task Scheduler

## Stopping Services

### Graceful Shutdown
```bash
# Stop main stack
docker-compose down

# Stop MCP stack
docker-compose -f docker-compose-mcp.yml down

# Stop all services
docker-compose down
docker-compose -f docker-compose-mcp.yml down
```

### Force Stop
```bash
# Force stop all containers
docker-compose down --remove-orphans
docker-compose -f docker-compose-mcp.yml down --remove-orphans
```

## Viewing Logs

### All Services
```bash
# Main stack logs
docker-compose logs

# MCP stack logs
docker-compose -f docker-compose-mcp.yml logs

# Follow logs in real-time
docker-compose logs -f
```

### Specific Services
```bash
# Individual service logs
docker-compose logs ollama
docker-compose logs open-webui
docker-compose logs n8n
docker-compose logs coolify

# MCP service logs
docker-compose -f docker-compose-mcp.yml logs tiktok-mcp
docker-compose -f docker-compose-mcp.yml logs youtube-mcp
```

### Log Filtering
```bash
# Filter by time
docker-compose logs --since 1h

# Filter by lines
docker-compose logs --tail 100

# Filter by service and time
docker-compose logs --since 1h ollama
```

## Checking Service Health

### Container Status
```bash
# Check running containers
docker-compose ps

# Check all containers (including stopped)
docker-compose ps -a

# Check specific service
docker-compose ps ollama
```

### Health Checks
```bash
# Test Ollama API
curl http://localhost:11434/api/tags

# Test Open-WebUI
curl http://localhost:5000

# Test n8n
curl http://localhost:5678

# Test Coolify
curl http://localhost:6000
```

### Service-Specific Health Checks
```bash
# Ollama model list
docker exec ollama ollama list

# n8n workflow count
curl -u username:password http://localhost:5678/api/v1/workflows

# Coolify application status
curl http://localhost:6000/api/health
```

## Accessing Web Interfaces

### Main Services
- **Open-WebUI**: `http://localhost:5000`
- **n8n**: `http://localhost:5678`
- **Coolify**: `http://localhost:6000`

### MCP Services (if running)
- **TikTok MCP**: `http://localhost:3300`
- **YouTube MCP**: `http://localhost:3301`
- **Twitter MCP**: `http://localhost:3302`
- **n8n MCP**: `http://localhost:3303`
- **MCP Dashboard**: `http://localhost:3304`

### Remote Access
- **Cloudflare Tunnel**: `https://your-domain.com`
- **Tunnel Status**: Check Cloudflare dashboard

## Docker Desktop Management

### Starting Docker Desktop
```bash
# Manual start
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Check if running
Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
```

### Docker Health Check
```bash
# Test Docker daemon
docker info

# Test Docker Compose
docker-compose version

# Test GPU access
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### Docker Resource Management
```bash
# Check disk usage
docker system df

# Clean up unused resources
docker system prune

# Clean up volumes
docker volume prune
```

## Automatic Startup Configuration

### Windows Task Scheduler
1. **Create Basic Task**
   - Name: "Homelab Health Check"
   - Trigger: At startup
   - Action: Start a program
   - Program: `powershell.exe`
   - Arguments: `-File "D:\dev\homelab\check-docker.ps1"`

2. **Advanced Settings**
   - Run with highest privileges
   - Run whether user is logged on or not
   - Configure for Windows 10/11

### Linux Systemd (Future TrueNAS Scale)
```bash
# Create systemd service
sudo nano /etc/systemd/system/homelab.service

# Service file content
[Unit]
Description=Homelab Services
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/path/to/homelab
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down

[Install]
WantedBy=multi-user.target

# Enable and start
sudo systemctl enable homelab.service
sudo systemctl start homelab.service
```

## Monitoring and Alerts

### Service Monitoring
```bash
# Check service uptime
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# Monitor resource usage
docker stats

# Check disk usage
docker system df
```

### Log Monitoring
```bash
# Monitor error logs
docker-compose logs | grep -i error

# Monitor specific service
docker-compose logs -f ollama | grep -i error

# Monitor MCP services
docker-compose -f docker-compose-mcp.yml logs -f | grep -i error
```

### Performance Monitoring
```bash
# Check container resource usage
docker stats --no-stream

# Check GPU usage
nvidia-smi

# Check network usage
docker network ls
docker network inspect intranet
```

## Common Operations

### Restart Services
```bash
# Restart specific service
docker-compose restart ollama

# Restart all services
docker-compose restart

# Restart MCP services
docker-compose -f docker-compose-mcp.yml restart
```

### Update Services
```bash
# Update specific service
.\update-containers.ps1

# Update all images
.\pull-docker-images.ps1

# Update Ollama models
.\pull-ollama-models.ps1
```

### Backup Operations
```bash
# Backup database
docker exec coolify-db pg_dump -U coolify coolify > backup.sql

# Backup Redis
docker exec coolify-redis redis-cli BGSAVE

# Backup application data
tar -czf backup-$(date +%Y%m%d).tar.gz ./data/
```

## Troubleshooting Common Issues

### Service Won't Start
```bash
# Check logs
docker-compose logs service-name

# Check port conflicts
netstat -an | findstr :5000

# Check resource usage
docker stats
```

### Network Issues
```bash
# Check network connectivity
docker exec ollama ping open-webui

# Check DNS resolution
docker exec ollama nslookup open-webui

# Recreate networks
docker network rm intranet
docker network create intranet
```

### GPU Issues
```bash
# Check GPU access
docker exec ollama nvidia-smi

# Check GPU drivers
nvidia-smi

# Restart with GPU
docker-compose down
docker-compose up -d
```

## Maintenance Windows

### Scheduled Maintenance
- **Time**: 2-4 AM Central Time
- **Frequency**: Weekly or as needed
- **Tasks**: Updates, cleanup, backups

### Maintenance Checklist
- [ ] Check service health
- [ ] Review logs for errors
- [ ] Update containers if needed
- [ ] Clean up old images
- [ ] Backup critical data
- [ ] Test remote access
- [ ] Verify GPU functionality
