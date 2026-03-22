#!/bin/bash
# onboarding.sh - Post-install guided tour
# Usage: onboarding.sh [--quick|--skip|--resume]

set -e

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
PROGRESS_FILE="$OPENCODE_DIR/.onboarding"
SERVER_HOST="${SERVER_HOST:-$(hostname)}"

# Load progress if exists
[[ -f "$PROGRESS_FILE" ]] && source "$PROGRESS_FILE" 2>/dev/null || true

MODE="${1:---menu}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_header() {
    clear 2>/dev/null || true
    echo ""
    echo "=========================================="
    echo "  OpenCode Starter Kit - Onboarding"
    echo "=========================================="
    echo ""
}

show_summary() {
    echo "${GREEN}✓ Installation Complete!${NC}"
    echo ""
    echo "What's installed:"
    echo ""
    
    # Skills count
    if [[ -d "$OPENCODE_DIR/skills" ]]; then
        skill_count=$(ls -1 "$OPENCODE_DIR/skills" | wc -l)
        echo "  📦 $skill_count skills"
    fi
    
    # Containers
    containers=$(docker ps --format '{{.Names}}' 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
    if [[ -n "$containers" ]]; then
        echo "  🐳 Containers: $containers"
    fi
    
    echo ""
    echo "Access URLs:"
    echo "  • OpenMemory Dashboard: http://$SERVER_HOST:3006"
    echo "  • Portainer:            http://$SERVER_HOST:9000"
    echo "  • Homepage:             http://$SERVER_HOST:8765"
    echo ""
}

show_quick_start() {
    echo "${BLUE}Quick Start Commands${NC}"
    echo ""
    echo "Try these anytime:"
    echo ""
    echo "  mem store \"my first memory\""
    echo "     └─ Store a memory"
    echo ""
    echo "  mem search \"first\""
    echo "     └─ Search memories"
    echo ""
    echo "  remind me to check OpenCode in 10 minutes"
    echo "     └─ Set a reminder"
    echo ""
    echo "  health-check.sh"
    echo "     └─ Check system status"
    echo ""
    echo "  skill"
    echo "     └─ Discover all skills"
    echo ""
}

step_welcome() {
    show_header
    echo "${GREEN}Step 1: Welcome!${NC}"
    echo ""
    echo "Your OpenCode AI assistant is ready."
    echo ""
    echo "What you have now:"
    echo "  • Persistent memory that remembers across sessions"
    echo "  • Skills for common tasks (blog, reminders, news)"
    echo "  • Container management (Docker, Portainer)"
    echo "  • A dashboard to see everything at a glance"
    echo ""
    ONBOARDING_STEP=1
    save_progress
}

step_first_memory() {
    show_header
    echo "${GREEN}Step 2: Your First Memory${NC}"
    echo ""
    echo "OpenCode can remember things for you."
    echo ""
    echo "Try storing a memory:"
    echo ""
    echo "  ${BLUE}mem store \"I just installed OpenCode Starter Kit\"${NC}"
    echo ""
    echo "Then search for it:"
    echo ""
    echo "  ${BLUE}mem search \"OpenCode\"${NC}"
    echo ""
    echo "Your memories persist across sessions."
    echo ""
    ONBOARDING_STEP=2
    save_progress
}

step_reminder() {
    show_header
    echo "${GREEN}Step 3: Set a Reminder${NC}"
    echo ""
    echo "Need to remember something? Just ask:"
    echo ""
    echo "  ${BLUE}remind me to water plants in 2 hours${NC}"
    echo ""
    echo "  ${BLUE}remind me to check server status at 9am${NC}"
    echo ""
    echo "You'll get notified via Telegram (if configured)."
    echo ""
    ONBOARDING_STEP=3
    save_progress
}

step_health_check() {
    show_header
    echo "${GREEN}Step 4: System Health${NC}"
    echo ""
    echo "Check your system anytime with:"
    echo ""
    echo "  ${BLUE}~/.config/opencode/scripts/health-check.sh${NC}"
    echo ""
    echo "This shows:"
    echo "  • Running containers"
    echo "  • Service status"
    echo "  • Installed skills"
    echo "  • Memory system status"
    echo ""
    ONBOARDING_STEP=4
    save_progress
}

step_whats_next() {
    show_header
    echo "${GREEN}Step 5: What's Next?${NC}"
    echo ""
    echo "You're all set! Here are some ideas:"
    echo ""
    echo "  • Explore skills: type 'skill' to see what's available"
    echo "  • Read the docs: docs/POST-INSTALL.md"
    echo "  • Customize AGENTS.md: ~/.config/opencode/AGENTS.md"
    echo "  • Check the dashboard: http://$SERVER_HOST:8765"
    echo ""
    echo "Need help later?"
    echo "  • Run onboarding again: onboarding.sh"
    echo "  • Check health: health-check.sh"
    echo "  • Troubleshooting: docs/TROUBLESHOOTING.md"
    echo ""
    ONBOARDING_STEP=5
    save_progress
}

save_progress() {
    cat > "$PROGRESS_FILE" << EOF
# Onboarding progress
ONBOARDING_STEP=${ONBOARDING_STEP:-0}
ONBOARDING_COMPLETE=${ONBOARDING_COMPLETE:-false}
ONBOARDING_LAST_DATE="$(date +%Y-%m-%d)"
EOF
}

mark_complete() {
    ONBOARDING_COMPLETE=true
    ONBOARDING_STEP=5
    save_progress
    echo ""
    echo "${GREEN}✓ Onboarding complete!${NC}"
    echo ""
    echo "You can always run this again with:"
    echo "  onboarding.sh"
    echo ""
}

# Main menu
show_menu() {
    show_header
    echo "Choose how to get started:"
    echo ""
    echo "  1) Guided Tour (~3 min) - Step by step walkthrough"
    echo "  2) Quick Start (~30 sec) - Just show me the commands"
    echo "  3) Skip - I'll explore on my own"
    echo ""
    
    if [[ "$ONBOARDING_STEP" -gt 0 ]] && [[ "$ONBOARDING_COMPLETE" != "true" ]]; then
        echo "  4) Resume from Step $ONBOARDING_STEP"
        echo ""
    fi
    
    echo "  q) Exit"
    echo ""
    echo -n "Choice: "
    read -r choice
    
    case $choice in
        1) run_tour ;;
        2) show_quick_start; echo ""; read -p "Press Enter to continue..." ;;
        3) echo ""; echo "No problem! Run 'onboarding.sh' anytime."; echo "" ;;
        4) resume_tour ;;
        q|Q) exit 0 ;;
        *) show_menu ;;
    esac
}

