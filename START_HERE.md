# OpenCode Starter Kit

Quick setup for a complete OpenCode AI agent environment.

## Quick Start

Open this repo in OpenCode and type:

```
setup
```

The AI agent will guide you through installing your personal AI assistant.

---

## For AI Agents - MANDATORY INSTRUCTIONS

When user types `setup`, follow this exact sequence:

### Step 1: Verify Question Tool
```bash
setup/scripts/check-question-tool.sh
```
If check fails, inform user and fix issues before proceeding.

### Step 2: Load Menu Configuration
```bash
cat setup/menu.json
```

### Step 3: Present Presets Using Question Tool
Use the question tool to present preset options:
```json
{
  "questions": [{
    "question": "Welcome to OpenCode Starter Kit! Choose your setup:",
    "header": "Setup",
    "options": [
      {"label": "Full Install (Recommended)", "description": "Everything included - complete AI assistant (~10 min)"},
      {"label": "Recommended", "description": "Core + skills + containers (~5 min)"},
      {"label": "Minimal", "description": "Just essentials (~2 min)"},
      {"label": "Custom", "description": "Pick individual components"}
    ],
    "multiple": false
  }]
}
```
**Full Install is the default/recommended option** - it includes all skills, containers, and configurations.

### Step 4: If Custom Selected - Present Categories
Loop through categories from menu.json, using question tool with `"multiple": true`.

### Step 5: Confirm Selections
```json
{
  "questions": [{
    "question": "Install these components?",
    "header": "Confirm",
    "options": [
      {"label": "Yes, proceed (Recommended)", "description": "Start installation"},
      {"label": "Modify", "description": "Change selections"},
      {"label": "Cancel", "description": "Abort setup"}
    ],
    "multiple": false
  }]
}
```

### Step 6: Execute Phases
1. Run `setup/scripts/detect-paths.sh`
2. Execute phases in `setup/phases/` in order
3. Update `setup/.progress.json` after each phase

### Step 7: Show Post-Install Guide
Display `docs/POST-INSTALL.md` content to user.

---

## Question Tool Requirements

The question tool MUST be used for all user choices. It:
- Presents clickable options in the TUI
- Returns user selections as labels
- Supports single and multi-select

If the question tool is not working:
1. Check OpenCode version is up to date
2. Verify interactive session (not batch mode)
3. Check `setup/scripts/check-question-tool.sh` output

---

## Troubleshooting

If setup fails:
- Run `rollback.sh` to undo changes
- Check `docs/TROUBLESHOOTING.md`
- Run `health-check.sh` to diagnose
