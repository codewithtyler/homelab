# Ansible Setup for Homelab Automation

This document explains how to set up and use Ansible for automating your homelab instead of PowerShell scripts.

## Why Ansible?

- ✅ **No PowerShell syntax issues** - YAML is much more reliable
- ✅ **Cross-platform** - Same playbooks work on Windows and Linux
- ✅ **Better Docker integration** - Native Docker modules
- ✅ **Idempotent operations** - Safe to run multiple times
- ✅ **Better error handling** - Clear, readable error messages
- ✅ **Easier maintenance** - Clean, readable configuration

## Setup Options

### Option 1: Docker (Recommended)
```powershell
# Run the setup script
.\scripts\setup-ansible.ps1 -UseDocker

# Use Ansible
.\scripts\ansible-runner.bat setup
```

### Option 2: WSL2
```powershell
# Run the setup script
.\scripts\setup-ansible.ps1 -UseWSL

# Use Ansible
wsl ansible-playbook -i inventory.ini playbooks/site.yml
```

### Option 3: Python on Windows
```powershell
# Run the setup script
.\scripts\setup-ansible.ps1

# Use Ansible
ansible-playbook -i inventory.ini playbooks/site.yml
```

## Available Playbooks

### Main Operations
- **`playbooks/site.yml`** - Complete homelab setup
- **`playbooks/update-services.yml`** - Check for and apply updates
- **`playbooks/health-check.yml`** - Health monitoring and diagnostics
- **`playbooks/ollama-models.yml`** - Manage Ollama models
- **`playbooks/backup.yml`** - Backup homelab data

### Individual Components
- **`playbooks/homelab-setup.yml`** - Directory structure and prerequisites
- **`playbooks/docker-setup.yml`** - Docker environment setup
- **`playbooks/deploy-services.yml`** - Deploy main services
- **`playbooks/deploy-mcp.yml`** - Deploy MCP services with API validation
- **`playbooks/monitoring-setup.yml`** - Set up monitoring scripts

## Usage Examples

### Initial Setup
```bash
# Complete homelab setup
.\scripts\ansible-runner.bat setup
```

### Daily Operations
```bash
# Check for updates
.\scripts\ansible-runner.bat update

# Health check
.\scripts\ansible-runner.bat health

# Manage Ollama models
.\scripts\ansible-runner.bat models

# Create backup
.\scripts\ansible-runner.bat backup
```

### Manual Operations
```bash
# Deploy specific services
docker run -it --rm -v "%CD%:/workspace" -w /workspace ansible/ansible-runner:latest ansible-playbook -i inventory.ini playbooks/deploy-services.yml

# Deploy MCP services only
docker run -it --rm -v "%CD%:/workspace" -w /workspace ansible/ansible-runner:latest ansible-playbook -i inventory.ini playbooks/deploy-mcp.yml
```

## Configuration

### Inventory (`inventory.ini`)
- Defines homelab hosts and variables
- Configurable ports, schedules, and service versions
- Easy to modify for different environments

### Ansible Configuration (`ansible.cfg`)
- Optimized for homelab use
- Better output formatting
- Proper privilege escalation

## Automation Schedule

The setup script creates Windows scheduled tasks:

- **Daily Updates**: 3:00 AM - Checks for and applies updates
- **Health Monitoring**: Every 15 minutes - Monitors service health
- **Automatic Restart**: Unhealthy services are automatically restarted

## Benefits Over PowerShell

### 1. **Reliability**
- No syntax errors with YAML
- Consistent behavior across runs
- Better error handling

### 2. **Maintainability**
- Clear, readable configuration
- Modular playbook structure
- Easy to extend and modify

### 3. **Cross-Platform**
- Same playbooks work on Windows and Linux
- Easy migration to TrueNAS Scale
- Consistent automation across platforms

### 4. **Docker Integration**
- Native Docker modules
- Better container lifecycle management
- Built-in health checks

### 5. **Scheduling**
- Works with Windows Task Scheduler
- Works with Linux cron
- Works with Docker containers

## Migration from PowerShell

### What Gets Replaced
- ❌ `automated-updates.ps1` → ✅ `playbooks/update-services.yml`
- ❌ `docker-health-monitor.ps1` → ✅ `playbooks/health-check.yml`
- ❌ `pull-ollama-models.ps1` → ✅ `playbooks/ollama-models.yml`
- ❌ `pull-docker-images.ps1` → ✅ `playbooks/docker-setup.yml`
- ❌ `start-mcp.ps1` → ✅ `playbooks/deploy-mcp.yml`
- ❌ `check-docker.ps1` → ✅ `playbooks/health-check.yml`

### What Stays
- ✅ `docker-compose.yml` - Service definitions
- ✅ `docker-compose-mcp.yml` - MCP service definitions
- ✅ `mcp.env` - Environment variables
- ✅ `data/` - Persistent data

## Troubleshooting

### Common Issues

1. **Docker not running**
   ```bash
   # Check Docker status
   docker info

   # Start Docker if needed
   # Windows: Start Docker Desktop
   # Linux: systemctl start docker
   ```

2. **Permission issues**
   ```bash
   # Run as administrator (Windows)
   # Or use sudo (Linux)
   ```

3. **Network issues**
   ```bash
   # Check if services are accessible
   curl http://localhost:5000
   curl http://localhost:5678
   ```

### Logs
- Health reports: `logs/health-report-YYYY-MM-DD.txt`
- Ansible logs: `logs/ansible-*.log`
- Service logs: `docker-compose logs`

## Next Steps

1. **Run initial setup**: `.\scripts\ansible-runner.bat setup`
2. **Test health check**: `.\scripts\ansible-runner.bat health`
3. **Test updates**: `.\scripts\ansible-runner.bat update`
4. **Verify scheduling**: Check Windows Task Scheduler
5. **Monitor logs**: Check `logs/` directory

## Support

- Check `docs/12-TROUBLESHOOTING-HISTORY.md` for known issues
- Review playbook logs for detailed error information
- Use `ansible-playbook` with `-v` flag for verbose output
