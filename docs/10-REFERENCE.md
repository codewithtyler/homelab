# Quick Reference

## All Ports at a Glance

| Service | Port | Purpose | Access |
|---------|------|---------|---------|
| **Ollama** | 11434 | LLM API | `http://localhost:11434` |
| **Open-WebUI** | 5000 | Web Interface | `http://localhost:5000` |
| **n8n** | 5678 | Workflow Automation | `http://localhost:5678` |
| **Coolify** | 6000 | PaaS Platform | `http://localhost:6000` |
| **TikTok MCP** | 3300 | TikTok API | `http://localhost:3300` |
| **YouTube MCP** | 3301 | YouTube API | `http://localhost:3301` |
| **Twitter MCP** | 3302 | Twitter API | `http://localhost:3302` |
| **n8n MCP** | 3303 | n8n Integration | `http://localhost:3303` |
| **MCP Dashboard** | 3304 | Status Monitoring | `http://localhost:3304` |

## All Environment Variables

### Main Stack (.env)
```bash
# n8n Authentication
N8N_USERNAME=your_username
N8N_PASSWORD=your_secure_password

# Coolify Database
COOLIFY_DB_NAME=coolify
COOLIFY_DB_USER=coolify
COOLIFY_DB_PASSWORD=your_secure_db_password
APP_KEY=your_32_character_app_key

# Cloudflare Tunnel
CLOUDFLARED_TUNNEL_TOKEN=your_tunnel_token
```

### MCP Stack (mcp.env)
```bash
# TikTok MCP Server
TIKTOK_API_KEY=your_tiktok_api_key
TIKTOK_API_SECRET=your_tiktok_api_secret
TIKTOK_ACCESS_TOKEN=your_tiktok_access_token

# YouTube MCP Server
YOUTUBE_API_KEY=your_youtube_api_key
YOUTUBE_CLIENT_ID=your_youtube_client_id
YOUTUBE_CLIENT_SECRET=your_youtube_client_secret
YOUTUBE_REFRESH_TOKEN=your_youtube_refresh_token

# Twitter MCP Server
TWITTER_API_KEY=your_twitter_api_key
TWITTER_API_SECRET=your_twitter_api_secret
TWITTER_ACCESS_TOKEN=your_twitter_access_token
TWITTER_ACCESS_TOKEN_SECRET=your_twitter_access_token_secret
TWITTER_BEARER_TOKEN=your_twitter_bearer_token

# n8n MCP Server
N8N_API_URL=http://host.docker.internal:5678
N8N_API_KEY=your_n8n_api_key
```

## File Structure Map

```
homelab/
├── docs/                           # Documentation
│   ├── 00-PROJECT-OVERVIEW.md
│   ├── 01-ARCHITECTURE.md
│   ├── 02-SERVICES-REFERENCE.md
│   ├── 03-INSTALLATION-SETUP.md
│   ├── 04-DAILY-OPERATIONS.md
│   ├── 05-MAINTENANCE.md
│   ├── 06-TROUBLESHOOTING.md
│   ├── 07-MCP-SERVICES.md
│   ├── 08-DEVELOPMENT-TESTING.md
│   ├── 09-SECURITY.md
│   └── 10-REFERENCE.md
├── data/                           # Persistent data
│   ├── ollama/                     # Ollama models and data
│   ├── open-webui/                 # Open-WebUI user data
│   ├── n8n/                        # n8n workflows and data
│   ├── coolify/                    # Coolify application data
│   ├── coolify-db/                 # PostgreSQL database
│   ├── coolify-redis/              # Redis cache data
│   └── mcp-servers/                # MCP service data
│       ├── tiktok/                 # TikTok MCP data
│       ├── youtube/                # YouTube MCP data
│       ├── twitter/                # Twitter MCP data
│       ├── n8n-mcp/                # n8n MCP data
│       └── dashboard/              # MCP dashboard files
├── docker-compose.yml              # Main stack definition
├── docker-compose-mcp.yml          # MCP stack definition
├── .env                            # Main stack environment
├── mcp.env                         # MCP stack environment
├── start.ps1                       # Main stack startup
├── start-mcp.ps1                   # MCP stack startup
├── check-docker.ps1                # Health check and auto-start
├── update-containers.ps1           # Individual container updates
├── pull-docker-images.ps1          # Bulk image updates
├── pull-ollama-models.ps1          # Model synchronization
└── README.md                       # Main documentation
```

