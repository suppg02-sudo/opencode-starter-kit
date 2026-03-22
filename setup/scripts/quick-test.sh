#!/bin/bash
# quick-test.sh - Fast verification of key components
# Usage: quick-test.sh
# Use this after installation to verify critical functionality

set -euo pipefail

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

SKILLS_DIR="${SKILLS_DIR:-$HOME/.config/opencode/skills}"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
passed=0

pass() { echo -e "${GREEN}✓${NC} $1"; passed=$((passed + 1)); }
fail() { echo -e "${RED}✗${NC} $1"; errors=$((errors + 1)); }
warn() { echo -e "${YELLOW}!${NC} $1"; }

echo "╔════════════════════════════════════════════╗"
echo "║   OpenCode Starter Kit - Quick Test        ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Test 1: Core files
echo "Testing core files..."
[[ -f ~/.config/opencode/AGENTS.md ]] && pass "AGENTS.md" || fail "AGENTS.md"
[[ -f ~/.config/opencode/skills/skill-factory/SKILL.md ]] && pass "skill-factory" || fail "skill-factory"

# Test 2: Key skills exist
echo ""
echo "Testing key skills..."
for skill in brainstorming research cron blog-post-creator; do
    [[ -f "$SKILLS_DIR/$skill/SKILL.md" ]] && pass "$skill" || fail "$skill"
done

# Test 3: Docker basics
echo ""
echo "Testing Docker..."
if docker ps &>/dev/null; then
    pass "Docker running"
    running=$(docker ps --format '{{.Names}}' | wc -l)
    [[ $running -ge 2 ]] && pass "Containers active ($running)" || warn "Only $running containers running"
else
    fail "Docker not running"
fi

# Test 4: Memory (if OpenMemory installed)
echo ""
echo "Testing memory..."
if curl -sf http://localhost:8081/health &>/dev/null; then
    pass "OpenMemory API responding"
elif command -v pghmem &>/dev/null; then
    if pghmem stats &>/dev/null; then
        pass "PostgreSQL memory working"
    else
        warn "Memory backend not responding"
    fi
else
    warn "Memory system not installed"
fi

# Test 5: Quick skills check
echo ""
echo "Testing skill triggers..."
trigger_count=$(grep -r "^trigger:" "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | wc -l)
[[ $trigger_count -gt 10 ]] && pass "Skill triggers found ($trigger_count)" || warn "Only $trigger_count triggers found"

# Test 6: Hugo blog
echo ""
echo "Testing blog setup..."
if [[ -f ~/.config/opencode/skills/blog-post-creator/scripts/blog-cli.sh ]]; then
    pass "blog-cli.sh available"
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q hugo; then
        pass "Hugo container running"
    else
        warn "Hugo container not running"
    fi
else
    warn "blog-post-creator not installed"
fi

# Summary
echo ""
echo "╔════════════════════════════════════════════╗"
echo "  Results: $passed passed, $errors failed"
echo "╚════════════════════════════════════════════╝"

if [[ $errors -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}✓ Quick test passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run full verification:"
    echo "     ~/.config/opencode/scripts/verify-installation.sh"
    echo ""
    echo "  2. Try a skill:"
    echo "     skill"
    echo ""
    echo "  3. Check health:"
    echo "     ~/.config/opencode/scripts/health-check.sh"
    exit 0
else
    echo ""
    echo -e "${RED}✗ Quick test failed!${NC}"
    echo ""
    echo "Debug:"
    echo "  docker ps          # Check container status"
    echo "  docker logs [name] # See container logs"
    exit 1
fi
