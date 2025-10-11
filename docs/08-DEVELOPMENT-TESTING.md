# Development & Testing

## Local Development Setup

### Development Environment
```bash
# Clone repository
git clone <your-repo-url>
cd homelab

# Create development branch
git checkout -b development

# Set up development environment
cp .env.example .env.dev
cp mcp.env.example mcp.env.dev
```

### Development Configuration
```bash
# Development environment variables
# .env.dev
N8N_USERNAME=dev_user
N8N_PASSWORD=dev_password
COOLIFY_DB_NAME=coolify_dev
COOLIFY_DB_USER=coolify_dev
COOLIFY_DB_PASSWORD=dev_password
APP_KEY=dev_app_key_32_characters_long
CLOUDFLARED_TUNNEL_TOKEN=dev_tunnel_token
```

### Development Services
```bash
# Start development stack
docker-compose -f docker-compose.yml --env-file .env.dev up -d

# Start MCP development stack
docker-compose -f docker-compose-mcp.yml --env-file mcp.env.dev up -d
```

## Testing Changes Before Deployment

### Container Testing
```bash
# Test individual containers
docker-compose up -d ollama
docker-compose up -d open-webui
docker-compose up -d n8n

# Test with specific configurations
docker-compose -f docker-compose.yml --env-file .env.dev up -d
```

### Integration Testing
```bash
# Test service communication
docker exec ollama ping open-webui
docker exec n8n ping coolify

# Test API endpoints
curl http://localhost:11434/api/tags
curl http://localhost:5000
curl http://localhost:5678
```

### Performance Testing
```bash
# Test GPU access
docker exec ollama nvidia-smi
docker exec open-webui nvidia-smi

# Test resource usage
docker stats

# Test network performance
docker exec ollama ping -c 10 open-webui
```

## n8n Workflow Development

### Workflow Development Process
1. **Design**: Plan workflow logic and nodes
2. **Develop**: Create workflow in n8n interface
3. **Test**: Test with sample data
4. **Deploy**: Activate workflow
5. **Monitor**: Monitor execution and performance

### Development Workflows
```javascript
// Example development workflow
{
  "name": "Development Test Workflow",
  "nodes": [
    {
      "name": "Start",
      "type": "n8n-nodes-base.start",
      "parameters": {}
    },
    {
      "name": "Test Function",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "// Development test code\nreturn { test: 'success' };"
      }
    },
    {
      "name": "Log Result",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "console.log('Test result:', $input.first().json);\nreturn $input.first().json;"
      }
    }
  ]
}
```

### Testing Workflows
```javascript
// Example testing workflow
{
  "name": "API Test Workflow",
  "nodes": [
    {
      "name": "HTTP Request",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://localhost:11434/api/tags",
        "method": "GET"
      }
    },
    {
      "name": "Validate Response",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "const response = $input.first().json;\nif (!response.models) {\n  throw new Error('Invalid response format');\n}\nreturn response;"
      }
    }
  ]
}
```

## Custom Integrations

### Custom MCP Services
```javascript
// Example custom MCP service
const express = require('express');
const app = express();

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/custom', (req, res) => {
  res.json({ message: 'Custom MCP service' });
});

app.listen(3000, () => {
  console.log('Custom MCP service running on port 3000');
});
```

### Custom n8n Nodes
```javascript
// Example custom n8n node
module.exports = {
  name: 'CustomNode',
  description: 'Custom node for homelab',
  version: '1.0.0',
  nodeDefaults: {
    name: 'Custom Node',
    color: '#1f77b4',
  },
  properties: [
    {
      displayName: 'Input',
      name: 'input',
      type: 'string',
      default: '',
    },
    {
      displayName: 'Output',
      name: 'output',
      type: 'string',
      default: '',
    },
  ],
  execute: async function (context) {
    const input = context.getNodeParameter('input', 0);
    const output = `Processed: ${input}`;
    return [{ json: { output } }];
  },
};
```

## Debugging Techniques

### Container Debugging
```bash
# Access container shell
docker exec -it ollama sh
docker exec -it open-webui sh
docker exec -it n8n sh

# Check container logs
docker logs ollama
docker logs open-webui
docker logs n8n

# Monitor container resources
docker stats ollama open-webui n8n
```

### Service Debugging
```bash
# Test Ollama API
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "llama3.1:8b", "prompt": "Hello, world!"}'

# Test Open-WebUI API
curl http://localhost:5000/api/v1/models

# Test n8n API
curl -u username:password http://localhost:5678/api/v1/workflows
```

### Network Debugging
```bash
# Check network connectivity
docker exec ollama ping open-webui
docker exec n8n ping coolify

# Check DNS resolution
docker exec ollama nslookup open-webui
docker exec n8n nslookup coolify

# Check port accessibility
docker exec ollama netstat -tlnp
docker exec n8n netstat -tlnp
```

## Development Tools

