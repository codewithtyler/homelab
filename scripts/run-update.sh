#!/bin/sh
# Cross-platform update runner for Docker cron scheduler
# This script runs the Ansible update playbook

set -e

HOMELAB_DIR=${HOMELAB_DIR:-/workspace}
LOG_FILE=${LOG_FILE:-/logs/activity.log}

echo "=== Homelab Update Process ===" >> "$LOG_FILE"
echo "Timestamp: $(date '+%Y-%m-%d %I:%M %p')" >> "$LOG_FILE"

# Run Ansible update playbook using Docker
docker run --rm \
  -v "$HOMELAB_DIR:/workspace" \
  -w /workspace \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  quay.io/ansible/ansible-runner:latest \
  ansible-playbook -i inventory.ini playbooks/update-services.yml >> "$LOG_FILE" 2>&1

EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    echo "Update failed with exit code $EXIT_CODE" >> "$LOG_FILE"
fi

echo "Update process completed at $(date '+%Y-%m-%d %I:%M %p')" >> "$LOG_FILE"

