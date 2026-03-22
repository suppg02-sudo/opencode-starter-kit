#!/bin/bash
# copy-skills.sh - Copy skills from sources
# Usage: copy-skills.sh <skill-name> [skill-name...]

SKILLS_DIR=~/.config/opencode/skills
LIVE=~/.config/opencode/skills
FRESHSTART=~/freshstart/skills

copy_skill() {
    local skill=$1
    local dest="$SKILLS_DIR/$skill"
    
    # Already exists, skip
    if [ -d "$dest/SKILL.md" ] 2>/dev/null || [ -f "$dest/SKILL.md" ] 2>/dev/null; then
        echo "✓ $skill already installed"
        return 0
    fi
    
    # Try freshstart repo
    if [ -d "$FRESHSTART/$skill" ]; then
        echo "✓ Copying $skill from freshstart"
        cp -r "$FRESHSTART/$skill" "$dest"
        return 0
    fi
    
    # Fallback: create minimal stub
    mkdir -p "$dest"
    cat > "$dest/SKILL.md" << EOF
# $skill

TODO: Add skill documentation

## Trigger
\`$skill\`

## Usage
Add \`${skill}\` to your prompt to use this skill.
EOF
    echo "! Created stub for $skill - add SKILL.md content"
    return 0
}

mkdir -p "$SKILLS_DIR"

for skill in "$@"; do
    copy_skill "$skill"
done

echo ""
echo "Installed skills:"
ls "$SKILLS_DIR" | wc -l
echo "total"
