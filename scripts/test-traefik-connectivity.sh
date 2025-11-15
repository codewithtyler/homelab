#!/bin/bash
# Script to test connectivity from Linux host to Windows services
# Usage: ./scripts/test-traefik-connectivity.sh <windows-ip>

WINDOWS_IP="${1:-}"

if [ -z "$WINDOWS_IP" ]; then
    echo "Usage: $0 <windows-ip>"
    echo "Example: $0 192.168.1.100"
    exit 1
fi

echo "Testing connectivity to Windows host: $WINDOWS_IP"
echo "================================================"

# Test ports
PORTS=(
    "5000:Open WebUI"
    "7860:Stable Diffusion"
    "4000:Remotion"
    "11434:Ollama"
)

for port_info in "${PORTS[@]}"; do
    IFS=':' read -r port service <<< "$port_info"
    echo -n "Testing $service (port $port)... "
    
    if timeout 2 bash -c "echo > /dev/tcp/$WINDOWS_IP/$port" 2>/dev/null; then
        echo "✓ OK"
    else
        echo "✗ FAILED"
    fi
done

echo ""
echo "If any tests failed, check:"
echo "1. Windows firewall allows connections from this host"
echo "2. Windows services are running (docker ps on Windows)"
echo "3. IP address is correct"

