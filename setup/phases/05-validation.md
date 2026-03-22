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

After validation completes, present onboarding options using question tool:

```json
{
  "questions": [{
    "question": "Installation complete! What would you like to do?",
    "header": "Next Steps",
    "options": [
      {"label": "Quick Start (Recommended)", "description": "See essential commands (~30 sec)"},
      {"label": "Guided Tour", "description": "Step by step walkthrough (~3 min)"},
      {"label": "Skip for now", "description": "I'll explore on my own"},
      {"label": "Skip - don't ask again", "description": "Never show this again"}
    ],
    "multiple": false
  }]
}
```

If user chooses Quick Start, show:
- `mem store "my first memory"`
- `remind me to X in Y minutes`
- `health-check.sh`
- `skill` (discover skills)

If user chooses Guided Tour, run:
```bash
setup/scripts/onboarding.sh
```

Note: User can always run `onboarding.sh` later to see the guide again.
