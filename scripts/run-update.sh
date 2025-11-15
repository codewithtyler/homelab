#!/bin/sh
# Cross-platform update runner for Docker cron scheduler
# This script runs the Ansible update playbook

# Don't use set -e so we can always write completion message

HOMELAB_DIR=${HOMELAB_DIR:-/workspace}
LOG_FILE=${LOG_FILE:-/logs/activity.log}
DEBUG_LOG=${DEBUG_LOG:-/logs/ansible-debug.log}
ANSIBLE_IMAGE=${ANSIBLE_IMAGE:-quay.io/ansible/ansible-runner:latest}

# Don't write header - just write completion message at the end

# Verify playbook exists before running
if [ ! -f "$HOMELAB_DIR/playbooks/update-services.yml" ]; then
    echo "ERROR! Playbook not found at: $HOMELAB_DIR/playbooks/update-services.yml" >> "$LOG_FILE"
    exit 1
fi

# Get the host path for the workspace by inspecting the scheduler container's mount
# The scheduler container mounts the host directory to /workspace
# We need to find the source of that mount to pass it to the Ansible container
HOST_WORKSPACE=$(docker inspect homelab-scheduler --format '{{json .Mounts}}' 2>/dev/null | grep -o '"Source":"[^"]*","Destination":"/workspace"' | grep -o '"Source":"[^"]*"' | cut -d'"' -f4 || echo "")

# If we couldn't get the host path, use the workspace path directly
# Docker should be able to resolve bind mounts from container paths on Linux
if [ -z "$HOST_WORKSPACE" ]; then
    HOST_WORKSPACE="$HOMELAB_DIR"
fi

# Run Ansible update playbook using Docker
# Redirect verbose output to debug log, keep activity.log clean
docker run --rm \
  -v "$HOST_WORKSPACE:/workspace" \
  -w /workspace \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  "$ANSIBLE_IMAGE" \
  ansible-playbook -i inventory.ini playbooks/update-services.yml >> "$DEBUG_LOG" 2>&1

EXIT_CODE=$?
TIMESTAMP=$(date '+%Y-%m-%d %I:%M %p')

# Always write completion message
# Check if playbook completed (has PLAY RECAP) even if exit code is non-zero
PLAYBOOK_COMPLETED=false
if [ -f "$DEBUG_LOG" ] && grep -qi "PLAY RECAP" "$DEBUG_LOG" 2>/dev/null; then
    PLAYBOOK_COMPLETED=true
fi

if [ "$PLAYBOOK_COMPLETED" = true ]; then
    # Playbook completed - check for updates (even if some services had API errors)
    if grep -qi "changed=1\|pulled" "$DEBUG_LOG" 2>/dev/null; then
        CHANGED_COUNT=$(grep -c "changed=1" "$DEBUG_LOG" 2>/dev/null || echo "0")
        if [ "$CHANGED_COUNT" -gt 0 ]; then
            SUMMARY="Updated $CHANGED_COUNT service(s)"
        else
            SUMMARY="No updates available"
        fi
    else
        SUMMARY="No updates available"
    fi
    echo "Update process completed at $TIMESTAMP - $SUMMARY" >> "$LOG_FILE"
else
    # Playbook didn't complete - extract error
    if [ -f "$DEBUG_LOG" ]; then
        ERROR_LINE=$(grep -i "fatal\|FAILED\|error" "$DEBUG_LOG" 2>/dev/null | grep -v "PLAY\|TASK\|404" | head -1)
        if [ -n "$ERROR_LINE" ]; then
            ERROR_MSG=$(echo "$ERROR_LINE" | sed 's/.*msg": "\([^"]*\)".*/\1/' | cut -c1-60)
            [ -z "$ERROR_MSG" ] && ERROR_MSG=$(echo "$ERROR_LINE" | cut -c1-60)
        else
            ERROR_MSG="Playbook execution failed"
        fi
    else
        ERROR_MSG="Playbook execution failed"
    fi
    echo "Update process completed at $TIMESTAMP - ERROR: $ERROR_MSG" >> "$LOG_FILE"
fi

