# Services Reference

## Main Stack Services

### Ollama
**Purpose**: Local LLM inference engine with GPU acceleration

**Container Details**:
- **Image**: `ollama/ollama:latest`
- **Container Name**: `ollama`
- **Port**: `11434:11434`
- **GPU**: NVIDIA GPU access enabled

**Configuration**:
- **Volume**: `./data/ollama:/root/.ollama`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- None required (uses defaults)

**Dependencies**:
- None (base service)

**Health Check**:
- API endpoint: `http://localhost:11434/api/tags`
- Expected response: JSON list of available models

---

### Open-WebUI
**Purpose**: Web interface for interacting with Ollama models

**Container Details**:
- **Image**: `ghcr.io/open-webui/open-webui:v0.6.33`
- **Container Name**: `open-webui`
- **Port**: `5000:8080`
- **GPU**: NVIDIA GPU access enabled

**Configuration**:
- **Volume**: `./data/open-webui:/app/backend/data`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`
- **Extra Hosts**: `host.docker.internal:host-gateway`

**Environment Variables**:
- `HOST=0.0.0.0`
- `PORT=8080`

**Dependencies**:
- Ollama (for LLM inference)

**Health Check**:
- Web interface: `http://localhost:5000`
- Expected: Web UI loads successfully

---

### n8n
**Purpose**: Workflow automation platform

**Container Details**:
- **Image**: `n8nio/n8n:latest`
- **Container Name**: `n8n`
- **Port**: `5678:5678`

**Configuration**:
- **Volume**: `./data/n8n:/home/node/.n8n`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `N8N_BASIC_AUTH_ACTIVE=true`
- `N8N_BASIC_AUTH_USER=${N8N_USERNAME}`
- `N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD}`
- `N8N_HOST=0.0.0.0`
- `N8N_PORT=5678`
- `N8N_PROTOCOL=http`
- `WEBHOOK_URL=http://localhost:5678/`
- `GENERIC_TIMEZONE=UTC`
- `N8N_TRUST_PROXY=true`

**Dependencies**:
- None (base service)

**Health Check**:
- Web interface: `http://localhost:5678`
- Expected: Login page or dashboard

---

### Coolify
**Purpose**: Self-hosted PaaS for application deployment

**Container Details**:
- **Image**: `coollabsio/coolify:latest`
- **Container Name**: `coolify`
- **Port**: `6000:8080`

**Configuration**:
- **Volume**: `./data/coolify:/app/data`
- **Volume**: `/var/run/docker.sock:/var/run/docker.sock:ro`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `DB_CONNECTION=pgsql`
- `DB_HOST=coolify-db`
- `DB_PORT=5432`
- `DB_DATABASE=${COOLIFY_DB_NAME}`
- `DB_USERNAME=${COOLIFY_DB_USER}`
- `DB_PASSWORD=${COOLIFY_DB_PASSWORD}`
- `COOLIFY_PORT=8080`
- `COOLIFY_HOST=0.0.0.0`
- `REDIS_URL=redis://coolify-redis:6379`
- `APP_KEY=${APP_KEY}`

**Dependencies**:
- `coolify-redis` (condition: service_started)
- `coolify-db` (condition: service_healthy)

**Health Check**:
- Web interface: `http://localhost:6000`
- Expected: Coolify dashboard

---

### Coolify-DB (PostgreSQL)
**Purpose**: Database for Coolify application data

**Container Details**:
- **Image**: `postgres:15-alpine`
- **Container Name**: `coolify-db`

**Configuration**:
- **Volume**: `./data/coolify-db:/var/lib/postgresql/data`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `POSTGRES_DB=${COOLIFY_DB_NAME}`
- `POSTGRES_USER=${COOLIFY_DB_USER}`
- `POSTGRES_PASSWORD=${COOLIFY_DB_PASSWORD}`

**Health Check**:
- **Test**: `["CMD-SHELL", "pg_isready -U coolify -d coolify"]`
- **Interval**: 10s
- **Timeout**: 5s
- **Retries**: 5

---

### Coolify-Redis
**Purpose**: Cache and session storage for Coolify