## PowerShell Script Summary

### start.ps1
**Purpose**: Start main homelab stack
**Usage**: `.\start.ps1`
**Function**: Creates intranet network and starts all main services

### start-mcp.ps1
**Purpose**: Start MCP services conditionally
**Usage**: `.\start-mcp.ps1`
**Function**: Checks for API keys and starts only available services

### check-docker.ps1
**Purpose**: Health check and automated startup
**Usage**: `.\check-docker.ps1`
**Function**: Checks internet, starts Docker Desktop, starts containers

### update-containers.ps1
**Purpose**: Update specific containers
**Usage**: `.\update-containers.ps1`
**Function**: Updates containers listed in `$containersToUpdate` array

### pull-docker-images.ps1
**Purpose**: Bulk image updates
**Usage**: `.\pull-docker-images.ps1`
**Function**: Updates all images, restarts services, cleans up old images

### pull-ollama-models.ps1
**Purpose**: Model synchronization
**Usage**: `.\pull-ollama-models.ps1`
**Function**: Syncs Ollama models with desired list

## Useful Docker Commands

### Container Management
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### Image Management
```bash
# Pull latest images
docker-compose pull

# Remove old images
docker image prune

# Clean up system
docker system prune -a
```

### Network Management
```bash
# List networks
docker network ls

# Inspect network
docker network inspect intranet

# Create network
docker network create intranet
```

### Volume Management
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect homelab_ollama

# Remove volume
docker volume rm homelab_ollama
```

## Service Health Checks

### API Endpoints
```bash
# Ollama API
curl http://localhost:11434/api/tags

# Open-WebUI
curl http://localhost:5000

# n8n
curl http://localhost:5678

# Coolify
curl http://localhost:6000
```

### Container Health
```bash
# Check container status
docker-compose ps

# Check resource usage
docker stats

# Check logs
docker-compose logs
```

### Network Health
```bash
# Test internal connectivity
docker exec ollama ping open-webui
docker exec n8n ping coolify

# Check network configuration
docker network inspect intranet
```

## External Documentation Links

### Service Documentation
- [Ollama Documentation](https://ollama.ai/docs)
- [Open-WebUI Documentation](https://github.com/open-webui/open-webui)
- [n8n Documentation](https://docs.n8n.io/)
- [Coolify Documentation](https://coolify.io/docs)
- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

### Docker Documentation
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Network Documentation](https://docs.docker.com/network/)
- [Docker Volume Documentation](https://docs.docker.com/storage/volumes/)

### API Documentation
- [TikTok Developer API](https://developers.tiktok.com/)
- [YouTube Data API v3](https://developers.google.com/youtube/v3)
- [Twitter API v2](https://developer.twitter.com/en/docs/twitter-api)

### Security Documentation
- [Docker Security](https://docs.docker.com/engine/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## Troubleshooting Quick Reference

### Common Issues
```bash
# Docker not running
Get-Process -Name "Docker Desktop"

# Port conflicts
netstat -an | findstr :5000

# Container won't start
docker-compose logs service-name

# GPU not detected
docker exec ollama nvidia-smi
```

### Log Locations
```bash
# Main stack logs
docker-compose logs

# MCP stack logs
docker-compose -f docker-compose-mcp.yml logs

# Specific service logs
docker-compose logs ollama
docker-compose logs open-webui
```

### Recovery Commands
```bash
# Restart specific service
docker-compose restart service-name

# Recreate container
docker-compose up -d --force-recreate service-name

# Clean up and restart
docker-compose down
docker-compose up -d
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
