# Cloudflare Tunnel Routes - Complete Reference

This document lists all configured Cloudflare tunnel routes for the homelab.

## Windows Services (via Cloudflared on Windows)

### Open WebUI (Chat Interface)
- **Domain**: `chat.eaglesightlabs.com`
- **Service**: `http://open-webui:8080`
- **Container**: `open-webui` (port 8080 internal, 5000 host)
- **Purpose**: Web interface for interacting with Ollama models

### Stable Diffusion (Image Generation)
- **Domain**: `media.eaglesightlabs.com`
- **Service**: `http://stable-diffusion:7860`
- **Container**: `stable-diffusion` (port 7860)
- **Purpose**: AI image generation web UI

### Remotion (Video Studio)
- **Domain**: `studio.eaglesightlabs.com`
- **Service**: `http://remotion:80`
- **Container**: `remotion` (port 80 internal, 4000 host)
- **Purpose**: Video editing and rendering interface

### Ollama API (LLM API)
- **Domain**: `models.eaglesightlabs.com`
- **Service**: `http://ollama:11434`
- **Container**: `ollama` (port 11434)
- **Purpose**: Local LLM inference API endpoint

## Linux Services (via Cloudflared on Windows)

### n8n (Workflow Automation)
- **Domain**: `agents.eaglesightlabs.com`
- **Service**: `http://n8n:5678`
- **Container**: `n8n` (port 5678)
- **Purpose**: Workflow automation platform (primary domain)

- **Domain**: `agents.codewithtyler.com`
- **Service**: `http://n8n:5678`
- **Container**: `n8n` (port 5678)
- **Purpose**: Workflow automation platform (secondary domain)

### Open WebUI (Secondary Domain)
- **Domain**: `chat.codewithtyler.com`
- **Service**: `http://open-webui:8080`
- **Container**: `open-webui` (port 8080)
- **Purpose**: Web interface for interacting with Ollama models (secondary domain)

## Route Configuration Summary

| Domain | Service | Container | Port | Host |
|--------|---------|-----------|------|------|
| `chat.eaglesightlabs.com` | Open WebUI | `open-webui` | 8080 | Windows |
| `media.eaglesightlabs.com` | Stable Diffusion | `stable-diffusion` | 7860 | Windows |
| `studio.eaglesightlabs.com` | Remotion | `remotion` | 80 | Windows |
| `models.eaglesightlabs.com` | Ollama API | `ollama` | 11434 | Windows |
| `agents.eaglesightlabs.com` | n8n | `n8n` | 5678 | Linux |
| `agents.codewithtyler.com` | n8n | `n8n` | 5678 | Linux |
| `chat.codewithtyler.com` | Open WebUI | `open-webui` | 8080 | Windows |

## Notes

- All routes use **Path**: `*` (catch-all)
- All routes have **Origin configurations**: `0` (default)
- SSL/TLS is automatically handled by Cloudflare
- Routes are accessible via HTTPS automatically
- Container names are resolved through the Docker `intranet` network

## Access URLs

### Primary Domain (eaglesightlabs.com)
- Chat: `https://chat.eaglesightlabs.com`
- Media: `https://media.eaglesightlabs.com`
- Studio: `https://studio.eaglesightlabs.com`
- Models API: `https://models.eaglesightlabs.com`
- Agents (n8n): `https://agents.eaglesightlabs.com`

### Secondary Domain (codewithtyler.com)
- Chat: `https://chat.codewithtyler.com`
- Agents (n8n): `https://agents.codewithtyler.com`

## Troubleshooting

If a route is not working:
1. Verify the container is running: `docker ps`
2. Check Cloudflared logs: `docker logs cloudflared`
3. Test container connectivity: `docker exec cloudflared ping <container-name>`
4. Verify route in Cloudflare dashboard
5. Check DNS records are set to **Proxied** (orange cloud)