**Container Details**:
- **Image**: `redis:7-alpine`
- **Container Name**: `coolify-redis`

**Configuration**:
- **Volume**: `./data/coolify-redis:/data`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`
- **Command**: `redis-server --appendonly yes`

**Environment Variables**:
- None required (uses defaults)

---

### Cloudflared
**Purpose**: Secure remote access via Cloudflare tunnel

**Container Details**:
- **Image**: `cloudflare/cloudflared:latest`
- **Container Name**: `cloudflared`

**Configuration**:
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`
- **Command**: `tunnel run Ollama`

**Environment Variables**:
- `TUNNEL_TOKEN=${CLOUDFLARED_TUNNEL_TOKEN}`

**Dependencies**:
- None (standalone service)

---

## MCP Stack Services

### TikTok MCP
**Purpose**: TikTok content analysis and management

**Container Details**:
- **Image**: `node:18-alpine`
- **Container Name**: `tiktok-mcp`
- **Port**: `3300:3000`
- **Profile**: `tiktok`

**Configuration**:
- **Volume**: `./data/mcp-servers/tiktok:/app/data`
- **Volume**: `./data/mcp-servers/tiktok/node_modules:/app/node_modules`
- **Network**: `mcp-network`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `NODE_ENV=production`
- `PORT=3000`
- `TIKTOK_API_KEY=${TIKTOK_API_KEY}`
- `TIKTOK_API_SECRET=${TIKTOK_API_SECRET}`
- `TIKTOK_ACCESS_TOKEN=${TIKTOK_ACCESS_TOKEN}`

**Dependencies**:
- TikTok Developer API credentials

