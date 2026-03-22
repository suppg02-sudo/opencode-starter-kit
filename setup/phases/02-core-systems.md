# Phase 2: Core Systems

**Installs**: Selected core components
**Duration**: ~2-5 minutes

## Components

### agents-config
```bash
# User selects: minimal, standard, or full
# Default: standard
AGENTS_CHOICE="${AGENTS_CHOICE:-standard}"
cp "templates/AGENTS-${AGENTS_CHOICE}.md" ~/.config/opencode/AGENTS.md
echo "✓ AGENTS.md configured (${AGENTS_CHOICE})"
```

### skill-factory
```bash
setup/scripts/copy-skills.sh skill-factory
```

### openmemory-lite
```bash
# Deploy OpenMemory container
cp templates/docker/docker-compose.openmemory.yml ~/docker/
cd ~/docker && docker compose -f docker-compose.openmemory.yml up -d
sleep 20

# Configure MCP integration
python3 << 'PYTHON'
import json, os
config = json.load(open(os.path.expanduser("~/.config/opencode/opencode.json")))
if "mcp" not in config: config["mcp"] = {}
config["mcp"]["openmemory"] = {
    "type": "remote",
    "url": "http://localhost:8081/mcp",
    "headers": {"MCP-Token": "opencode-secret"},
    "enabled": True
}
json.dump(config, open(os.path.expanduser("~/.config/opencode/opencode.json"), "w"), indent=2)
PYTHON
```
**Access**: Dashboard at http://${SERVER_HOST}:3006

### tracking-system
```bash
setup/scripts/copy-skills.sh tracking
```

### opentelemetry
```bash
setup/scripts/copy-skills.sh opentelemetry
```

## Validate
- [ ] Selected core skills installed
- [ ] OpenMemory running (if selected): `curl http://localhost:8081/health`
- [ ] Dashboard accessible: http://${SERVER_HOST}:3006
