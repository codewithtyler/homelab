# Security Best Practices

## API Key Management

### Environment Variables
**Never commit sensitive data to version control**

```bash
# .env file (never commit)
N8N_USERNAME=your_username
N8N_PASSWORD=your_secure_password
COOLIFY_DB_PASSWORD=your_secure_db_password
APP_KEY=your_32_character_app_key
CLOUDFLARED_TUNNEL_TOKEN=your_tunnel_token

# mcp.env file (never commit)
TIKTOK_API_KEY=your_tiktok_api_key
TIKTOK_API_SECRET=your_tiktok_api_secret
YOUTUBE_API_KEY=your_youtube_api_key
TWITTER_API_KEY=your_twitter_api_key
```

### Secret Rotation
```bash
# Rotate API keys regularly
# Update .env and mcp.env files
# Restart affected services
docker-compose restart n8n
docker-compose -f docker-compose-mcp.yml restart
```

### Access Control
```bash
# Limit file permissions
chmod 600 .env
chmod 600 mcp.env

# Use environment-specific files
cp .env.example .env.production
cp mcp.env.example mcp.env.production
```

## Network Isolation

### Docker Networks
```bash
# Create isolated networks
docker network create intranet
docker network create mcp-network

# Verify network isolation
docker network inspect intranet
docker network inspect mcp-network
```

### Service Communication
```yaml
# Main stack uses intranet network
services:
  ollama:
    networks:
      - intranet
  open-webui:
    networks:
      - intranet
  n8n:
    networks:
      - intranet

# MCP stack uses mcp-network
services:
  tiktok-mcp:
    networks:
      - mcp-network
  youtube-mcp:
    networks:
      - mcp-network
```

### Firewall Configuration
```bash
# Windows Firewall rules
# Allow only necessary ports
netsh advfirewall firewall add rule name="Homelab Ollama" dir=in action=allow protocol=TCP localport=11434
netsh advfirewall firewall add rule name="Homelab Open-WebUI" dir=in action=allow protocol=TCP localport=5000
netsh advfirewall firewall add rule name="Homelab n8n" dir=in action=allow protocol=TCP localport=5678
netsh advfirewall firewall add rule name="Homelab Coolify" dir=in action=allow protocol=TCP localport=6000
```

## Authentication

### n8n Authentication
```bash
# Strong password requirements
N8N_PASSWORD=ComplexPassword123!@#

# Enable basic authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=SecurePassword123!@#
```

### Coolify Authentication
```bash
# Secure database credentials
COOLIFY_DB_PASSWORD=SecureDatabasePassword123!@#
APP_KEY=32_character_random_app_key_here
```

### MCP Service Authentication
```bash
# API key authentication
TIKTOK_API_KEY=your_secure_api_key
YOUTUBE_API_KEY=your_secure_api_key
TWITTER_API_KEY=your_secure_api_key
N8N_API_KEY=your_secure_api_key
```

## Data Protection

### Encryption at Rest
```bash
# Encrypt sensitive data directories
# Use BitLocker for Windows
# Use LUKS for Linux
```

### Encryption in Transit
```bash
# Use HTTPS for external access
# Cloudflare tunnel provides encryption
# Internal communication via Docker networks
```

### Backup Security
```bash
# Encrypt backups
tar -czf - ./data/ | gpg --symmetric --cipher-algo AES256 --output backup-$(date +%Y%m%d).tar.gz.gpg

# Decrypt backups
gpg --decrypt backup-20240101.tar.gz.gpg | tar -xzf -
```

## Access Control

### User Management
```bash
# Limit user access
# Use least privilege principle
# Regular access reviews
```

### Service Accounts
```bash
# Use dedicated service accounts
# Limit service permissions
# Monitor service access
```

### API Access
```bash
# Rate limiting
# API key rotation
# Access logging
```

## Monitoring and Logging

### Security Logging
```bash
# Monitor authentication attempts
docker-compose logs n8n | grep -i "auth"
docker-compose logs coolify | grep -i "login"

# Monitor API access
docker-compose -f docker-compose-mcp.yml logs | grep -i "api"
```

### Access Monitoring
```bash
# Monitor file access
# Monitor network access
# Monitor API usage
```

### Alerting
```bash
# Set up security alerts
# Monitor failed login attempts
# Monitor unusual activity
```

## Vulnerability Management

### Container Security
```bash
# Scan container images
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image ollama/ollama:latest

# Update base images regularly
docker-compose pull
```

### Dependency Management
```bash
# Keep dependencies updated
# Monitor security advisories
# Use dependency scanning tools
```

### Patch Management
```bash
# Regular security updates
# Test updates in development
# Apply updates during maintenance windows
```

## Network Security

### Cloudflare Tunnel Security
```bash
# Secure tunnel configuration
# Use strong tunnel tokens
# Monitor tunnel access
```

### Internal Network Security
```bash
# Network segmentation
# Service isolation
# Traffic monitoring
```

### External Access
```bash
# Limit external access
# Use VPN for remote access
# Monitor external connections
```

## Compliance

### Data Protection
```bash
# Follow GDPR requirements
# Implement data retention policies
# Regular data audits
```

### Security Standards
```bash
# Follow security best practices
# Regular security assessments
# Compliance monitoring
```

### Documentation
```bash
# Document security procedures
# Maintain security policies
# Regular security training
```

## Incident Response

### Security Incidents
```bash
# Incident response plan
# Security team contacts
# Escalation procedures
```

### Recovery Procedures
```bash
# Security incident recovery
# Data breach response
# Service restoration
```

### Post-Incident
```bash
# Incident analysis
# Security improvements
# Lessons learned
```

## Security Tools

### Vulnerability Scanning
```bash
# Container vulnerability scanning
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image ollama/ollama:latest

# Network vulnerability scanning
nmap -sV -sC localhost
```

### Security Monitoring
```bash
# Log monitoring
docker-compose logs | grep -i "error\|fail\|denied"

# Network monitoring
netstat -an | grep LISTEN
```

### Access Control
```bash
# User access monitoring
# Service access monitoring
# API access monitoring
```

## Security Checklist

### Initial Setup
- [ ] Strong passwords for all services
- [ ] API keys secured and rotated
- [ ] Network isolation configured
- [ ] Firewall rules implemented
- [ ] Encryption enabled

### Ongoing Maintenance
- [ ] Regular security updates
- [ ] Vulnerability scanning
- [ ] Access reviews
- [ ] Security monitoring
- [ ] Incident response testing

### Compliance
- [ ] Data protection measures
- [ ] Security documentation
- [ ] Regular security assessments
- [ ] Compliance monitoring
- [ ] Security training

## Security Resources

### Documentation
- [Docker Security](https://docs.docker.com/engine/security/)
- [n8n Security](https://docs.n8n.io/security/)
- [Coolify Security](https://coolify.io/docs/security)
- [Cloudflare Security](https://developers.cloudflare.com/security/)

### Tools
- [Trivy](https://trivy.dev/) - Container vulnerability scanner
- [Nmap](https://nmap.org/) - Network security scanner
- [OWASP ZAP](https://owasp.org/www-project-zap/) - Web application security scanner

### Best Practices
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [CIS Controls](https://www.cisecurity.org/controls/)
