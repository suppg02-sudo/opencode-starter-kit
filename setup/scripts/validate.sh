#!/bin/bash
# validate.sh - Validate installation completeness
# Usage: validate.sh

set -e

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
DOCKER_DIR="${DOCKER_DIR:-$HOME/docker}"
SKILLS_DIR="$OPENCODE_DIR/skills"

errors=0
warnings=0

pass() { echo -e "  ✓ $1"; }
fail() { echo -e "  ✗ $1"; errors=$((errors + 1)); }
warn() { echo -e "  ! $1"; warnings=$((warnings + 1)); }

echo "=== Installation Validation ==="
echo ""

# Check required files
echo "--- Required Files ---"
[[ -f "$OPENCODE_DIR/AGENTS.md" ]] && pass "AGENTS.md" || fail "AGENTS.md missing"
[[ -f "$OPENCODE_DIR/opencode.json" ]] && pass "opencode.json" || warn "opencode.json missing"
[[ -f "$OPENCODE_DIR/.paths" ]] && pass ".paths" || warn ".paths missing (run detect-paths.sh)"

echo ""
echo "--- Directory Structure ---"
[[ -d "$SKILLS_DIR" ]] && pass "skills/" || fail "skills/ missing"
[[ -d "$OPENCODE_DIR/scripts" ]] && pass "scripts/" || warn "scripts/ missing"
[[ -d "$DOCKER_DIR" ]] && pass "docker/" || warn "docker/ missing"

echo ""
echo "--- Core Skills ---"
for skill in skill-factory menu-factory; do
    [[ -f "$SKILLS_DIR/$skill/SKILL.md" ]] && pass "$skill" || fail "$skill missing"
done

echo ""
echo "--- Memory System ---"
if curl -sf http://localhost:8081/health &>/dev/null; then
    pass "OpenMemory API responding"
elif docker ps --format '{{.Names}}' | grep -q openmemory; then
    pass "OpenMemory container running"
else
    warn "OpenMemory not detected"
fi

echo ""
echo "--- Docker Services ---"
if docker ps &>/dev/null; then
    pass "Docker daemon running"
    running=$(docker ps --format '{{.Names}}' | wc -l)
    echo "  ($running containers running)"
else
    fail "Docker daemon not running"
fi

echo ""
echo "--- Scripts ---"
for script in health-check.sh rollback.sh backup.sh update.sh; do
    if [[ -f "$OPENCODE_DIR/scripts/$script" ]] || [[ -f "$(dirname "$0")/$script" ]]; then
        pass "$script"
    else
        warn "$script missing"
    fi
done

echo ""
echo "================================"
if [[ $errors -eq 0 ]]; then
    echo "  ✓ Validation passed"
    [[ $warnings -gt 0 ]] && echo "  ($warnings warnings)"
    exit 0
else
    echo "  ✗ Validation failed: $errors errors, $warnings warnings"
    exit 1
fi
