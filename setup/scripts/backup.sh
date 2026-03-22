#!/bin/bash
# backup.sh - Backup OpenCode configuration
# Usage: backup.sh [output_path]

set -e

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
DOCKER_DIR="${DOCKER_DIR:-$HOME/docker}"
OUTPUT_PATH="${1:-$HOME}"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="opencode-backup-$TIMESTAMP"
BACKUP_DIR="$OUTPUT_PATH/$BACKUP_NAME"
BACKUP_FILE="$OUTPUT_PATH/$BACKUP_NAME.tar.gz"

echo "=== OpenCode Backup ==="
echo ""
echo "Creating backup: $BACKUP_NAME"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup OpenCode config
echo "Backing up OpenCode configuration..."
mkdir -p "$BACKUP_DIR/opencode"
cp -r "$OPENCODE_DIR/AGENTS.md" "$BACKUP_DIR/opencode/" 2>/dev/null || true
cp -r "$OPENCODE_DIR/opencode.json" "$BACKUP_DIR/opencode/" 2>/dev/null || true
cp -r "$OPENCODE_DIR/.paths" "$BACKUP_DIR/opencode/" 2>/dev/null || true

# Backup skills list
echo "Recording installed skills..."
ls -1 "$OPENCODE_DIR/skills" > "$BACKUP_DIR/opencode/skills-list.txt" 2>/dev/null || true

# Backup docker configs
echo "Backing up Docker configuration..."
mkdir -p "$BACKUP_DIR/docker"
cp -r "$DOCKER_DIR/"*.yml "$BACKUP_DIR/docker/" 2>/dev/null || true
cp -r "$DOCKER_DIR/.env" "$BACKUP_DIR/docker/" 2>/dev/null || true

# Backup crontab
echo "Backing up crontab..."
crontab -l > "$BACKUP_DIR/crontab.txt" 2>/dev/null || echo "(empty)" > "$BACKUP_DIR/crontab.txt"

# Create manifest
cat > "$BACKUP_DIR/manifest.json" << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "hostname": "$(hostname)",
  "opencode_dir": "$OPENCODE_DIR",
  "docker_dir": "$DOCKER_DIR",
  "skills_count": $(ls -1 "$OPENCODE_DIR/skills" 2>/dev/null | wc -l)
}
EOF

# Create tar.gz
echo ""
echo "Compressing backup..."
cd "$OUTPUT_PATH" && tar -czf "$BACKUP_FILE" "$BACKUP_NAME"
rm -rf "$BACKUP_DIR"

echo ""
echo "✓ Backup complete"
echo ""
echo "Backup location: $BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
echo ""
echo "To restore: restore.sh $BACKUP_FILE"
