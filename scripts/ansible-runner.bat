@echo off
REM Cross-platform Ansible Runner for Homelab
REM This script runs Ansible playbooks using Docker

REM Check if WSL is available
where wsl >nul 2>&1
if %errorlevel% equ 0 (
    REM Use WSL to run the shell script
    wsl bash scripts/ansible-runner.sh %*
) else (
    REM Fallback to direct Docker commands
    set HOMELAB_DIR=%CD%
    set ANSIBLE_IMAGE=quay.io/ansible/ansible-runner:latest

    if "%1"=="setup" (
        echo Running homelab setup...
        docker run --rm -v "%HOMELAB_DIR%:/workspace" -w /workspace --network host %ANSIBLE_IMAGE% ansible-playbook -i inventory.ini playbooks/site.yml
    ) else if "%1"=="update" (
        echo Running service updates...
        docker run --rm -v "%HOMELAB_DIR%:/workspace" -w /workspace --network host %ANSIBLE_IMAGE% ansible-playbook -i inventory.ini playbooks/update-services.yml
    ) else if "%1"=="health" (
        echo Running health check...
        docker run --rm -v "%HOMELAB_DIR%:/workspace" -w /workspace --network host %ANSIBLE_IMAGE% ansible-playbook -i inventory.ini playbooks/health-check.yml
    ) else if "%1"=="models" (
        echo Managing Ollama models...
        docker run --rm -v "%HOMELAB_DIR%:/workspace" -w /workspace --network host %ANSIBLE_IMAGE% ansible-playbook -i inventory.ini playbooks/ollama-models.yml
    ) else if "%1"=="backup" (
        echo Creating backup...
        docker run --rm -v "%HOMELAB_DIR%:/workspace" -w /workspace --network host %ANSIBLE_IMAGE% ansible-playbook -i inventory.ini playbooks/backup.yml
    ) else (
        echo Usage: %0 {setup^|update^|health^|models^|backup}
        exit /b 1
    )
)
