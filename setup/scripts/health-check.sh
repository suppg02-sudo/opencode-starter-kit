#!/bin/bash
# health-check.sh - Check status of all OpenCode components
# Usage: health-check.sh [--json]

set -e

JSON_OUTPUT=false
[[ "$1" == "--json" ]] && JSON_OUTPUT=true

# Source paths if available
source "$HOME/.config/opencode/.paths" 2>/dev/null || true

SERVER_HOST="${SERVER_HOST:-$(hostname)}"
OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_count=0
pass_count=0
warn_count=0
fail_count=0

check() {
    local name=$1
    local cmd=$2
    local url=$3
    
    check_count=$((check_count + 1))
    
    if eval "$cmd" &>/dev/null; then
        [[ "$JSON_OUTPUT" == "false" ]] && echo -e "${GREEN}✓${NC} $name"
        pass_count=$((pass_count + 1))
        return 0
    elif [[ -n "$url" ]] && curl -sf "$url" &>/dev/null; then
        [[ "$JSON_OUTPUT" == "false" ]] && echo -e "${GREEN}✓${NC} $name ($url)"
        pass_count=$((pass_count + 1))
        return 0
    else
        [[ "$JSON_OUTPUT" == "false" ]] && echo -e "${RED}✗${NC} $name"
        fail_count=$((fail_count + 1))
        return 1
    fi
}

echo "================================"
echo "  OpenCode Health Check"
echo "  Server: $SERVER_HOST"
echo "================================"
echo ""

echo "--- System ---"
check "Docker" "docker --version"
check "Python3" "python3 --version"
check "Git" "git --version"

echo ""
echo "--- Services ---"
check "OpenMemory API" "true" "http://localhost:8081/health"
check "OpenMemory Dashboard" "true" "http://localhost:3006"
check "Portainer" "true" "http://localhost:9000"
check "Homepage" "true" "http://localhost:8765"
check "NextExplorer" "true" "http://localhost:8080"

echo ""
echo "--- Docker Containers ---"
for container in openmemory portainer homepage nextexplorer usermemos pghmem; do
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^${container}$"; then
        status=$(docker ps --filter "name=^${container}$" --format '{{.Status}}')
        echo -e "${GREEN}✓${NC} $container ($status)"
        pass_count=$((pass_count + 1))
    else
        echo -e "${YELLOW}○${NC} $container (not running)"
        warn_count=$((warn_count + 1))
    fi
    check_count=$((check_count + 1))
done

echo ""
echo "--- Skills ---"
SKILLS_DIR="$OPENCODE_DIR/skills"
if [[ -d "$SKILLS_DIR" ]]; then
    skill_count=$(ls -1 "$SKILLS_DIR" 2>/dev/null | wc -l)
    echo -e "${GREEN}✓${NC} $skill_count skills installed"
    
    # Check key skills
    for skill in skill-factory menu-factory openmemory transcription; do
        if [[ -f "$SKILLS_DIR/$skill/SKILL.md" ]]; then
            echo -e "  ${GREEN}•${NC} $skill"
        else
            echo -e "  ${YELLOW}○${NC} $skill (missing)"
        fi
    done
else
    echo -e "${RED}✗${NC} Skills directory not found"
fi

echo ""
echo "--- Memory ---"
if command -v pghmem &>/dev/null && pghmem stats &>/dev/null; then
    mem_stats=$(pghmem stats 2>/dev/null | head -3)
    echo -e "${GREEN}✓${NC} PostgreSQL memory active"
    echo "$mem_stats"
elif curl -sf http://localhost:8081/health &>/dev/null; then
    echo -e "${GREEN}✓${NC} OpenMemory active"
else
    echo -e "${YELLOW}○${NC} No memory system detected"
fi

echo ""
echo "================================"
echo "  Summary: $pass_count passed, $warn_count warnings, $fail_count failed"
echo "================================"

# JSON output for automation
if [[ "$JSON_OUTPUT" == "true" ]]; then
    cat << EOF
{
  "server": "$SERVER_HOST",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "checks": {
    "total": $check_count,
    "passed": $pass_count,
    "warnings": $warn_count,
    "failed": $fail_count
  },
  "skills": $(ls -1 "$SKILLS_DIR" 2>/dev/null | wc -l),
  "containers": "$(docker ps --format '{{.Names}}' 2>/dev/null | tr '\n' ',' | sed 's/,$//')"
}
EOF
fi

# Exit code based on failures
[[ $fail_count -eq 0 ]] && exit 0 || exit 1