**Health Check**:
- **Test**: `["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3
- **Start Period**: 40s

---

### YouTube MCP
**Purpose**: YouTube data and video management

**Container Details**:
- **Image**: `node:18-alpine`
- **Container Name**: `youtube-mcp`
- **Port**: `3301:3000`
- **Profile**: `youtube`

**Configuration**:
- **Volume**: `./data/mcp-servers/youtube:/app/data`
- **Volume**: `./data/mcp-servers/youtube/node_modules:/app/node_modules`
- **Network**: `mcp-network`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `NODE_ENV=production`
- `PORT=3000`
- `YOUTUBE_API_KEY=${YOUTUBE_API_KEY}`
- `YOUTUBE_CLIENT_ID=${YOUTUBE_CLIENT_ID}`
- `YOUTUBE_CLIENT_SECRET=${YOUTUBE_CLIENT_SECRET}`
- `YOUTUBE_REFRESH_TOKEN=${YOUTUBE_REFRESH_TOKEN}`

**Dependencies**:
- YouTube Data API v3 credentials

**Health Check**:
- **Test**: `["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3
- **Start Period**: 40s

---

### Twitter MCP
**Purpose**: Twitter/X posting and analytics

**Container Details**:
- **Image**: `node:18-alpine`
- **Container Name**: `twitter-mcp`
- **Port**: `3302:3000`
- **Profile**: `twitter`

**Configuration**:
- **Volume**: `./data/mcp-servers/twitter:/app/data`
- **Volume**: `./data/mcp-servers/twitter/node_modules:/app/node_modules`
- **Network**: `mcp-network`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `NODE_ENV=production`
- `PORT=3000`
- `TWITTER_API_KEY=${TWITTER_API_KEY}`
- `TWITTER_API_SECRET=${TWITTER_API_SECRET}`
- `TWITTER_ACCESS_TOKEN=${TWITTER_ACCESS_TOKEN}`
- `TWITTER_ACCESS_TOKEN_SECRET=${TWITTER_ACCESS_TOKEN_SECRET}`
- `TWITTER_BEARER_TOKEN=${TWITTER_BEARER_TOKEN}`

**Dependencies**:
- Twitter API v2 credentials

**Health Check**:
- **Test**: `["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3
- **Start Period**: 40s

---

### n8n MCP
**Purpose**: Integration with main n8n instance

**Container Details**:
- **Image**: `ghcr.io/czlonkowski/n8n-mcp:latest`
- **Container Name**: `n8n-mcp`
- **Port**: `3303:5678`
- **Profile**: `n8n-mcp`

**Configuration**:
- **Volume**: `./data/mcp-servers/n8n-mcp:/app/data`
- **Network**: `mcp-network`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `MCP_MODE=http`
- `N8N_API_URL=${N8N_API_URL}`
- `N8N_API_KEY=${N8N_API_KEY}`

**Dependencies**:
- Main n8n instance running
- n8n API key

**Health Check**:
- **Test**: `["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:5678/health"]`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3
- **Start Period**: 40s

---

### MCP Dashboard
**Purpose**: Status monitoring and management for MCP services

**Container Details**:
- **Image**: `nginx:alpine`
- **Container Name**: `mcp-dashboard`
- **Port**: `3304:80`
- **Profile**: `dashboard`

**Configuration**:
- **Volume**: `./data/mcp-servers/dashboard:/usr/share/nginx/html`
- **Volume**: `./data/mcp-servers/dashboard/nginx.conf:/etc/nginx/nginx.conf:ro`
- **Network**: `mcp-network`
- **Restart Policy**: `unless-stopped`

**Dependencies**:
- All MCP services (tiktok-mcp, youtube-mcp, twitter-mcp, n8n-mcp)

**Health Check**:
- Web interface: `http://localhost:3304`
- Expected: Dashboard with service status

---

## Stable Diffusion Services

### Stable Diffusion (Automatic1111)
**Purpose**: AI image generation with Automatic1111 WebUI

**Container Details**:
- **Image**: `ghcr.io/automatic1111/stable-diffusion-webui:latest`
- **Container Name**: `stable-diffusion`
- **Port**: `7860:7860`
- **GPU**: NVIDIA GPU access enabled (RTX 3080 10GB optimized)

**Configuration**:
- **Volume**: `./data/stable-diffusion/models:/app/models`
- **Volume**: `./data/stable-diffusion/outputs:/app/outputs`
- **Volume**: `./data/stable-diffusion/loras:/app/loras`
- **Volume**: `./data/stable-diffusion/extensions:/app/extensions`
- **Volume**: `./data/stable-diffusion/embeddings:/app/embeddings`
- **Volume**: `./data/stable-diffusion/controlnet:/app/extensions/sd-webui-controlnet/models`
- **Network**: `intranet`
- **Restart Policy**: `unless-stopped`

**Environment Variables**:
- `NVIDIA_VISIBLE_DEVICES=all`
- `COMMANDLINE_ARGS=--api --listen --medvram --xformers --no-half-vae`

**Dependencies**:
- None (standalone service)

**Health Check**:
- Web interface: `http://localhost:7860`
- API documentation: `http://localhost:7860/docs`
- Expected: Automatic1111 WebUI loads successfully

**Performance (RTX 3080 10GB)**:
- **SDXL (1024x1024)**: 5-8 seconds per image
- **SD 1.5 (512x512)**: 2-3 seconds per image
- **Batch processing**: 4-8 images simultaneously
- **VRAM usage**: 6-8GB (SDXL), 4-5GB (SD 1.5)

**Models Included**:
- **Realistic Vision v5.1 SDXL**: 7GB base model
- **ControlNet OpenPose**: 1.4GB for pose control
- **ControlNet Canny**: 1.4GB for edge detection
- **ControlNet Depth**: 1.4GB for depth control

**API Integration**:
- **Text-to-Image**: `POST /sdapi/v1/txt2img`
- **Image-to-Image**: `POST /sdapi/v1/img2img`
- **ControlNet**: `POST /sdapi/v1/controlnet/detect`
- **Model Management**: `GET /sdapi/v1/sd-models`

**n8n Integration**:
```javascript
// Example n8n workflow for image generation
const response = await fetch('http://stable-diffusion:7860/sdapi/v1/txt2img', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    prompt: "beautiful landscape, photorealistic",
    negative_prompt: "blurry, low quality",
    width: 1024,
    height: 1024,
    steps: 20,
    cfg_scale: 7.5,
    sampler_name: "DPM++ 2M Karras"
  })
});
```
