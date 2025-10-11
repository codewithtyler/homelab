#!/bin/bash
# Cross-platform Ansible Runner for Homelab
# This script runs Ansible playbooks using Docker

HOMELAB_DIR=$(pwd)
ANSIBLE_IMAGE="quay.io/ansible/ansible-runner:latest"

# Function to run Ansible playbook
run_playbook() {
    local playbook=$1
    shift

    echo "Running playbook: $playbook"
    docker run --rm \
        -v "$HOMELAB_DIR:/workspace" \
        -w /workspace \
        --network host \
        $ANSIBLE_IMAGE \
        ansible-playbook -i inventory.ini "playbooks/$playbook" "$@"
}

# Main logic
case "$1" in
    "setup")
        run_playbook "site.yml"
        ;;
    "update")
        run_playbook "update-services.yml"
        ;;
    "health")
        run_playbook "health-check.yml"
        ;;
    "models")
        run_playbook "ollama-models.yml"
        ;;
    "backup")
        run_playbook "backup.yml"
        ;;
    *)
        echo "Usage: $0 {setup|update|health|models|backup}"
        exit 1
        ;;
esac
