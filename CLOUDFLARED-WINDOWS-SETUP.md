# Cloudflared Windows Setup Guide

This guide covers the Cloudflare dashboard configuration needed to route Windows services through Cloudflared.

## Docker Configuration ✅

The `docker-compose.yml` has been updated:
- ✅ Cloudflared service added with Windows profile
- ✅ Traefik completely removed (no longer needed)
- ✅ All Traefik labels removed from services (n8n, coolify)
- ✅ Uses existing `CLOUDFLARED_TUNNEL_TOKEN` from `.env`

## Cloudflare Dashboard Configuration

### 1. Access Cloudflare Zero Trust Dashboard
- Go to: https://one.dash.cloudflare.com/
- Navigate to: **Networks** → **Tunnels**

### 2. Verify Tunnel Status
- Your tunnel should be listed (using the token from `.env`)
- Status should show as **Active** when the container is running

### 3. Configure Public Hostname Routes

For each Windows service, add a Public Hostname route:

#### Open WebUI (Chat)
- **Subdomain**: `chat`
- **Domain**: `eaglesightlabs.com`
- **Service**: `http://open-webui:8080`
- **Path**: (leave empty)

#### Stable Diffusion (Media)
- **Subdomain**: `media`
- **Domain**: `eaglesightlabs.com`
- **Service**: `http://stable-diffusion:7860`
- **Path**: (leave empty)

#### Remotion (Studio)
- **Subdomain**: `studio`
- **Domain**: `eaglesightlabs.com`
- **Service**: `http://remotion:80`
- **Path**: (leave empty)

#### Ollama API (Models)
- **Subdomain**: `models`
- **Domain**: `eaglesightlabs.com`
- **Service**: `http://ollama:11434`
- **Path**: (leave empty)

### Alternative: Use localhost (if container names don't work)

If Cloudflared can't resolve container names, use localhost with host ports:

- `chat.eaglesightlabs.com` → `http://localhost:5000`
- `media.eaglesightlabs.com` → `http://localhost:7860`
- `studio.eaglesightlabs.com` → `http://localhost:4000`
- `models.eaglesightlabs.com` → `http://localhost:11434`

## Testing

After configuring routes in Cloudflare dashboard:

1. **Start the services**:
   ```powershell
   docker-compose --profile windows up -d
   ```

2. **Check Cloudflared logs**:
   ```powershell
   docker logs cloudflared
   ```

3. **Verify tunnel status**:
   ```powershell
   docker exec cloudflared cloudflared tunnel info
   ```

4. **Test each domain**:
   - `https://chat.eaglesightlabs.com`
   - `https://media.eaglesightlabs.com`
   - `https://studio.eaglesightlabs.com`
   - `https://models.eaglesightlabs.com`

## Notes

- **SSL**: Cloudflared automatically handles SSL certificates (no Let's Encrypt needed)
- **No Port Exposure**: Cloudflared connects outbound, so no need to open ports 80/443 on Windows
- **Container Names**: Cloudflared can reach containers by name since they're on the same `intranet` network
- **Linux Services**: n8n and Coolify are now accessible directly via their ports (5678 and 7000 respectively) - no reverse proxy

## Troubleshooting

### Tunnel not connecting
- Verify `CLOUDFLARED_TUNNEL_TOKEN` is correct in `.env`
- Check Cloudflared logs: `docker logs cloudflared`
- Verify tunnel is active in Cloudflare dashboard

### Services not accessible
- Check that routes are configured in Cloudflare dashboard
- Verify container names match (case-sensitive)
- Try using `localhost:PORT` instead of container names
- Check that Windows services are running: `docker ps`

### DNS not resolving
- Ensure DNS records in Cloudflare are set to **Proxied** (orange cloud)
- DNS records should point to the tunnel, not an IP address
- Wait a few minutes for DNS propagation

