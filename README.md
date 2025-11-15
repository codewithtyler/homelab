# Homelab

A comprehensive Docker-based homelab setup for AI/LLM experimentation, self-hosted services, and development/testing. Features Ollama with Open-WebUI, n8n workflow automation, Coolify PaaS, and MCP content automation services.

**✅ Cross-Platform Compatible** - Works on Windows now, Linux (TrueNAS Scale) later!

## 🚀 Quick Start

1. **Clone and setup**:
   ```bash
   git clone <your-repo-url>
   cd homelab
   cp mcp.env.example mcp.env
   # Edit mcp.env with your API credentials
   ```

2. **Initial setup** (one-time):
   ```bash
   # Windows
   scripts\ansible-runner.bat setup

   # Optional: Auto-start with Windows
   scripts\setup-windows-startup.bat

   # Linux
   chmod +x scripts/*.sh
   ./scripts/ansible-runner.sh setup
   ```

3. **Start services**:
   ```bash
   # Windows
   scripts\start-homelab.bat

   # Linux
   ./scripts/start-homelab.sh
   ```

4. **Access services**:
   - **Ollama**: `http://localhost:11434`
   - **Open-WebUI**: `http://localhost:5000`
   - **n8n**: `http://localhost:5678`
   - **Coolify**: `http://localhost:6000`
   - **MCP Dashboard**: `http://localhost:3304`

## 📚 Documentation

**Comprehensive documentation is available in the `docs/` folder:**

- **[00-PROJECT-OVERVIEW.md](docs/00-PROJECT-OVERVIEW.md)** - Project goals, vision, and architecture
- **[01-ARCHITECTURE.md](docs/01-ARCHITECTURE.md)** - Detailed system architecture
- **[02-SERVICES-REFERENCE.md](docs/02-SERVICES-REFERENCE.md)** - Complete service reference
- **[03-INSTALLATION-SETUP.md](docs/03-INSTALLATION-SETUP.md)** - Step-by-step setup guide
- **[04-DAILY-OPERATIONS.md](docs/04-DAILY-OPERATIONS.md)** - Common operational tasks
- **[05-MAINTENANCE.md](docs/05-MAINTENANCE.md)** - Update and maintenance procedures
- **[06-TROUBLESHOOTING.md](docs/06-TROUBLESHOOTING.md)** - Common issues and solutions
- **[07-MCP-SERVICES.md](docs/07-MCP-SERVICES.md)** - MCP content automation services
- **[08-DEVELOPMENT-TESTING.md](docs/08-DEVELOPMENT-TESTING.md)** - Development workflows
- **[09-SECURITY.md](docs/09-SECURITY.md)** - Security best practices
- **[10-REFERENCE.md](docs/10-REFERENCE.md)** - Quick reference guide
- **[CROSS-PLATFORM-SETUP.md](CROSS-PLATFORM-SETUP.md)** - Cross-platform migration guide
- **[MIGRATION-COMPLETE.md](MIGRATION-COMPLETE.md)** - PowerShell to cross-platform migration summary

## 🏗️ Architecture

### Main Stack
- **Ollama**: LLM inference engine with GPU acceleration
- **Open-WebUI**: Web interface for LLM interaction
- **n8n**: Workflow automation platform
- **Coolify**: Self-hosted PaaS for application deployment
- **Stable Diffusion**: AI image generation with Automatic1111 WebUI
- **Supporting Services**: PostgreSQL, Redis, Cloudflared

### MCP Stack (Optional)
- **TikTok MCP**: TikTok content management
- **YouTube MCP**: YouTube data and video management
- **Twitter MCP**: Twitter/X posting and analytics
- **n8n MCP**: Integration with main n8n instance
- **Dashboard**: Status monitoring for MCP services

## 🔧 Key Features

- **AI/LLM Platform**: Local LLM inference with Ollama and Open-WebUI
- **Workflow Automation**: n8n for complex automation workflows
- **Self-Hosted PaaS**: Coolify for application deployment
- **Content Automation**: MCP services for social media management
- **Secure Remote Access**: Cloudflare tunnel for external access
- **Automated Updates**: Ansible-based automation for container and model updates
- **Cross-Platform**: Works on Windows now, Linux (TrueNAS Scale) later
- **No PowerShell Issues**: Eliminated all PowerShell syntax errors with cross-platform scripts

## 📋 Prerequisites

- Docker Desktop with WSL2 backend
- NVIDIA GPU with CUDA support (for GPU acceleration)
- Cloudflare account (for remote access)
- API keys for MCP services (optional)

## 🚀 Quick Commands

### Windows
```cmd
# Setup (one-time)
scripts\ansible-runner.bat setup

# Optional: Auto-start with Windows
scripts\setup-windows-startup.bat

# Daily operations
scripts\start-homelab.bat
scripts\stop-homelab.bat

# MCP services
scripts\start-mcp.bat

# Ansible automation
scripts\ansible-runner.bat setup
scripts\ansible-runner.bat health
scripts\ansible-runner.bat update
scripts\ansible-runner.bat models
scripts\ansible-runner.bat backup

# Remove auto-startup (if needed)
scripts\remove-windows-startup.bat
```

### Linux (including TrueNAS Scale)
```bash
# Setup (one-time)
chmod +x scripts/*.sh
./scripts/setup-homelab.sh

# Daily operations
./scripts/start-homelab.sh
./scripts/stop-homelab.sh

# MCP services
./scripts/start-mcp.sh

# Ansible automation
./scripts/ansible-runner.sh setup
./scripts/ansible-runner.sh health
./scripts/ansible-runner.sh update
./scripts/ansible-runner.sh models
./scripts/ansible-runner.sh backup
```

## 🔒 Security

- Network isolation with Docker networks
- API key management with environment variables
- Secure remote access via Cloudflare tunnel
- Regular security updates and monitoring

## 📊 Monitoring & Automation

- **Automated health checks** via Ansible playbooks
- **Service status monitoring** with cross-platform scripts
- **Automated updates** for containers and Ollama models
- **Resource usage tracking** and log aggregation
- **Cross-platform compatibility** for Windows and Linux

## 🔄 Migration from PowerShell

This homelab has been **completely migrated from PowerShell to cross-platform automation**:

- ✅ **No more PowerShell syntax errors** - All `.ps1` files replaced with cross-platform alternatives
- ✅ **Cross-platform scripts** - Works on Windows (`.bat`) and Linux (`.sh`)
- ✅ **Ansible automation** - More powerful than PowerShell for complex automation
- ✅ **TrueNAS Scale ready** - Easy migration path to Linux

See [MIGRATION-COMPLETE.md](MIGRATION-COMPLETE.md) for full details.

## 🤝 Contributing

This homelab is designed for personal use but contributions are welcome! Please see the documentation for detailed setup and maintenance procedures.

## 📞 Support

For issues and questions:
1. Check the [Troubleshooting Guide](docs/06-TROUBLESHOOTING.md)
2. Review the [Quick Reference](docs/10-REFERENCE.md)
3. Check the [Cross-Platform Setup Guide](CROSS-PLATFORM-SETUP.md)
4. Check service-specific documentation in the `docs/` folder
