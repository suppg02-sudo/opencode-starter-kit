#!/bin/bash
# setup-openmemory.sh - Deploy and configure OpenMemory Lite

set -e

# Source detected paths
source "$HOME/.config/opencode/.paths" 2>/dev/null || {
    echo "Run detect-paths.sh first"
    exit 1
}

echo "=== Setting Up OpenMemory Lite ==="

OM_DIR="$DOCKER_DIR"
OM_COMPOSE=docker-compose.openmemory.yml
OM_API_KEY="${OM_API_KEY:-opencode-secret}"

# Copy compose file
echo "Copying docker-compose config..."
cp "$(dirname "$0")/../templates/docker/docker-compose.openmemory.yml" "$OM_DIR/$OM_COMPOSE"

# Create .env if not exists
if [ ! -f "$OM_DIR/.env" ]; then
    echo "OM_API_KEY=$OM_API_KEY" > "$OM_DIR/.env"
fi

# Start container
echo "Starting OpenMemory container..."
cd "$OM_DIR" && docker compose -f "$OM_COMPOSE" up -d

# Wait for startup
echo "Waiting for OpenMemory to start..."
sleep 20

# Health check
echo "Checking health..."
if curl -sf http://localhost:8081/health > /dev/null 2>&1; then
    echo "✓ OpenMemory API is healthy"
else
    echo "! OpenMemory health check failed - check logs: docker logs openmemory"
fi

# Configure MCP in opencode.json
echo "Configuring OpenCode MCP integration..."
OPencode_CONFIG="$HOME/.config/opencode/opencode.json"

if [ -f "$OPencode_CONFIG" ]; then
    # Backup existing config
    cp "$OPencode_CONFIG" "$OPencode_CONFIG.backup.$(date +%Y%m%d%H%M%S)"
    
    # Add OpenMemory MCP config using python
    python3 << 'PYTHON'
import json
import os

config_path = os.path.expanduser("~/.config/opencode/opencode.json")
config = json.load(open(config_path))

if "mcp" not in config:
    config["mcp"] = {}

config["mcp"]["openmemory"] = {
    "type": "remote",
    "url": "http://localhost:8081/mcp",
    "headers": {
        "MCP-Token": os.environ.get("OM_API_KEY", "opencode-secret")
    },
    "enabled": True
}

json.dump(config, open(config_path, "w"), indent=2)
print("✓ MCP configured")
PYTHON
else
    echo "! opencode.json not found - configure MCP manually"
fi

# Summary
echo ""
echo "=== OpenMemory Lite Setup Complete ==="
echo ""
echo "Access:"
echo "  Dashboard: http://$SERVER_HOST:$PORT_OPENMEMORY_DASHBOARD"
echo "  API:       http://$SERVER_HOST:$PORT_OPENMEMORY_API"
echo ""
echo "MCP Tools available:"
echo "  - openmemory_store    (save memories)"
echo "  - openmemory_query    (search memories)"
echo "  - openmemory_list     (list recent)"
echo "  - openmemory_reinforce (boost importance)"
echo ""
echo "Usage: Type 'mem' to access memory gateway"
