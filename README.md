# Homelab

A Docker-based homelab setup for running Ollama with Open-WebUI, accessible both locally and remotely via Cloudflare tunnel.

## Services

### Ollama
- **Container**: `ollama/ollama:latest`
- **Port**: 11434 (internal API)
- **GPU**: NVIDIA GPU support enabled
- **Purpose**: Local LLM inference engine

### Open-WebUI
- **Container**: `ghcr.io/open-webui/open-webui:v0.6.1`
- **Local Port**: 5000
- **Container Port**: 8080
- **Purpose**: Web interface for interacting with Ollama models
- **Local Access**: `http://localhost:5000`
- **Public Access**: `https://your-domain.com` (configured via Cloudflare tunnel)

### N8N
- **Container**: `n8nio/n8n:latest`
- **Local Port**: 5678
- **Container Port**: 5678
- **Purpose**: Workflow automation platform
- **Local Access**: `http://localhost:5678`
- **Public Access**: `https://your-domain.com` (configured via Cloudflare tunnel)
- **Authentication**: Basic auth with username/password

### Cloudflare Tunnel
- **Container**: `cloudflare/cloudflared:latest`
- **Tunnel Name**: Ollama
- **Purpose**: Secure remote access to local services
- **Public Domain**: Configured in your Cloudflare dashboard

## Prerequisites

- Docker and Docker Compose
- NVIDIA GPU with proper drivers (for GPU acceleration)
- Cloudflare account with tunnel configured
- Valid `CLOUDFLARED_TUNNEL_TOKEN` in `.env` file

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd homelab
   ```

2. **Set up environment variables**:
   ```bash
   # Copy the .env file and add your Cloudflare tunnel token
   cp .env.example .env
   # Edit .env and add your CLOUDFLARED_TUNNEL_TOKEN
   # Also set N8N_USERNAME and N8N_PASSWORD for n8n authentication
   ```

3. **Start the services**:
   ```bash
   # On Windows
   .\start.ps1

   # On Linux/Mac
   docker-compose up -d
   ```

4. **Access the services**:
   - **Local**:
     - Open-WebUI: `http://localhost:5000`
     - N8N: `http://localhost:5678`
   - **Remote**: Open your configured Cloudflare tunnel domains in your browser

## Configuration

### Ports
- Open-WebUI: `5000:8080` (host:container)
- N8N: `5678:5678` (host:container)
- Ollama API: `11434:11434` (host:container)

### Volumes
- `ollama`: Persistent storage for downloaded models
- `open-webui`: Persistent storage for user data and settings
- `n8n`: Persistent storage for workflows and credentials

### Networks
- `intranet`: Internal Docker network for service communication

## Cloudflare Tunnel Setup

1. **Create a tunnel in Cloudflare dashboard**:
   - Go to Zero Trust → Access → Tunnels
   - Create a new tunnel
   - Configure the tunnel to route traffic to `localhost:5000`

2. **Get your tunnel token**:
   - Copy the tunnel token from the Cloudflare dashboard
   - Add it to your `.env` file as `CLOUDFLARED_TUNNEL_TOKEN`

3. **Configure your domain**:
   - Set up DNS records in Cloudflare to point your domain to the tunnel
   - The tunnel will provide secure access to your local Open-WebUI instance

## Usage

1. **First Time Setup**:
   - Access Open-WebUI at `http://localhost:5000`
   - Download your preferred models through the web interface
   - Configure any additional settings

2. **Remote Access**:
   - Use your configured Cloudflare tunnel domain to access from anywhere
   - The Cloudflare tunnel provides secure, encrypted access

3. **Model Management**:
   - Models are stored persistently in the `ollama` volume
   - Use the Open-WebUI interface to download and manage models

## Troubleshooting

### Check Service Status
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs open-webui
docker-compose logs n8n
docker-compose logs ollama
docker-compose logs cloudflared
```

### Restart Services
```bash
docker-compose restart
```

### Check Cloudflare Tunnel
```bash
docker logs cloudflared
```

## Security Notes

- The Cloudflare tunnel provides secure remote access
- Services are isolated in the `intranet` Docker network
- GPU access is restricted to the Ollama service
- Persistent data is stored in Docker volumes

## File Structure

```
homelab/
├── docker-compose.yml    # Service definitions
├── .env                  # Environment variables
├── start.ps1             # Windows startup script
└── README.md             # This file
```

## Support

For issues related to:
- **Ollama**: Check the [Ollama documentation](https://ollama.ai/docs)
- **Open-WebUI**: Check the [Open-WebUI repository](https://github.com/open-webui/open-webui)
- **N8N**: Check the [N8N documentation](https://docs.n8n.io/)
- **Cloudflare Tunnel**: Check the [Cloudflare documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) 