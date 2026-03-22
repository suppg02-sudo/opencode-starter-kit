#!/bin/bash
# restore.sh - Restore OpenCode from backup
# Usage: restore.sh <backup-file.tar.gz>

set -e

BACKUP_FILE=$1

if [[ -z "$BACKUP_FILE" ]]; then
    echo "Usage: restore.sh <backup-file.tar.gz>"
    echo ""
    echo "Available backups:"
    ls -lh ~/opencode-backup-*.tar.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
DOCKER_DIR="${DOCKER_DIR:-$HOME/docker}"
RESTORE_DIR="/tmp/opencode-restore-$$"

echo "=== OpenCode Restore ==="
echo ""
echo "Backup file: $BACKUP_FILE"
echo ""

# Extract backup
echo "Extracting backup..."
mkdir -p "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

# Find extracted directory
EXTRACTED=$(ls -1 "$RESTORE_DIR" | head -1)
RESTORE_PATH="$RESTORE_DIR/$EXTRACTED"

# Show what will be restored
echo ""
echo "This will restore:"
echo ""

if [[ -f "$RESTORE_PATH/manifest.json" ]]; then
    echo "Backup details:"
    cat "$RESTORE_PATH/manifest.json"
    echo ""
fi

if [[ -d "$RESTORE_PATH/opencode" ]]; then
    echo "OpenCode config files:"
    ls -1 "$RESTORE_PATH/opencode/"
    echo ""
fi

if [[ -d "$RESTORE_PATH/docker" ]]; then
    echo "Docker config files:"
    ls -1 "$RESTORE_PATH/docker/"
    echo ""
fi

# Confirm
read -p "Proceed with restore? (y/N) " confirm
[[ "$confirm" != "y" ]] && echo "Cancelled." && rm -rf "$RESTORE_DIR" && exit 0

echo ""
echo "Restoring..."

# Restore OpenCode config
if [[ -d "$RESTORE_PATH/opencode" ]]; then
    mkdir -p "$OPENCODE_DIR"
    cp -r "$RESTORE_PATH/opencode/"* "$OPENCODE_DIR/" 2>/dev/null || true
    echo "✓ OpenCode config restored"
fi

# Restore Docker config
if [[ -d "$RESTORE_PATH/docker" ]]; then
    mkdir -p "$DOCKER_DIR"
    cp -r "$RESTORE_PATH/docker/"* "$DOCKER_DIR/" 2>/dev/null || true
    echo "✓ Docker config restored"
fi

# Restore crontab
if [[ -f "$RESTORE_PATH/crontab.txt" ]] && [[ "$(cat "$RESTORE_PATH/crontab.txt")" != "(empty)" ]]; then
    crontab "$RESTORE_PATH/crontab.txt"
    echo "✓ Crontab restored"
fi

# Cleanup
rm -rf "$RESTORE_DIR"

echo ""
echo "✓ Restore complete"
echo ""
echo "Restart services:"
echo "  cd ~/docker && docker compose up -d"