run_tour() {
    step_welcome
    echo ""; read -p "Press Enter for next step..."
    
    step_first_memory
    echo ""; read -p "Press Enter for next step..."
    
    step_reminder
    echo ""; read -p "Press Enter for next step..."
    
    step_health_check
    echo ""; read -p "Press Enter for next step..."
    
    step_whats_next
    mark_complete
    echo ""; read -p "Press Enter to finish..."
}

resume_tour() {
    case $ONBOARDING_STEP in
        0|1) step_welcome; read -p "Press Enter..." ;;
        2) step_first_memory; read -p "Press Enter..." ;;
        3) step_reminder; read -p "Press Enter..." ;;
        4) step_health_check; read -p "Press Enter..." ;;
        5) step_whats_next; mark_complete ;;
    esac
    run_tour
}

# Handle direct flags
case $MODE in
    --quick)
        show_header
        show_quick_start
        ;;
    --skip)
        echo "Onboarding skipped. Run 'onboarding.sh' anytime."
        ;;
    --resume)
        if [[ "$ONBOARDING_STEP" -gt 0 ]] && [[ "$ONBOARDING_COMPLETE" != "true" ]]; then
            resume_tour
        else
            show_menu
        fi
        ;;
    --status)
        if [[ "$ONBOARDING_COMPLETE" == "true" ]]; then
            echo "Onboarding: Complete"
        else
            echo "Onboarding: Step $ONBOARDING_STEP of 5"
        fi
        ;;
    *)
        show_menu
        ;;
esac
