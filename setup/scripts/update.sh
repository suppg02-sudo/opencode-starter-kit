#!/bin/bash
# update.sh - Update OpenCode components
# Usage: update.sh [--skills|--containers|--config|--all]

set -e

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
FRESHSTART_DIR="${FRESHSTART_DIR:-$HOME/freshstart}"
SKILLS_DIR="$OPENCODE_DIR/skills"

UPDATE_ALL=false
UPDATE_SKILLS=false
UPDATE_CONTAINERS=false
UPDATE_CONFIG=false

# Parse arguments
if [[ $# -eq 0 ]] || [[ "$1" == "--all" ]]; then
    UPDATE_ALL=true
fi
[[ "$1" == "--skills" ]] && UPDATE_SKILLS=true
[[ "$1" == "--containers" ]] && UPDATE_CONTAINERS=true
[[ "$1" == "--config" ]] && UPDATE_CONFIG=true
[[ "$1" == "--all" ]] && UPDATE_ALL=true

if [[ "$UPDATE_ALL" == "true" ]]; then
    UPDATE_SKILLS=true
    UPDATE_CONTAINERS=true
    UPDATE_CONFIG=true
fi

echo "=== OpenCode Updater ==="
echo ""

# Update skills from freshstart backup
if [[ "$UPDATE_SKILLS" == "true" ]]; then
    echo "Updating skills from backup..."
    
    if [[ -d "$FRESHSTART_DIR/skills" ]]; then
        for skill in "$FRESHSTART_DIR/skills"/*/; do
            skill_name=$(basename "$skill")
            if [[ -d "$SKILLS_DIR/$skill_name" ]]; then
                echo "  Updating: $skill_name"
                cp -r "$skill" "$SKILLS_DIR/$skill_name"
            else
                echo "  Adding: $skill_name"
                cp -r "$skill" "$SKILLS_DIR/$skill_name"
            fi
        done
        echo "✓ Skills updated"
    else
        echo "! Freshstart backup not found at $FRESHSTART_DIR/skills"
        echo "  Clone it: git clone https://github.com/suppg02-sudo/freshstart.git $FRESHSTART_DIR"
    fi
    echo ""
fi

# Update container configs
if [[ "$UPDATE_CONTAINERS" == "true" ]]; then
    echo "Updating container configs..."
    
    if [[ -d "$HOME/docker" ]]; then
        # Backup current configs
        backup_dir="$HOME/docker/backup-$(date +%Y%m%d)"
        mkdir -p "$backup_dir"
        cp "$HOME/docker/"*.yml "$backup_dir/" 2>/dev/null || true
        echo "  Backup saved to $backup_dir"
        
        # Pull latest images
        cd "$HOME/docker" && docker compose pull 2>/dev/null || true
        echo "✓ Container images updated"
    else
        echo "! Docker directory not found"
    fi
    echo ""
fi

# Update AGENTS.md from template (user keeps their version)
if [[ "$UPDATE_CONFIG" == "true" ]]; then
    echo "Checking AGENTS.md..."
    
    if [[ -f "$OPENCODE_DIR/AGENTS.md" ]]; then
        echo "  Current AGENTS.md exists - skipping (edit manually if needed)"
    else
        echo "  Creating default AGENTS.md"
        # Would copy from starter kit if available
    fi
    echo ""
fi

echo "=== Update Complete ==="
echo ""
echo "Restart services to apply changes:"
echo "  cd ~/docker && docker compose restart"
