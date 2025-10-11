# Scripts Directory

This directory contains all PowerShell and automation scripts for the Homelab system.

## Core Scripts

### Main Stack Management
- `../start.ps1` - Start main homelab stack
- `../check-docker.ps1` - Health check and auto-start
- `../update-containers.ps1` - Update specific containers
- `../pull-docker-images.ps1` - Bulk image updates
- `../pull-ollama-models.ps1` - Model synchronization

### MCP Stack Management
- `../start-mcp.ps1` - Start MCP services (conditional)
- `../docker-compose-mcp.yml` - MCP stack definition

### Automation System
- `../automated-updates.ps1` - Automated container updates
- `../docker-health-monitor.ps1` - Docker health monitoring
- `../setup-automation.ps1` - Complete automation setup
- `../setup-automated-updates.ps1` - Update system setup

### Management Scripts
- `../manage-homelab.ps1` - Comprehensive management
- `../monitor-homelab.ps1` - Real-time monitoring
- `../cleanup-homelab.ps1` - System cleanup

## File Organization

### Removed Files
The following files have been identified as duplicates or unnecessary:
- `start-mcp-original.ps1` - Duplicate of `start-mcp.ps1`
- `homelab-check.yml` - Ansible playbook (not needed for Windows)
- `inventory.ini` - Ansible inventory (not needed for Windows)
- `run-homelab-check.sh` - Bash script (not needed for Windows)
- `README-MCP.md` - Content moved to main documentation

### Directory Structure
```
homelab/
├── docs/                    # Comprehensive documentation
├── scripts/                 # Automation scripts (this directory)
├── data/                    # Persistent data
├── logs/                    # Automation logs
├── backups/                 # Backup files
├── docker-compose.yml       # Main stack
├── docker-compose-mcp.yml   # MCP stack
├── .env                     # Main environment
├── mcp.env                  # MCP environment
└── README.md                # Main documentation
```

## Usage

All scripts should be run from the homelab root directory:

```powershell
# Start services
.\start.ps1
.\start-mcp.ps1

# Management
.\manage-homelab.ps1 status
.\monitor-homelab.ps1

# Automation
.\setup-automation.ps1
.\automated-updates.ps1 -DryRun
```

## Maintenance

- Review logs regularly in `logs/` directory
- Test automation scripts monthly
- Update scripts as needed
- Clean up old files with `cleanup-homelab.ps1`
