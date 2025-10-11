# Installation & Setup Guide

## Prerequisites

### System Requirements
- **Operating System**: Windows 10/11 (current), Linux (TrueNAS Scale migration)
- **RAM**: Minimum 16GB, Recommended 32GB+
- **Storage**: Minimum 100GB free space
- **GPU**: NVIDIA GPU with CUDA support (for Ollama acceleration)
- **Network**: Stable internet connection

### Software Requirements
- **Docker Desktop**: Latest version with WSL2 backend
- **NVIDIA Drivers**: Latest drivers with Docker GPU support
- **PowerShell**: Version 5.1+ (Windows) or PowerShell Core (Linux)
- **Git**: For repository management

### External Services
- **Cloudflare Account**: For tunnel configuration
- **API Keys**: TikTok, YouTube, Twitter (optional for MCP services)
- **Domain**: For Cloudflare tunnel setup (optional)

## Initial Setup

### 1. Clone Repository
```bash
git clone <your-repo-url>
cd homelab
```

### 2. Docker Desktop Setup
1. **Install Docker Desktop**
   - Download from [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Enable WSL2 backend
   - Enable Kubernetes (optional)

2. **Configure GPU Support**
   - Install NVIDIA Container Toolkit
   - Enable GPU support in Docker Desktop settings
   - Test with: `docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi`

3. **Configure Auto-Start**
   - Enable Docker Desktop to start with Windows
   - Configure UAC bypass for automated startup

### 3. Environment Configuration

#### Main Stack Environment (`.env`)
Create `.env` file in project root:
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

#### MCP Stack Environment (`mcp.env`)
Create `mcp.env` file in project root:
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

### 4. Network Setup
```bash
# Create Docker networks
docker network create intranet
docker network create mcp-network
```

### 5. Directory Structure
```bash
# Create data directories
mkdir -p data/ollama
mkdir -p data/open-webui
mkdir -p data/n8n
mkdir -p data/coolify
mkdir -p data/coolify-db
mkdir -p data/coolify-redis
mkdir -p data/mcp-servers/tiktok
mkdir -p data/mcp-servers/youtube
mkdir -p data/mcp-servers/twitter
mkdir -p data/mcp-servers/n8n-mcp
mkdir -p data/mcp-servers/dashboard
```

## First-Time Startup

### 1. Start Main Stack
```bash
# Windows
.\start.ps1

# Linux
docker-compose up -d
```

### 2. Verify Services
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs ollama
docker-compose logs open-webui
docker-compose logs n8n
```

### 3. Start MCP Services (Optional)
```bash
# Windows
.\start-mcp.ps1

# Linux
docker-compose -f docker-compose-mcp.yml --env-file mcp.env up -d
```

## API Key Acquisition

### TikTok API
1. Go to [TikTok Developer Portal](https://developers.tiktok.com/)
2. Create a new app
3. Get API key, secret, and access token
4. Add to `mcp.env`

### YouTube API
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project or select existing
3. Enable YouTube Data API v3
4. Create credentials (API key and OAuth2)
5. Get refresh token using OAuth2 flow
6. Add to `mcp.env`

### Twitter API
1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Create a new app
3. Get API keys and tokens
4. Add to `mcp.env`

### n8n API
1. Access n8n at `http://localhost:5678`
2. Go to Settings → API
3. Generate API key
4. Add to `mcp.env`

## Cloudflare Tunnel Setup

### 1. Create Tunnel
1. Go to [Cloudflare Zero Trust](https://one.dash.cloudflare.com/)
2. Navigate to Access → Tunnels
3. Create new tunnel named "Ollama"
4. Copy tunnel token

### 2. Configure Tunnel
1. Add tunnel token to `.env` file
2. Configure DNS records in Cloudflare dashboard
3. Set up routing rules for your domain

### 3. Test Remote Access
1. Access services via your configured domain
2. Verify SSL certificates are working
3. Test authentication and functionality

## Model Downloads

### 1. Access Open-WebUI
- Navigate to `http://localhost:5000`
- Create admin account
- Configure Ollama connection

### 2. Download Models
```bash
# Download models via Ollama API
docker exec ollama ollama pull llama3.1:8b
docker exec ollama ollama pull deepseek-r1:14b
docker exec ollama ollama pull llama3.2-vision:11b
docker exec ollama ollama pull nomic-embed-text:latest
```

### 3. Verify Models
```bash
# List installed models
docker exec ollama ollama list

# Test model
docker exec ollama ollama run llama3.1:8b "Hello, world!"
```

## Post-Installation Verification

### 1. Service Health Checks
```bash
# Check all services are running
docker-compose ps

# Test web interfaces
curl http://localhost:5000  # Open-WebUI
curl http://localhost:5678  # n8n
curl http://localhost:6000  # Coolify
```

### 2. GPU Verification
```bash
# Check GPU access in Ollama
docker exec ollama nvidia-smi

# Check GPU access in Open-WebUI
docker exec open-webui nvidia-smi
```

### 3. Network Connectivity
```bash
# Test internal communication
docker exec ollama ping open-webui
docker exec n8n ping coolify

# Test external access
curl https://your-domain.com  # Cloudflare tunnel
```

## Troubleshooting Initial Setup

### Common Issues
1. **Docker not starting**: Check Docker Desktop is running
2. **GPU not detected**: Verify NVIDIA drivers and Docker GPU support
3. **Port conflicts**: Check if ports 5000, 5678, 6000 are available
4. **Permission errors**: Run PowerShell as Administrator
5. **Network issues**: Verify Docker networks are created

### Logs and Debugging
```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs ollama
docker-compose logs open-webui

# Check container status
docker-compose ps
```

## Next Steps

After successful installation:
1. **Configure n8n workflows** for your automation needs
2. **Set up Coolify applications** for additional services
3. **Configure MCP services** for content automation
4. **Set up automated updates** and monitoring
5. **Create backups** of your configuration and data
