# Phase 5: Validation

**Verifies**: Complete installation
**Duration**: ~1 minute

## Checks

### Skills
```bash
for skill in ~/.config/opencode/skills/*/; do
    [ -f "$skill/SKILL.md" ] && echo "✓ $(basename $skill)" || echo "✗ $(basename $skill) missing SKILL.md"
done
```

### Docker Services
```bash
docker ps --format "{{.Names}}: {{.Status}}"
```

### Memory System (if installed)
```bash
pghmem stats 2>/dev/null && echo "✓ Memory connected" || echo "✗ Memory not connected"
```

## Generate Summary
```bash
cat > ~/.config/opencode/INSTALL_SUMMARY.md << EOF
# Installation Complete
Date: $(date)

## Installed Skills
$(ls ~/.config/opencode/skills/)

## Running Containers
$(docker ps --format "table {{.Names}}\t{{.Status}}")

## Access URLs
- Portainer: http://$(hostname):9000
- Homepage: http://$(hostname):8765
- NextExplorer: http://$(hostname):8080
EOF
```

## Output to User
```
Installation complete! Summary saved to ~/.config/opencode/INSTALL_SUMMARY.md
```
