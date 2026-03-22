#!/bin/bash
# check-prereqs.sh - Verify and install prerequisites

echo "=== Checking Prerequisites ==="

# Docker
if command -v docker &> /dev/null; then
    echo "✓ Docker: $(docker --version)"
else
    echo "✗ Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    echo "✓ Docker installed (restart shell for group changes)"
fi

# Python3
if command -v python3 &> /dev/null; then
    echo "✓ Python3: $(python3 --version)"
else
    echo "✗ Installing Python3..."
    sudo apt update && sudo apt install -y python3 python3-pip
fi

# Git
if command -v git &> /dev/null; then
    echo "✓ Git: $(git --version)"
else
    echo "✗ Installing Git..."
    sudo apt install -y git
fi

# jq (recommended)
if command -v jq &> /dev/null; then
    echo "✓ jq installed"
else
    echo "! Installing jq (recommended)..."
    sudo apt install -y jq
fi

# Create directories
echo "Creating directories..."
mkdir -p ~/.config/opencode/{skills,scripts,context,docs}
mkdir -p ~/docker

echo ""
echo "=== Prerequisites Complete ==="
