#!/bin/bash
# check-question-tool.sh - Verify question tool is available
# Returns 0 if available, 1 if not

set -e

OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
ISSUES=0

echo "=== Question Tool Check ==="
echo ""

# Check 1: opencode.json exists
echo "1. Checking opencode.json..."
if [[ -f "$OPENCODE_CONFIG" ]]; then
    echo "   ✓ Config file exists"
else
    echo "   ✗ Config file missing"
    echo "   Fix: Create ~/.config/opencode/opencode.json"
    ISSUES=$((ISSUES + 1))
fi

# Check 2: Valid JSON
echo ""
echo "2. Validating JSON..."
if python3 -c "import json; json.load(open('$OPENCODE_CONFIG'))" 2>/dev/null; then
    echo "   ✓ Valid JSON"
else
    echo "   ✗ Invalid JSON"
    echo "   Fix: Run detect-paths.sh or recreate config"
    ISSUES=$((ISSUES + 1))
fi

# Check 3: Model configured
echo ""
echo "3. Checking model configuration..."
MODEL=$(python3 -c "import json; print(json.load(open('$OPENCODE_CONFIG')).get('model', ''))" 2>/dev/null)
if [[ -n "$MODEL" ]]; then
    echo "   ✓ Model configured: $MODEL"
else
    echo "   ! No model configured (using default)"
    echo "   Add to opencode.json: \"model\": \"zhipuai-coding-plan/glm-5\""
fi

# Check 4: MCP servers (question tool may need MCP)
echo ""
echo "4. Checking MCP configuration..."
MCP_COUNT=$(python3 -c "import json; print(len(json.load(open('$OPENCODE_CONFIG')).get('mcp', {})))" 2>/dev/null)
if [[ "$MCP_COUNT" -gt 0 ]]; then
    echo "   ✓ $MCP_COUNT MCP server(s) configured"
else
    echo "   ! No MCP servers configured"
    echo "   (Question tool should work without MCP)"
fi

# Check 5: Test question tool availability (basic check)
echo ""
echo "5. Testing question tool availability..."
# The question tool is built into OpenCode - we can't test it outside the session
# But we can verify the structure is correct
echo "   ℹ Question tool is a built-in OpenCode tool"
echo "   ℹ It requires an interactive session (not batch mode)"

echo ""
echo "================================"
if [[ $ISSUES -eq 0 ]]; then
    echo "  ✓ Question tool configuration OK"
    echo ""
    echo "  Note: Question tool requires:"
    echo "    - Interactive OpenCode session"
    echo "    - User responding to prompts"
    echo ""
    exit 0
else
    echo "  ✗ Found $ISSUES issue(s)"
    echo ""
    echo "  Fix the issues above before using setup."
    exit 1
fi
