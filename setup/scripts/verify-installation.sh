#!/bin/bash
# verify-installation.sh - Comprehensive post-installation verification
# Usage: verify-installation.sh [component]
#   verify-installation.sh         # Full verification
#   verify-installation.sh skills   # Verify skills only
#   verify-installation.sh docker   # Verify Docker only

set -euo pipefail

source "$HOME/.config/opencode/.paths" 2>/dev/null || true

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
SKILLS_DIR="$OPENCODE_DIR/skills"
SERVER_HOST="${SERVER_HOST:-$(hostname 2>/dev/null || echo 'localhost')}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

errors=0
warnings=0
passed=0
total=0

pass() { echo -e "${GREEN}✓${NC} $1"; passed=$((passed + 1)); total=$((total + 1)); }
fail() { echo -e "${RED}✗${NC} $1"; errors=$((errors + 1)); total=$((total + 1)); }
warn() { echo -e "${YELLOW}!${NC} $1"; warnings=$((warnings + 1)); total=$((total + 1)); }
info() { echo -e "${BLUE}ℹ${NC} $1"; }
section() { echo ""; echo -e "${BLUE}━━━ $1 ━━━${NC}"; }

verify_component="${1:-all}"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║        OpenCode Starter Kit - Verification Phase         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo "Server: $SERVER_HOST"
echo "Time: $(date)"
echo ""

if [[ "$verify_component" == "all" || "$verify_component" == "core" ]]; then
    section "Core Files"
    
    if [[ -f "$OPENCODE_DIR/AGENTS.md" ]]; then
        pass "AGENTS.md exists"
        lines=$(wc -l < "$OPENCODE_DIR/AGENTS.md")
        info "  $lines lines, $(grep -c "trigger" "$OPENCODE_DIR/AGENTS.md" 2>/dev/null || echo 0) triggers"
    else
        fail "AGENTS.md missing"
    fi
    
    if [[ -f "$OPENCODE_DIR/opencode.json" ]]; then
        pass "opencode.json exists"
        if command -v jq &>/dev/null; then
            mcp_count=$(jq '.mcpServers | length' "$OPENCODE_DIR/opencode.json" 2>/dev/null || echo 0)
            info "  $mcp_count MCP servers configured"
        fi
    else
        warn "opencode.json missing (using defaults)"
    fi
    
    if [[ -f "$OPENCODE_DIR/.paths" ]]; then
        pass ".paths file exists"
    else
        warn ".paths missing (run detect-paths.sh)"
    fi
    
    section "Directory Structure"
    
    for dir in skills scripts backups; do
        if [[ -d "$OPENCODE_DIR/$dir" ]]; then
            count=$(find "$OPENCODE_DIR/$dir" -type f 2>/dev/null | wc -l)
            pass "$dir/ ($count files)"
        else
            warn "$dir/ missing"
        fi
    done
fi

