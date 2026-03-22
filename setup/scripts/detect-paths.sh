#!/bin/bash
# detect-paths.sh - Auto-detect server paths and config
# Output: ~/.config/opencode/.paths (sourced by other scripts)

set -e

CONFIG_DIR="$HOME/.config/opencode"
PATHS_FILE="$CONFIG_DIR/.paths"

echo "=== Detecting System Paths ==="

# Detect hostname
SHORT_HOST=$(hostname)
FQDN=$(hostname -f 2>/dev/null || echo "${SHORT_HOST}.local")
IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")

# Detect home directory
HOME_DIR="$HOME"

# Detect user
CURRENT_USER=$(whoami)

# Detect OS
OS_TYPE=$(uname -s)
OS_VERSION=$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo "Unknown")

# Detect Docker
if command -v docker &> /dev/null; then
    DOCKER_AVAILABLE="true"
    DOCKER_VERSION=$(docker --version | awk '{print $3}' | tr -d ',')
else
    DOCKER_AVAILABLE="false"
    DOCKER_VERSION=""
fi

# Detect Python
if command -v python3 &> /dev/null; then
    PYTHON_AVAILABLE="true"
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
else
    PYTHON_AVAILABLE="false"
    PYTHON_VERSION=""
fi

# Docker directory (standard location)
DOCKER_DIR="$HOME/docker"

# OpenCode config directory
OPENCODE_DIR="$CONFIG_DIR"

# Output directory for generated files
OUTPUT_DIR="$CONFIG_DIR/docs/output"

# Create paths file
mkdir -p "$CONFIG_DIR"
cat > "$PATHS_FILE" << EOF
# OpenCode Starter Kit - Detected Paths
# Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
# DO NOT EDIT - Run detect-paths.sh to regenerate

# Server
SERVER_HOST="$SHORT_HOST"
SERVER_FQDN="$FQDN"
SERVER_IP="$IP_ADDRESS"

# User
HOME_DIR="$HOME_DIR"
CURRENT_USER="$CURRENT_USER"

# OS
OS_TYPE="$OS_TYPE"
OS_VERSION="$OS_VERSION"

# Docker
DOCKER_AVAILABLE="$DOCKER_AVAILABLE"
DOCKER_VERSION="$DOCKER_VERSION"
DOCKER_DIR="$DOCKER_DIR"

# Python
PYTHON_AVAILABLE="$PYTHON_AVAILABLE"
PYTHON_VERSION="$PYTHON_VERSION"

# OpenCode
OPENCODE_DIR="$OPENCODE_DIR"
OUTPUT_DIR="$OUTPUT_DIR"

# Ports (default, override if needed)
PORT_PORTAINER=9000
PORT_HOMEPAGE=8765
PORT_NEXTEXPLORER=8080
PORT_USERMEMOS=5232
PORT_OPENMEMORY_API=8081
PORT_OPENMEMORY_DASHBOARD=3006
EOF

echo ""
echo "=== Paths Detected ==="
echo "Server:      $SHORT_HOST ($IP_ADDRESS)"
echo "Home:        $HOME_DIR"
echo "Docker dir:  $DOCKER_DIR"
echo "OpenCode:    $OPENCODE_DIR"
echo ""
echo "Paths saved to: $PATHS_FILE"
echo ""
echo "Source this file in scripts:"
echo "  source ~/.config/opencode/.paths"
