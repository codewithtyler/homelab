# Stable Diffusion Setup Guide

## Overview

This guide covers setting up Automatic1111 Stable Diffusion WebUI in your homelab environment, optimized for RTX 3080 10GB GPU.

## Prerequisites

- **GPU**: NVIDIA RTX 3080 10GB (or compatible)
- **Docker**: With NVIDIA GPU support enabled
- **Storage**: 50-100GB free space for models
- **RAM**: 16GB+ recommended

## Quick Start

### 1. Automated Setup (Recommended)

```bash
# Download models and configure (30-60 minutes)
scripts\setup-stable-diffusion.bat

# Start Stable Diffusion
scripts\start-stable-diffusion.bat
```

### 2. Manual Setup

```bash
# Create directories
mkdir data\stable-diffusion\{models,outputs,loras,extensions,embeddings,controlnet}

# Start service
docker-compose up -d stable-diffusion
```

## Configuration

### Docker Service

The Stable Diffusion service is configured in `docker-compose.yml`:

```yaml
stable-diffusion:
  image: ghcr.io/automatic1111/stable-diffusion-webui:latest
  container_name: stable-diffusion
  ports:
    - "7860:7860"
  environment:
    - NVIDIA_VISIBLE_DEVICES=all
    - COMMANDLINE_ARGS=--api --listen --medvram --xformers --no-half-vae
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: ["gpu"]
  volumes:
    - ./data/stable-diffusion/models:/app/models
    - ./data/stable-diffusion/outputs:/app/outputs
    - ./data/stable-diffusion/loras:/app/loras
    - ./data/stable-diffusion/extensions:/app/extensions
    - ./data/stable-diffusion/embeddings:/app/embeddings
    - ./data/stable-diffusion/controlnet:/app/extensions/sd-webui-controlnet/models
  networks:
    - intranet
  restart: unless-stopped
```

### Command Line Arguments

- `--api`: Enables API for n8n integration
- `--listen`: Allows external connections
- `--medvram`: Optimizes for 10GB VRAM
- `--xformers`: Memory optimization
- `--no-half-vae`: Prevents VAE memory issues

## Models

### Included Models

**Realistic Vision v5.1 SDXL** (7GB)
- High-quality photorealistic images
- SDXL format (1024x1024)
- Optimized for RTX 3080 10GB

**ControlNet Models** (4.2GB total)
- **OpenPose**: Pose control and character positioning
- **Canny**: Edge detection and line art
- **Depth**: Depth map generation

### Adding Custom Models

1. **Checkpoints**: Place in `data/stable-diffusion/models/`
2. **LoRAs**: Place in `data/stable-diffusion/loras/`
3. **Embeddings**: Place in `data/stable-diffusion/embeddings/`
4. **ControlNet**: Place in `data/stable-diffusion/controlnet/`

## Performance

### RTX 3080 10GB Performance

**SDXL (1024x1024)**:
- Single image: 5-8 seconds
- Batch of 4: 15-20 seconds
- VRAM usage: 6-8GB

**SD 1.5 (512x512)**:
- Single image: 2-3 seconds
- Batch of 8: 10-15 seconds
- VRAM usage: 4-5GB

### Optimization Tips

1. **Use `--medvram`** for 10GB VRAM optimization
2. **Enable xformers** for memory efficiency
3. **Batch processing** for multiple images
4. **Lower resolution** for faster generation

## API Integration

### n8n Integration

```javascript
// Text-to-Image API call
const response = await fetch('http://stable-diffusion:7860/sdapi/v1/txt2img', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    prompt: "beautiful landscape, photorealistic",
    negative_prompt: "blurry, low quality",
    width: 1024,
    height: 1024,
    steps: 20,
    cfg_scale: 7.5,
    sampler_name: "DPM++ 2M Karras"
  })
});
```

### Available Endpoints

- **Text-to-Image**: `POST /sdapi/v1/txt2img`
- **Image-to-Image**: `POST /sdapi/v1/img2img`
- **ControlNet**: `POST /sdapi/v1/controlnet/detect`
- **Model Management**: `GET /sdapi/v1/sd-models`
- **API Documentation**: `http://localhost:7860/docs`

## Access Points

- **WebUI**: http://localhost:7860
- **API Docs**: http://localhost:7860/docs
- **Internal API**: http://stable-diffusion:7860 (from other containers)

## Troubleshooting

### Common Issues

**Container won't start**:
```bash
# Check logs
docker-compose logs stable-diffusion

# Restart service
docker-compose restart stable-diffusion
```

**GPU not detected**:
```bash
# Check GPU access
docker exec stable-diffusion nvidia-smi

# Verify Docker GPU support
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

**Out of memory errors**:
- Reduce batch size
- Lower image resolution
- Use `--lowvram` instead of `--medvram`

### Performance Issues

**Slow generation**:
- Check GPU utilization: `nvidia-smi`
- Verify xformers is working
- Check for memory leaks

**High VRAM usage**:
- Use `--medvram` flag
- Reduce batch size
- Close other GPU applications

## Maintenance

### Updates

```bash
# Update Stable Diffusion
docker-compose pull stable-diffusion
docker-compose up -d stable-diffusion
```

### Backups

**Important directories to backup**:
- `data/stable-diffusion/models/` - Checkpoint models
- `data/stable-diffusion/loras/` - LoRA models
- `data/stable-diffusion/embeddings/` - Text embeddings
- `data/stable-diffusion/outputs/` - Generated images

### Monitoring

```bash
# View logs
docker-compose logs -f stable-diffusion

# Check GPU usage
docker exec stable-diffusion nvidia-smi

# Monitor resource usage
docker stats stable-diffusion
```

## Integration with Homelab

### n8n Workflows

Stable Diffusion integrates seamlessly with your existing n8n workflows:

1. **Content Generation**: Generate images for social media
2. **Automation**: Batch process images
3. **API Integration**: Connect with other services

### Coolify Deployment

Deploy additional models and extensions through Coolify:

1. **Custom Models**: Upload new checkpoints
2. **Extensions**: Install additional features
3. **Scaling**: Deploy multiple instances

### Remotion Integration

Use generated images in video workflows:

1. **Background Images**: Generate scene backgrounds
2. **Character Assets**: Create consistent characters
3. **Style Consistency**: Maintain visual coherence

## Security Considerations

- **API Access**: Restrict API access to internal network
- **Model Storage**: Secure model files and outputs
- **Resource Limits**: Monitor GPU usage and memory
- **Updates**: Keep Stable Diffusion updated for security

## Next Steps

1. **Start the service**: `scripts\start-stable-diffusion.bat`
2. **Download models**: `scripts\setup-stable-diffusion.bat`
3. **Test generation**: Access http://localhost:7860
4. **Integrate with n8n**: Create automation workflows
5. **Explore API**: Check http://localhost:7860/docs

Your RTX 3080 10GB is perfectly optimized for professional Stable Diffusion workflows! 🚀

