# Cross-Platform Homelab Setup

This homelab setup is designed to work on both Windows and Linux (including TrueNAS Scale). All scripts are cross-platform compatible.

## Platform Support

### Windows
- **Batch files** (`.bat`) for Windows Command Prompt
- **WSL2** support for Linux compatibility
- **Docker Desktop** for container management

### Linux (including TrueNAS Scale)
- **Shell scripts** (`.sh`) for bash/zsh
- **Docker** for container management
- **Native Linux** compatibility

## Scripts Overview

### Cross-Platform Scripts

| Script | Windows | Linux | Purpose |
|--------|---------|-------|---------|
| `scripts/ansible-runner.bat` | ✅ | ❌ | Ansible automation (Windows) |
| `scripts/ansible-runner.sh` | ✅ (WSL) | ✅ | Ansible automation (Linux) |
| `scripts/start-homelab.bat` | ✅ | ❌ | Start all services (Windows) |
| `scripts/start-homelab.sh` | ✅ (WSL) | ✅ | Start all services (Linux) |
| `scripts/stop-homelab.bat` | ✅ | ❌ | Stop all services (Windows) |
| `scripts/stop-homelab.sh` | ✅ (WSL) | ✅ | Stop all services (Linux) |
| `scripts/start-mcp.bat` | ✅ | ❌ | Start MCP services (Windows) |
| `scripts/start-mcp.sh` | ✅ (WSL) | ✅ | Start MCP services (Linux) |

### Ansible Playbooks (Cross-Platform)

| Playbook | Purpose |
|----------|---------|
| `playbooks/site.yml` | Complete homelab setup |
| `playbooks/update-services.yml` | Automated service updates |
| `playbooks/health-check.yml` | Health monitoring |
| `playbooks/ollama-models.yml` | Ollama model management |
| `playbooks/backup.yml` | Backup system |

## Usage

### Windows

#### Manual Operations
```cmd
# Start all services
scripts\start-homelab.bat

# Stop all services
scripts\stop-homelab.bat

# Start MCP services only
scripts\start-mcp.bat
```

#### Ansible Automation
```cmd
# Complete setup
scripts\ansible-runner.bat setup

# Check for updates
scripts\ansible-runner.bat update

# Health check
scripts\ansible-runner.bat health

# Manage Ollama models
scripts\ansible-runner.bat models

# Create backup
scripts\ansible-runner.bat backup
```

### Linux (including TrueNAS Scale)

#### Manual Operations
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Start all services
./scripts/start-homelab.sh

# Stop all services
./scripts/stop-homelab.sh

# Start MCP services only
./scripts/start-mcp.sh
```

#### Ansible Automation
```bash
# Complete setup
./scripts/ansible-runner.sh setup

# Check for updates
./scripts/ansible-runner.sh update

# Health check
./scripts/ansible-runner.sh health

# Manage Ollama models
./scripts/ansible-runner.sh models

# Create backup
./scripts/ansible-runner.sh backup
```

## Migration from PowerShell

### What Was Replaced
- ❌ `start.ps1` → ✅ `scripts/start-homelab.bat` + `scripts/start-homelab.sh`
- ❌ `start-mcp.ps1` → ✅ `scripts/start-mcp.bat` + `scripts/start-mcp.sh`
- ❌ All automation scripts → ✅ Ansible playbooks

### Benefits
1. **Cross-platform compatibility** - Same functionality on Windows and Linux
2. **No PowerShell syntax issues** - Bash and batch files are more reliable
3. **Better automation** - Ansible is more powerful than PowerShell
4. **Easier maintenance** - Clean, readable scripts
5. **Future-proof** - Easy migration to TrueNAS Scale

## File Structure

```
homelab/
├── scripts/
│   ├── ansible-runner.bat      # Windows Ansible runner
│   ├── ansible-runner.sh        # Linux Ansible runner
│   ├── start-homelab.bat        # Windows startup
│   ├── start-homelab.sh         # Linux startup
│   ├── stop-homelab.bat         # Windows shutdown
│   ├── stop-homelab.sh          # Linux shutdown
│   ├── start-mcp.bat            # Windows MCP startup
│   └── start-mcp.sh             # Linux MCP startup
├── playbooks/
│   ├── site.yml                 # Main orchestration
│   ├── homelab-setup.yml        # Directory structure
│   ├── docker-setup.yml         # Docker environment
│   ├── deploy-services.yml      # Deploy main services
│   ├── deploy-mcp.yml           # Deploy MCP services
│   ├── update-services.yml      # Automated updates
│   ├── health-check.yml         # Health monitoring
│   ├── ollama-models.yml        # Ollama management
│   └── backup.yml               # Backup system
├── docker-compose.yml           # Main services
├── docker-compose-mcp.yml       # MCP services
├── mcp.env                      # Environment variables
├── inventory.ini                # Ansible inventory
└── ansible.cfg                  # Ansible configuration
```

## TrueNAS Scale Migration

When you're ready to migrate to TrueNAS Scale:

1. **Copy the entire homelab directory** to your TrueNAS Scale system
2. **Make scripts executable**: `chmod +x scripts/*.sh`
3. **Install Docker** (if not already installed)
4. **Run the setup**: `./scripts/ansible-runner.sh setup`
5. **Start services**: `./scripts/start-homelab.sh`

The same Ansible playbooks and shell scripts will work on TrueNAS Scale without any modifications.

## Troubleshooting

### Windows Issues
- **WSL not available**: The batch files will fall back to direct Docker commands
- **Docker not running**: Start Docker Desktop first
- **Permission issues**: Run Command Prompt as Administrator

### Linux Issues
- **Scripts not executable**: Run `chmod +x scripts/*.sh`
- **Docker not running**: Start Docker service with `sudo systemctl start docker`
- **Permission issues**: Use `sudo` for Docker commands if needed

### Cross-Platform Issues
- **Path separators**: Use `/` in scripts, Windows will handle the conversion
- **Environment variables**: Both platforms support the same `.env` files
- **Docker commands**: Identical across platforms

## Benefits of This Approach

1. **No PowerShell dependency** - Eliminates all syntax issues
2. **Cross-platform compatibility** - Same functionality everywhere
3. **Easy migration** - Simple copy to TrueNAS Scale
4. **Better automation** - Ansible is more powerful than PowerShell
5. **Maintainable** - Clean, readable scripts
6. **Future-proof** - Works on any Linux system