### Code Editors
- **VS Code**: Recommended with Docker extension
- **IntelliJ IDEA**: Full-featured IDE
- **Vim/Neovim**: Lightweight editor

### Development Extensions
```json
{
  "recommendations": [
    "ms-vscode.vscode-docker",
    "ms-vscode.powershell",
    "ms-python.python",
    "ms-vscode.vscode-json"
  ]
}
```

### Development Scripts
```bash
# Development startup script
# dev-start.ps1
Write-Host "Starting development environment..." -ForegroundColor Green

# Start development stack
docker-compose -f docker-compose.yml --env-file .env.dev up -d

# Start MCP development stack
docker-compose -f docker-compose-mcp.yml --env-file mcp.env.dev up -d

Write-Host "Development environment started!" -ForegroundColor Green
```

## Testing Strategies

### Unit Testing
```javascript
// Example unit test for custom function
describe('Custom Function', () => {
  test('should process input correctly', () => {
    const input = 'test input';
    const result = processInput(input);
    expect(result).toBe('Processed: test input');
  });
});
```

### Integration Testing
```bash
# Test service integration
# test-integration.ps1
Write-Host "Testing service integration..." -ForegroundColor Green

# Test Ollama
$ollamaResponse = Invoke-RestMethod -Uri "http://localhost:11434/api/tags"
if ($ollamaResponse.models) {
    Write-Host "✓ Ollama is working" -ForegroundColor Green
} else {
    Write-Host "✗ Ollama is not working" -ForegroundColor Red
}

# Test Open-WebUI
$webuiResponse = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing
if ($webuiResponse.StatusCode -eq 200) {
    Write-Host "✓ Open-WebUI is working" -ForegroundColor Green
} else {
    Write-Host "✗ Open-WebUI is not working" -ForegroundColor Red
}
```

### End-to-End Testing
```bash
# Test complete workflow
# test-e2e.ps1
Write-Host "Testing end-to-end workflow..." -ForegroundColor Green

# Test Ollama model
$modelResponse = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method POST -ContentType "application/json" -Body '{"model": "llama3.1:8b", "prompt": "Hello, world!"}'
if ($modelResponse.response) {
    Write-Host "✓ Model is working" -ForegroundColor Green
} else {
    Write-Host "✗ Model is not working" -ForegroundColor Red
}
```

## Deployment Strategies

### Development to Production
```bash
# Development testing
docker-compose -f docker-compose.yml --env-file .env.dev up -d

# Production deployment
docker-compose -f docker-compose.yml --env-file .env up -d
```

### Blue-Green Deployment
```bash
# Blue environment (current)
docker-compose -f docker-compose.yml up -d

# Green environment (new)
docker-compose -f docker-compose-green.yml up -d

# Switch traffic
# Update load balancer configuration
# Shutdown blue environment
docker-compose -f docker-compose.yml down
```

### Rolling Updates
```bash
# Update individual services
docker-compose up -d --no-deps ollama
docker-compose up -d --no-deps open-webui
docker-compose up -d --no-deps n8n
```

## Performance Optimization

### Container Optimization
```yaml
# Optimize container resources
services:
  ollama:
    deploy:
      resources:
        limits:
          memory: 8G
          cpus: '4.0'
        reservations:
          memory: 4G
          cpus: '2.0'
```

### Database Optimization
```sql
-- Optimize PostgreSQL
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
SELECT pg_reload_conf();
```

### Network Optimization
```bash
# Optimize Docker networks
docker network create --driver bridge --opt com.docker.network.bridge.name=intranet intranet
docker network create --driver bridge --opt com.docker.network.bridge.name=mcp-network mcp-network
```

## Monitoring and Observability

### Application Monitoring
```bash
# Monitor application performance
docker exec ollama top
docker exec open-webui top
docker exec n8n top
```

### Log Aggregation
```bash
# Aggregate logs
docker-compose logs > homelab-logs-$(date +%Y%m%d).txt
docker-compose -f docker-compose-mcp.yml logs >> homelab-logs-$(date +%Y%m%d).txt
```

### Metrics Collection
```bash
# Collect metrics
docker stats --no-stream > metrics-$(date +%Y%m%d).txt
nvidia-smi >> metrics-$(date +%Y%m%d).txt
```

## Best Practices

### Development Workflow
1. **Plan**: Design changes and test cases
2. **Develop**: Implement changes in development environment
3. **Test**: Run comprehensive tests
4. **Review**: Code review and quality checks
5. **Deploy**: Deploy to production environment
6. **Monitor**: Monitor production performance

### Code Quality
- **Linting**: Use code linters for quality
- **Formatting**: Consistent code formatting
- **Documentation**: Comprehensive code documentation
- **Testing**: Comprehensive test coverage

### Security
- **Secrets**: Never commit secrets to version control
- **Access**: Limit access to development environment
- **Updates**: Keep dependencies updated
- **Monitoring**: Monitor for security issues
