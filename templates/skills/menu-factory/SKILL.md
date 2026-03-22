---
name: menu-factory
version: 1.1.0
description: Meta-skill for standardizing menu creation with templates, rules, and menu-learning integration
trigger: menu-factory | mf | menu-create
maturity: L3
created: 2026-03-21
dependencies:
  - menu-learning
  - skill-discovery
tags:
  - meta
  - menu
  - standardization
  - validation
  - templates
---

# Menu Factory

Meta-skill for standardizing and validating menus across all OpenCode skills.

## Overview

Provides:
- **Templates** - Pre-built menu patterns (service, workflow, analysis, base)
- **Validation** - Check any skill's menu for compliance with rules
- **Menu-Learning Integration** - Reorder options by usage frequency

## Trigger Commands

- `menu-factory` - Full menu factory workflow
- `mf` - Short form
- `menu-create` - Alias

---

## Section 1: Templates

### Available Templates

| Template | Use Case | Required Options |
|----------|----------|------------------|
| `service` | Docker, APIs, databases | Status, Logs, Skill Discovery, Exit |
| `workflow` | Multi-phase skills | Start, Resume, Progress, Skill Discovery, Exit |
| `analysis` | Research, debugging | Run, Export, Skill Discovery, Exit |
| `base` | Minimal starting point | Action, Skill Discovery, Exit |

### Template Files

- [templates/service.json](templates/service.json)
- [templates/workflow.json](templates/workflow.json)
- [templates/analysis.json](templates/analysis.json)
- [templates/base.json](templates/base.json)

### Using Templates

When creating a new skill, select appropriate template:

```
skill-factory → Section 8 (Menu) → menu-factory → select template
```

---

## Section 2: Validation Rules

### Required Menu Suffix

All menus MUST end with:
1. `🔍 Skill Discovery`
2. `Exit`

### Format Rules

| Rule | Value |
|------|-------|
| Label max length | 40 characters |
| Description max length | 60 characters |
| Max options per menu | 10 |
| No emojis | Except Skill Discovery |

---

## Section 3: Scripts

### validate.py

Check menu compliance with rules.

```bash
# Validate a specific skill
python3 scripts/validate.py --skill <name> [--json]

# Validate all skills
python3 scripts/validate.py --all [--json]

# Validate a raw menu JSON
python3 scripts/validate.py --menu '<json>' [--json]

# Auto-fix missing suffix
python3 scripts/validate.py --skill <name> --fix [--json]
```

### apply-learning.py

Reorder menu options by usage frequency from menu-learning data.

```bash
# Reorder a skill's menu (reads from SKILL.md)
python3 scripts/apply-learning.py --skill <name>

# Reorder raw menu JSON
python3 scripts/apply-learning.py --skill <name> --menu '<json>'
```

---

## Section 4: Integration Guide

### Agent Integration (Recommended)

When presenting ANY skill menu, the agent SHOULD:

1. **Extract menu from SKILL.md**
2. **Apply menu-learning reordering**
3. **Present enhanced menu**

**Example:**
```bash
# Get enhanced menu for reminder skill
python3 ~/.config/opencode/skills/menu-factory/scripts/apply-learning.py --skill reminder --json
```

**Output:**
```json
{
  "skill": "reminder",
  "reordered": true,
  "usage_stats": {"defer": 5, "list": 3, "cancel": 2},
  "menu": {
    "questions": [{
      "options": [
        {"label": "⏳ Defer Topic", ...},
        {"label": "📋 List Reminders", ...},
        {"label": "❌ Cancel Reminder", ...},
        {"label": "🔍 Skill Discovery", ...},
        {"label": "Exit", ...}
      ]
    }]
  }
}
```

### Fallback Behavior

If no learning data exists:
- Returns original menu unchanged
- Exit code 1 (non-zero to indicate no learning applied)

---

## Section 5: Rule Files

| File | Purpose |
|------|---------|
| [rules/required-suffix.json](rules/required-suffix.json) | Skill Discovery + Exit required |
| [rules/format-rules.json](rules/format-rules.json) | Label/description limits |
| [rules/common-options.json](rules/common-options.json) | Reusable option definitions |

---

## Menu Configuration

```json
{
  "questions": [{
    "question": "Menu Factory - What would you like to do?",
    "header": "Menu Factory",
    "options": [
      {"label": "Validate Skill Menu (Recommended)", "description": "Check a skill's menu for compliance"},
      {"label": "Validate All Skills", "description": "Audit every skill menu"},
      {"label": "Apply Menu-Learning", "description": "Reorder a skill's menu by usage"},
      {"label": "View Templates", "description": "See available menu templates"},
      {"label": "View Rules", "description": "See format and suffix rules"},
      {"label": "🔍 Skill Discovery", "description": "Related docs, improve menu"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Related Skills

- **menu-learning** - Provides usage data for option reordering
- **skill-discovery** - Uses validate.py for compliance checks
- **skill-factory** - Calls menu-factory during skill creation

---

## History

See: [history/changes.log](history/changes.log)

**Created**: 2026-03-21
**Updated**: 2026-03-21 - Added templates
