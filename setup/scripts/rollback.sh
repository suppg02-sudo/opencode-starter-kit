#!/bin/bash
# rollback.sh - Undo changes made during installation
# Usage: rollback.sh [--dry-run]

set -e

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

OPENCODE_DIR="$HOME/.config/opencode"
ROLLBACK_FILE="$OPENCODE_DIR/.rollback.json"
BACKUP_DIR="$OPENCODE_DIR/backups/rollback-$(date +%Y%m%d-%H%M%S)"

echo "=== OpenCode Rollback ==="
echo ""

if [[ ! -f "$ROLLBACK_FILE" ]]; then
    echo "No rollback data found."
    echo "This typically means:"
    echo "  - Installation completed successfully"
    echo "  - Rollback was already performed"
    echo "  - Manual cleanup was done"
    exit 0
fi

echo "Rollback file: $ROLLBACK_FILE"
echo ""

# Read rollback data
FILES_CREATED=$(python3 -c "import json; d=json.load(open('$ROLLBACK_FILE')); print(' '.join(d.get('files_created', [])))" 2>/dev/null || echo "")
CONTAINERS_STOPPED=$(python3 -c "import json; d=json.load(open('$ROLLBACK_FILE')); print(' '.join(d.get('containers_stopped', [])))" 2>/dev/null || echo "")
PACKAGES_INSTALLED=$(python3 -c "import json; d=json.load(open('$ROLLBACK_FILE')); print(' '.join(d.get('packages_installed', [])))" 2>/dev/null || echo "")

echo "This will:"
echo ""

# Files to remove
if [[ -n "$FILES_CREATED" ]]; then
    echo "Remove files/directories:"
    for f in $FILES_CREATED; do
        if [[ -e "$f" ]]; then
            echo "  - $f"
        fi
    done
    echo ""
fi

# Containers to stop
if [[ -n "$CONTAINERS_STOPPED" ]]; then
    echo "Stop containers:"
    for c in $CONTAINERS_STOPPED; do
        echo "  - $c"
    done
    echo ""
fi

if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] No changes made."
    exit 0
fi

# Confirm
read -p "Proceed with rollback? (y/N) " confirm
[[ "$confirm" != "y" ]] && echo "Cancelled." && exit 0

echo ""
echo "Rolling back..."

# Create backup before rollback
mkdir -p "$BACKUP_DIR"
cp "$ROLLBACK_FILE" "$BACKUP_DIR/" 2>/dev/null || true

# Remove files
if [[ -n "$FILES_CREATED" ]]; then
    echo "Removing files..."
    for f in $FILES_CREATED; do
        if [[ -e "$f" ]]; then
            rm -rf "$f"
            echo "  Removed: $f"
        fi
    done
fi

# Stop containers
if [[ -n "$CONTAINERS_STOPPED" ]]; then
    echo "Stopping containers..."
    for c in $CONTAINERS_STOPPED; do
        docker stop "$c" 2>/dev/null && docker rm "$c" 2>/dev/null
        echo "  Stopped: $c"
    done
fi

# Remove rollback file
rm -f "$ROLLBACK_FILE"

echo ""
echo "✓ Rollback complete"
echo "Backup saved to: $BACKUP_DIR"
