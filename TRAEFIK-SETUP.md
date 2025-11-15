# Traefik Setup Guide

This guide explains how to set up Traefik for routing between Linux and Windows Docker hosts with automatic HTTPS via Let's Encrypt.

## Prerequisites

1. **Cloudflare API Token**: Create a DNS API token at https://dash.cloudflare.com/profile/api-tokens
   - Required permissions: `Zone:DNS:Edit` for your domain(s)
   - Note the token value

2. **Windows Host IP**: Determine your Windows machine's IP address
   - Recommended: Set up a DHCP reservation in your router for a static IP
   - Or use a hostname if your Linux host can resolve it

## Setup Steps

### 1. Configure Environment Variables

Edit `.env` file and set the following:

```bash
# Cloudflare API credentials
CF_API_EMAIL=your-cloudflare-email@example.com
CF_DNS_API_TOKEN=your-cloudflare-dns-api-token-here

# Let's Encrypt email for certificate notifications
ACME_EMAIL=your-email@example.com

# Windows host IP address
WINDOWS_HOST_IP=192.168.1.100  # Replace with your Windows machine's IP
```

### 2. Update Traefik Router Configuration

The `traefik/dynamic/routers.yml` file contains placeholders for the Windows host IP. You need to replace `WINDOWS_HOST_IP_PLACEHOLDER` with your actual Windows IP.

**Option A: Use the setup script (recommended)**
```powershell
.\scripts\setup-traefik-windows-ip.ps1
```

This script reads `WINDOWS_HOST_IP` from your `.env` file and updates the routers.yml automatically.

**Option B: Manual replacement**
1. Open `traefik/dynamic/routers.yml`
2. Replace all instances of `WINDOWS_HOST_IP_PLACEHOLDER` with your Windows machine's IP address
3. Save the file

### 3. Update DNS Records

Update your Cloudflare DNS records to point to your Linux host's public IP address (where Traefik will be running):

- `agents.eaglesightlabs.com` → Your Linux host IP
- `agents.codewithtyler.com` → Your Linux host IP
- `platform.eaglesightlabs.com` → Your Linux host IP
- `chat.eaglesightlabs.com` → Your Linux host IP
- `media.eaglesightlabs.com` → Your Linux host IP
- `studio.eaglesightlabs.com` → Your Linux host IP
- `models.eaglesightlabs.com` → Your Linux host IP

Keep all records **Proxied** (orange cloud) for Cloudflare protection.

### 4. Configure Windows Firewall

On your Windows machine, ensure the following ports are accessible from your Linux host:

- Port 5000 (Open WebUI)
- Port 7860 (Stable Diffusion)
- Port 4000 (Remotion)
- Port 11434 (Ollama)

You can test connectivity from Linux:
```bash
telnet <windows-ip> 5000
# or
nc -zv <windows-ip> 5000
```

### 5. Start Services

**On Linux host:**
```bash
docker-compose -f docker-compose.linux.yml up -d
```

**On Windows host:**
```bash
docker-compose -f docker-compose.windows.yml up -d
```

### 6. Verify Setup

1. **Check Traefik Dashboard**: Access `http://<linux-ip>:8080` to see the Traefik dashboard
2. **Check Certificates**: Traefik will automatically request Let's Encrypt certificates. This may take a few minutes on first run.
3. **Test Domains**: Once certificates are issued, test each domain:
   - `https://agents.eaglesightlabs.com` → n8n
   - `https://platform.eaglesightlabs.com` → Coolify
   - `https://chat.eaglesightlabs.com` → Open WebUI
   - `https://media.eaglesightlabs.com` → Stable Diffusion
   - `https://studio.eaglesightlabs.com` → Remotion
   - `https://models.eaglesightlabs.com` → Ollama API

## Troubleshooting

### Certificates Not Issuing

1. Check Traefik logs: `docker logs traefik`
2. Verify Cloudflare API token has correct permissions
3. Ensure DNS records point to your Linux host
4. Check that DNS records are proxied (orange cloud)

### Cannot Reach Windows Services

1. Verify Windows firewall allows connections from Linux host
2. Test direct connection: `curl http://<windows-ip>:5000`
3. Check that Windows services are running: `docker ps` on Windows
4. Verify `WINDOWS_HOST_IP` is correct in routers.yml

### HTTP Redirect Loop

If you see redirect loops, check that:
- Traefik entrypoints are correctly configured
- Services are listening on the expected ports
- No conflicting port mappings

## Domain Routing Summary

| Domain | Service | Host | Port |
|--------|---------|------|------|
| `agents.eaglesightlabs.com` | n8n | Linux | 5678 |
| `agents.codewithtyler.com` | n8n | Linux | 5678 |
| `platform.eaglesightlabs.com` | Coolify | Linux | 8080 |
| `chat.eaglesightlabs.com` | Open WebUI | Windows | 5000 |
| `media.eaglesightlabs.com` | Stable Diffusion | Windows | 7860 |
| `studio.eaglesightlabs.com` | Remotion | Windows | 4000 |
| `models.eaglesightlabs.com` | Ollama API | Windows | 11434 |

## Notes

- Traefik automatically renews Let's Encrypt certificates (no manual intervention needed)
- Certificates are stored in `traefik/data/acme.json`
- The original `docker-compose.yml` is kept as a backup
- Cloudflared service has been removed from both compose files

