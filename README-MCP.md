# MCP Servers for Content Automation

This is a separate Docker Compose stack for running MCP (Model Context Protocol) servers that provide content automation capabilities. This stack can be deployed independently from your main homelab services and is designed for potential monetization.

## 🚀 Quick Start

1. **Configure Environment Variables:**

   ```bash
   cp mcp.env.example mcp.env
   # Edit mcp.env with your API credentials
   ```

2. **Start the MCP Servers:**

   ```bash
   .\start-mcp.ps1 start
   ```

3. **Access the Dashboard:**
   - Open <http://localhost:3304> in your browser

## 📋 Services Overview

| Service | Port | Purpose | API Required |
|---------|------|---------|--------------|
| TikTok MCP | 3300 | TikTok content analysis and management | TikTok Developer API |
| YouTube MCP | 3301 | YouTube data and video management | YouTube Data API v3 |
| Twitter MCP | 3302 | Twitter/X posting and analytics | Twitter API v2 |
| n8n MCP | 3303 | n8n workflow integration | n8n API |

## 🏗️ Architecture

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   TikTok MCP    │    │  YouTube MCP    │    │  Twitter MCP    │
│   Port: 3300    │    │   Port: 3301    │    │   Port: 3302    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   n8n MCP       │
                    │   Port: 3303    │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Dashboard     │
                    │   Port: 3304    │
                    └─────────────────┘

## 📁 Directory Structure

```text
./data/
├── mcp-servers/
│   ├── tiktok/          # TikTok MCP data and logs
│   ├── youtube/         # YouTube MCP data and logs
│   ├── twitter/         # Twitter MCP data and logs
│   ├── n8n-mcp/         # n8n MCP data and logs
│   └── dashboard/       # Dashboard static files
│       ├── index.html   # Dashboard interface
│       └── nginx.conf   # Nginx configuration
├── docker-compose-mcp.yml  # MCP services configuration
├── mcp.env              # Environment variables
└── start-mcp.ps1        # Management script
```

## 🔧 Configuration

### Environment Variables (mcp.env)

```bash
# TikTok MCP Server
TIKTOK_API_KEY=your_tiktok_api_key_here
TIKTOK_API_SECRET=your_tiktok_api_secret_here
TIKTOK_ACCESS_TOKEN=your_tiktok_access_token_here

# YouTube MCP Server
YOUTUBE_API_KEY=your_youtube_api_key_here
YOUTUBE_CLIENT_ID=your_youtube_client_id_here
YOUTUBE_CLIENT_SECRET=your_youtube_client_secret_here
YOUTUBE_REFRESH_TOKEN=your_youtube_refresh_token_here

# Twitter MCP Server
TWITTER_API_KEY=your_twitter_api_key_here
TWITTER_API_SECRET=your_twitter_api_secret_here
TWITTER_ACCESS_TOKEN=your_twitter_access_token_here
TWITTER_ACCESS_TOKEN_SECRET=your_twitter_access_token_secret_here
TWITTER_BEARER_TOKEN=your_twitter_bearer_token_here

# n8n MCP Server
N8N_API_URL=http://host.docker.internal:5678
N8N_API_KEY=your_n8n_api_key_here
```

### API Setup Instructions

#### TikTok API

1. Go to [TikTok Developer Portal](https://developers.tiktok.com/)
2. Create a new app
3. Get your API key, secret, and access token
4. Add to `mcp.env`

#### YouTube API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable YouTube Data API v3
3. Create credentials (API key and OAuth2)
4. Get refresh token using OAuth2 flow
5. Add to `mcp.env`

#### Twitter API

1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Create a new app
3. Get API keys and tokens
4. Add to `mcp.env`

#### n8n API

1. Use your existing n8n instance
2. Get API key from n8n settings
3. Add to `mcp.env`

## 🛠️ Management Commands

### PowerShell Script Usage

```powershell
# Start all MCP servers
.\start-mcp.ps1 start

# Stop all MCP servers
.\start-mcp.ps1 stop

# Restart all MCP servers
.\start-mcp.ps1 restart

# Check status of all servers
.\start-mcp.ps1 status

# View logs
.\start-mcp.ps1 logs

# Update images and restart
.\start-mcp.ps1 update

# Open dashboard in browser
.\start-mcp.ps1 dashboard
```

### Docker Compose Commands

```bash
# Start services
docker compose -f docker-compose-mcp.yml --env-file mcp.env up -d

# Stop services
docker compose -f docker-compose-mcp.yml down

# View logs
docker compose -f docker-compose-mcp.yml logs -f

# Update images
docker compose -f docker-compose-mcp.yml pull
```

## 🌐 Access Points

- **Dashboard**: <http://localhost:3304>
- **TikTok MCP**: <http://localhost:3300>
- **YouTube MCP**: <http://localhost:3301>
- **Twitter MCP**: <http://localhost:3302>
- **n8n MCP**: <http://localhost:3303>

## 🔒 Security Considerations

1. **Environment Variables**: Never commit `mcp.env` to version control
2. **API Keys**: Rotate API keys regularly
3. **Network Access**: Use Cloudflare tunnels for external access
4. **Firewall**: Only expose necessary ports
5. **Updates**: Keep images updated for security patches

## 📊 Monitoring

### Health Checks

Each service includes health check endpoints:

- `http://localhost:3300/health` - TikTok MCP
- `http://localhost:3301/health` - YouTube MCP
- `http://localhost:3302/health` - Twitter MCP
- `http://localhost:3303/health` - n8n MCP

### Dashboard Features

- Real-time status monitoring
- Auto-refresh every 30 seconds
- Individual server controls
- Uptime statistics

## 🚀 Deployment Options

### Local Development

```bash
.\start-mcp.ps1 start
```

### Production Deployment

1. Set up reverse proxy (nginx/traefik)
2. Configure SSL certificates
3. Set up monitoring and alerting
4. Use Docker Swarm or Kubernetes for scaling

### Cloudflare Tunnel

```bash
# Add to your Cloudflare tunnel configuration
- hostname: mcp.yourdomain.com
  service: http://localhost:3304
```

## 💰 Monetization Potential

This MCP stack can be monetized by:

1. **API-as-a-Service**: Expose MCP endpoints to customers
2. **Content Automation**: Offer automated posting services
3. **Analytics**: Provide social media analytics
4. **White-label**: License the stack to other businesses

## 🔧 Troubleshooting

### Common Issues

1. **Port Conflicts**: Ensure ports 3300-3304 are available
2. **API Limits**: Check API rate limits for each service
3. **Authentication**: Verify API credentials in `mcp.env`
4. **Network**: Ensure Docker networking is working properly

### Logs

```bash
# View all logs
.\start-mcp.ps1 logs

# View specific service logs
docker logs tiktok-mcp
docker logs youtube-mcp
docker logs twitter-mcp
docker logs n8n-mcp
```

### Reset Everything

```bash
# Stop and remove everything
docker compose -f docker-compose-mcp.yml down -v

# Remove data directories
Remove-Item -Recurse -Force ./data/mcp-servers/*

# Recreate directories
New-Item -ItemType Directory -Path "./data/mcp-servers/tiktok", "./data/mcp-servers/youtube", "./data/mcp-servers/twitter", "./data/mcp-servers/n8n-mcp", "./data/mcp-servers/dashboard" -Force

# Restart
.\start-mcp.ps1 start
```

## 📝 License

This setup is for personal and commercial use. Ensure you comply with the terms of service for each API provider.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