if [[ "$verify_component" == "all" || "$verify_component" == "skills" ]]; then
    section "Skills Verification"
    
    skill_count=$(find "$SKILLS_DIR" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    info "Found $skill_count skills"
    
    core_skills=("skill-factory" "menu-factory" "menu-learning")
    
    for skill in "${core_skills[@]}"; do
        if [[ -f "$SKILLS_DIR/$skill/SKILL.md" ]]; then
            if grep -q "^name:" "$SKILLS_DIR/$skill/SKILL.md" 2>/dev/null; then
                pass "$skill (valid SKILL.md)"
            else
                warn "$skill (SKILL.md missing frontmatter)"
            fi
        else
            fail "$skill missing"
        fi
    done
    
    skills_with_scripts=$(find "$SKILLS_DIR" -name "*.sh" -type f 2>/dev/null | wc -l)
    info "$skills_with_scripts skill scripts found"
    
    echo ""
    info "Sample skill triggers:"
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [[ -f "$skill_dir/SKILL.md" ]]; then
            trigger=$(grep -m1 "^trigger:" "$skill_dir/SKILL.md" 2>/dev/null | head -1)
            if [[ -n "$trigger" ]]; then
                echo "  $(basename "$skill_dir"): $trigger"
            fi
        fi
    done | head -5
fi

if [[ "$verify_component" == "all" || "$verify_component" == "memory" ]]; then
    section "Memory System"
    
    if command -v pghmem &>/dev/null; then
        pass "pghmem CLI available"
        if pghmem stats &>/dev/null; then
            mem_count=$(pghmem stats 2>/dev/null | grep -i "total" | awk '{print $NF}' || echo "unknown")
            pass "PostgreSQL memory connected ($mem_count memories)"
        else
            warn "PostgreSQL memory not responding"
        fi
    else
        warn "pghmem CLI not installed"
    fi
    
    if curl -sf http://localhost:8081/health &>/dev/null; then
        pass "OpenMemory API responding (port 8081)"
    else
        if docker ps --format '{{.Names}}' 2>/dev/null | grep -q openmemory; then
            warn "OpenMemory container running but API not responding"
        else
            info "OpenMemory not installed (optional)"
        fi
    fi
fi

if [[ "$verify_component" == "all" || "$verify_component" == "docker" ]]; then
    section "Docker Services"
    
    if docker ps &>/dev/null; then
        pass "Docker daemon running"
        running=$(docker ps --format '{{.Names}}' | wc -l)
        info "$running containers running"
    else
        fail "Docker daemon not running"
    fi
    
    declare -A services=(
        ["portainer"]="9000"
        ["homepage"]="3000"
        ["nextexplorer"]="3000"
        ["hugo"]="1313"
        ["openmemory"]="8080"
        ["memos"]="5230"
    )
    
    for service in "${!services[@]}"; do
        port="${services[$service]}"
        if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^${service}$"; then
            if curl -sf "http://localhost:$port" &>/dev/null || curl -sf "http://localhost:$((port-1))" &>/dev/null; then
                pass "$service container (responding on port)"
            else
                warn "$service container running but not responding"
            fi
        fi
    done
    
    if docker network ls 2>/dev/null | grep -q "opencode"; then
        pass "opencode Docker network exists"
    else
        info "opencode network not created (will be created on first container)"
    fi
fi

if [[ "$verify_component" == "all" || "$verify_component" == "scripts" ]]; then
    section "Utility Scripts"
    
    scripts=("health-check.sh" "backup.sh" "restore.sh" "rollback.sh" "validate.sh" "detect-paths.sh")
    
    for script in "${scripts[@]}"; do
        if [[ -f "$OPENCODE_DIR/scripts/$script" ]]; then
            if [[ -x "$OPENCODE_DIR/scripts/$script" ]]; then
                pass "$script (executable)"
            else
                warn "$script (not executable)"
            fi
        else
            info "$script not installed"
        fi
    done
fi

if [[ "$verify_component" == "all" || "$verify_component" == "network" ]]; then
    section "Network Connectivity"
    
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        pass "Internet connectivity"
    else
        warn "No internet connection"
    fi
    
    if command -v tailscale &>/dev/null; then
        if tailscale status &>/dev/null; then
            ts_ip=$(tailscale ip -4 2>/dev/null || echo "unknown")
            pass "Tailscale VPN ($ts_ip)"
        else
            info "Tailscale not connected"
        fi
    fi
fi

section "Verification Summary"

echo ""
echo "┌─────────────────────────────────────────────┐"
echo "│  Results: $passed passed, $warnings warnings, $errors failed"
echo "└─────────────────────────────────────────────┘"

if [[ $errors -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}✓ Verification passed!${NC}"
    
    echo ""
    echo "Quick Start Commands:"
    echo "  mem                    # Memory system"
    echo "  skill                  # Discover skills"
    echo "  sf                     # Create new skill"
    echo "  health-check.sh        # System status"
    echo "  blog-cli.sh status     # Blog status"
    echo ""
    echo "Access URLs:"
    echo "  Portainer:    http://${SERVER_HOST}:9000"
    echo "  NextExplorer: http://${SERVER_HOST}:8080"
    echo "  Hugo Blog:    http://${SERVER_HOST}:1313"
    
    [[ $warnings -gt 0 ]] && echo -e "\n${YELLOW}Note: $warnings warnings detected (non-critical)${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}✗ Verification failed with $errors errors${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Run: ./setup/scripts/health-check.sh"
    echo "  2. Check logs: docker-compose logs"
    echo "  3. See: docs/TROUBLESHOOTING.md"
    exit 1
fi
