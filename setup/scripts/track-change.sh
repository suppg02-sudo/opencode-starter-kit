#!/bin/bash
# track-change.sh - Track changes for rollback support
# Usage: track-change.sh <type> <value>
# Types: file, container, package, config

set -e

OPENCODE_DIR="$HOME/.config/opencode"
ROLLBACK_FILE="$OPENCODE_DIR/.rollback.json"

TYPE=$1
VALUE=$2

if [[ -z "$TYPE" || -z "$VALUE" ]]; then
    echo "Usage: track-change.sh <file|container|package|config> <value>"
    exit 1
fi

# Initialize rollback file if not exists
if [[ ! -f "$ROLLBACK_FILE" ]]; then
    cat > "$ROLLBACK_FILE" << 'EOF'
{
  "timestamp": "",
  "files_created": [],
  "containers_started": [],
  "packages_installed": [],
  "configs_modified": []
}
EOF
fi

# Update timestamp
python3 << PYTHON
import json
from datetime import datetime

with open("$ROLLBACK_FILE", "r") as f:
    data = json.load(f)

data["timestamp"] = datetime.utcnow().isoformat() + "Z"

# Map type to key
type_map = {
    "file": "files_created",
    "container": "containers_started",
    "package": "packages_installed",
    "config": "configs_modified"
}

key = type_map.get("$TYPE", "$TYPE")
if key not in data:
    data[key] = []

if "$VALUE" not in data[key]:
    data[key].append("$VALUE")

with open("$ROLLBACK_FILE", "w") as f:
    json.dump(data, f, indent=2)

print(f"Tracked: $TYPE -> $VALUE")
PYTHON
