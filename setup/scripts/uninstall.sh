#!/bin/bash
# uninstall.sh - Remove OpenCode installation
# Usage: uninstall.sh [--keep-data]

set -e

KEEP_DATA=false
[[ "$1" == "--keep-data" ]] && KEEP_DATA=true

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
DOCKER_DIR="${DOCKER_DIR:-$HOME/docker}"

echo "=== OpenCode Uninstall ==="
echo ""
echo "This will remove:"
echo "  - OpenCode configuration ($OPENCODE_DIR)"
echo "  - Skills directory"
if [[ "$KEEP_DATA" == "false" ]]; then
    echo "  - Docker containers and volumes"
    echo "  - Docker configs ($DOCKER_DIR)"
fi
echo ""
echo "This will NOT remove:"
echo "  - Docker itself"
echo "  - Python/system packages"
echo ""

read -p "Are you sure? (y/N) " confirm
[[ "$confirm" != "y" ]] && echo "Cancelled." && exit 0

echo ""

# Stop containers
echo "Stopping containers..."
for container in openmemory portainer homepage nextexplorer usermemos pghmem; do
    docker stop "$container" 2>/dev/null && docker rm "$container" 2>/dev/null && echo "  Removed: $container" || true
done

# Remove containers
if [[ "$KEEP_DATA" == "false" ]]; then
    echo ""
    echo "Removing Docker volumes..."
    docker volume prune -f 2>/dev/null || true
    
    echo "Removing Docker configs..."
    rm -rf "$DOCKER_DIR"
fi

# Remove OpenCode config (keep backup)
echo ""
echo "Backing up before removal..."
backup_dir="$HOME/opencode-removed-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
cp -r "$OPENCODE_DIR" "$backup_dir/" 2>/dev/null || true
echo "  Backup saved to: $backup_dir"

echo ""
echo "Removing OpenCode configuration..."
rm -rf "$OPENCODE_DIR"

echo ""
echo "✓ Uninstall complete"
echo ""
echo "Your configuration was backed up to:"
echo "  $backup_dir"
echo ""
echo "To fully remove, also delete:"
echo "  - Docker: sudo apt remove docker-ce"
echo "  - Backup: rm -rf $backup_dir"
