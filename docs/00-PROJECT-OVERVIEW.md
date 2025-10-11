# Homelab Project Overview

## Project Goals & Vision

This homelab serves three primary purposes:

1. **AI/LLM Experimentation Platform** - Local LLM inference with Ollama, web interface with Open-WebUI, and workflow automation with n8n
2. **Self-Hosted Services Platform** - Complete PaaS solution with Coolify for deploying and managing applications
3. **Development & Testing Environment** - Isolated environment for testing integrations, workflows, and custom applications

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        HOMELAB ECOSYSTEM                       │
├─────────────────────────────────────────────────────────────────┤
│  MAIN STACK (docker-compose.yml)                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│  │   Ollama    │ │ Open-WebUI  │ │    n8n      │ │  Coolify    │ │
│  │  (11434)    │ │   (5000)    │ │  (5678)     │ │  (6000)     │ │
│  │ LLM Engine  │ │ Web Interface│ │Automation   │ │   PaaS      │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
│         │               │               │               │        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│  │Coolify-DB   │ │Coolify-Redis│ │ Cloudflared │ │   Data      │ │
│  │PostgreSQL   │ │   Redis     │ │   Tunnel    │ │Persistence  │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│  MCP STACK (docker-compose-mcp.yml)                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│  │TikTok MCP   │ │YouTube MCP  │ │Twitter MCP  │ │ n8n MCP     │ │
│  │  (3300)     │ │  (3301)     │ │  (3302)    │ │  (3303)     │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
│         │               │               │               │        │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              MCP Dashboard (3304)                          │ │
│  │         Status Monitoring & Management                     │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Key Design Decisions

### Two-Stack Architecture
- **Main Stack**: Core services (Ollama, Open-WebUI, n8n, Coolify) for essential functionality
- **MCP Stack**: Content automation services for monetization potential, conditionally started based on API key availability

### Network Isolation
- **intranet**: Main services communication
- **mcp-network**: MCP services isolation
- **host.docker.internal**: Cross-stack communication

### Data Persistence Strategy
- All persistent data stored in `./data/` directory with bind mounts
- GPU access limited to Ollama and Open-WebUI
- External access via Cloudflare tunnel for security

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **LLM Engine** | Ollama | Local LLM inference with GPU acceleration |
| **Web Interface** | Open-WebUI | User-friendly chat interface for LLMs |
| **Automation** | n8n | Workflow automation and integrations |
| **PaaS** | Coolify | Self-hosted application deployment |
| **Database** | PostgreSQL 15 | Coolify data persistence |
| **Cache** | Redis 7 | Coolify session and cache storage |
| **Tunnel** | Cloudflared | Secure remote access |
| **MCP Services** | Node.js | Content automation |

## Quick Reference

### Main Services
- **Ollama**: `http://localhost:11434` (API), `http://localhost:5000` (Web UI)
- **n8n**: `http://localhost:5678`
- **Coolify**: `http://localhost:6000`

### MCP Services (if API keys configured)
- **TikTok MCP**: `http://localhost:3300`
- **YouTube MCP**: `http://localhost:3301`
- **Twitter MCP**: `http://localhost:3302`
- **n8n MCP**: `http://localhost:3303`
- **Dashboard**: `http://localhost:3304`

### Key Scripts
- `start.ps1` - Start main stack
- `start-mcp.ps1` - Start MCP services (conditional)
- `check-docker.ps1` - Health check and auto-start
- `update-containers.ps1` - Update specific containers
- `pull-docker-images.ps1` - Bulk image updates
- `pull-ollama-models.ps1` - Model synchronization

## Project Philosophy

This homelab is designed to be:
- **Self-contained**: Minimal external dependencies
- **Automated**: Automated updates, health monitoring, and maintenance
- **Scalable**: Easy migration to TrueNAS Scale or other platforms
- **Secure**: Network isolation, authentication, encrypted remote access
- **Maintainable**: Comprehensive documentation and automated operations
