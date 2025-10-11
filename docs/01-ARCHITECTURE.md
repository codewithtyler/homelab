# System Architecture

## Two-Stack Design

The homelab uses a two-stack architecture to separate core functionality from optional automation services:

### Main Stack (`docker-compose.yml`)
Core services that provide essential homelab functionality:
- **Ollama**: LLM inference engine
- **Open-WebUI**: Web interface for LLM interaction
- **n8n**: Workflow automation platform
- **Coolify**: Self-hosted PaaS for application deployment
- **Supporting Services**: PostgreSQL, Redis, Cloudflared

### MCP Stack (`docker-compose-mcp.yml`)
Optional content automation services for monetization:
- **TikTok MCP**: TikTok content management
- **YouTube MCP**: YouTube data and video management
- **Twitter MCP**: Twitter/X posting and analytics
- **n8n MCP**: Integration with main n8n instance
- **Dashboard**: Status monitoring for MCP services

## Network Topology

```
┌─────────────────────────────────────────────────────────────┐
│                    HOST SYSTEM (Windows)                    │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                Docker Networks                          │ │
│  │  ┌─────────────────┐    ┌─────────────────────────────┐ │ │
│  │  │    intranet     │    │       mcp-network           │ │ │
│  │  │                 │    │                             │ │ │
│  │  │ ┌─────────────┐ │    │ ┌─────────────┐ ┌─────────────┐ │ │ │
│  │  │ │   Ollama    │ │    │ │TikTok MCP  │ │YouTube MCP │ │ │ │
│  │  │ │ Open-WebUI  │ │    │ │Twitter MCP  │ │ n8n MCP    │ │ │ │
│  │  │ │    n8n      │ │    │ │Dashboard   │ │            │ │ │ │
│  │  │ │  Coolify    │ │    │ └─────────────┘ └─────────────┘ │ │ │
│  │  │ │Coolify-DB   │ │    │                             │ │ │
│  │  │ │Coolify-Redis│ │    │                             │ │ │
│  │  │ │ Cloudflared │ │    │                             │ │ │
│  │  │ └─────────────┘ │    │                             │ │ │
│  │  └─────────────────┘    └─────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Data Persistence                           │ │
│  │  ./data/ollama/     ./data/open-webui/                │ │
│  │  ./data/n8n/       ./data/coolify/                     │ │
│  │  ./data/coolify-db ./data/coolify-redis/              │ │
│  │  ./data/mcp-servers/                                   │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Service Dependencies

### Main Stack Dependencies
```
Cloudflared (Tunnel)
    │
    ├── Ollama (LLM Engine)
    │   └── Open-WebUI (Web Interface)
    │
    ├── n8n (Automation)
    │
    └── Coolify (PaaS)
        ├── Coolify-DB (PostgreSQL)
        └── Coolify-Redis (Cache)
```

### MCP Stack Dependencies
```
MCP Dashboard
    ├── TikTok MCP (if API keys present)
    ├── YouTube MCP (if API keys present)
    ├── Twitter MCP (if API keys present)
    └── n8n MCP (if API keys present)
```

## Data Persistence Strategy

### Volume Mounts
All services use bind mounts to the `./data/` directory for persistence:

| Service | Host Path | Container Path | Purpose |
|---------|-----------|----------------|---------|
| Ollama | `./data/ollama` | `/root/.ollama` | Model storage |
| Open-WebUI | `./data/open-webui` | `/app/backend/data` | User data, settings |
| n8n | `./data/n8n` | `/home/node/.n8n` | Workflows, credentials |
| Coolify | `./data/coolify` | `/app/data` | Application data |
| Coolify-DB | `./data/coolify-db` | `/var/lib/postgresql/data` | Database files |
| Coolify-Redis | `./data/coolify-redis` | `/data` | Cache data |
| MCP Services | `./data/mcp-servers/{service}` | `/app/data` | Service-specific data |

### Backup Strategy
- **Database**: PostgreSQL dumps via `pg_dump`
- **Redis**: RDB snapshots and AOF files
- **Application Data**: File system backups of `./data/` directories
- **Models**: Ollama model files in `./data/ollama/models/`

## GPU Allocation

### GPU Access Configuration
```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: ["gpu"]
```

### Services with GPU Access
- **Ollama**: Primary LLM inference engine
- **Open-WebUI**: Web interface with GPU acceleration for embeddings

### GPU Resource Management
- Both services share the same GPU
- Ollama gets priority for inference tasks
- Open-WebUI uses GPU for embedding generation and model operations

## External Access

### Cloudflare Tunnel Configuration
- **Tunnel Name**: "Ollama"
- **Authentication**: Token-based via `CLOUDFLARED_TUNNEL_TOKEN`
- **Security**: Encrypted connection, no direct port exposure
- **Domains**: Configured in Cloudflare dashboard

### Port Exposure Strategy
- **Local Access**: All services accessible via localhost
- **Remote Access**: Only through Cloudflare tunnel
- **No Direct Internet**: No services directly exposed to internet

## Communication Patterns

### Inter-Service Communication
- **Main Stack**: Services communicate via `intranet` network
- **MCP Stack**: Services communicate via `mcp-network`
- **Cross-Stack**: n8n MCP connects to main n8n via `host.docker.internal:5678`

### API Endpoints
- **Ollama API**: `http://ollama:11434` (internal), `http://localhost:11434` (host)
- **n8n API**: `http://n8n:5678` (internal), `http://localhost:5678` (host)
- **MCP Services**: Individual ports (3300-3304) for external access

## Security Architecture

### Network Isolation
- **Service Segregation**: Main and MCP stacks isolated
- **Internal Communication**: Services communicate via Docker networks
- **External Access**: Only through Cloudflare tunnel

### Authentication
- **n8n**: Basic authentication with username/password
- **Coolify**: Built-in authentication system
- **MCP Services**: API key-based authentication

### Data Protection
- **Encryption**: All remote access encrypted via Cloudflare
- **Secrets Management**: Environment variables for sensitive data
- **Access Control**: Service-level authentication and authorization
