---
name: menu-learning
description: Adaptive menu system that learns from selections to improve future options
version: 1.0.0
created: 2026-03-08
status: production
maturity: L3
dependencies:
  - scripts/menu_learner.py
  - menu-learning/data/selections.json
  - menu-learning/data/preferences.json
---

# Menu Learning System

## Overview

This system tracks menu selections and adapts future menus for continual improvement. It learns from user behavior to:
- **Promote frequently used options** to top of menus
- **Hide rarely used options** to reduce clutter
- **Suggest next actions** based on patterns
- **Track context associations** for smarter defaults

## How It Works

1. **Record**: Every menu selection is recorded with timestamp, menu ID, option ID, and context
2. **Analyze**: Patterns are analyzed for frequency, sequences, and context associations
3. **Modify**: Future menus are reordered/filtered based on learned preferences
4. **Improve**: User can manually promote/hide options to fine-tune

## CLI Commands

```bash
# Record a selection (called automatically by question tool)
python3 ~/.config/opencode/scripts/menu_learner.py record <menu_id> <option_id> [context]

# Analyze patterns over last N days
python3 ~/.config/opencode/scripts/menu_learner.py analyze --days 7

# Get modifications for a menu
python3 ~/.config/opencode/scripts/menu_learner.py get-modifications <menu_id>

# Manually promote an option
python3 ~/.config/opencode/scripts/menu_learner.py promote <option_id> [menu_id]

# Manually hide an option
python3 ~/.config/opencode/scripts/menu_learner.py hide <option_id> [menu_id]

# View statistics
python3 ~/.config/opencode/scripts/menu_learner.py stats

# Apply learning to a menu JSON
python3 ~/.config/opencode/scripts/menu_learner.py apply <menu_id> '<menu_json>'
```

## Data Files

| File | Purpose |
|------|---------|
| `data/selections.json` | All recorded selections with timestamps |
| `data/preferences.json` | User preferences (promoted/hidden options) |
| `analysis/` | Generated analysis reports |

## Integration Points

### Question Tool Integration

When using the question tool, selections are automatically recorded:

```python
# After user selects an option:
menu_learner.record(menu_id="telos", option_id="review", context="after_fix")
```

### Menu Rendering

Before presenting a menu, apply learned modifications:

```python
# Get modifications
mods = menu_learner.get_modifications(menu_id)

# Reorder options: promoted first, hide unused
# Add usage hints to frequently used options
```

## Analysis Output

```json
{
  "period_days": 7,
  "total_selections": 45,
  "top_options": [
    ["status", 12],
    ["logs", 8],
    ["restart", 6]
  ],
  "sequences": {
    "status": {"logs": 5, "restart": 3},
    "logs": {"restart": 4}
  },
  "recommendations": [
    {"type": "promote", "option_id": "status", "reason": "Selected 12 times"},
    {"type": "suggest_next", "after": "status", "suggest": "logs", "confidence": 5}
  ]
}
```

## Modification Types

| Type | Description | Action |
|------|-------------|--------|
| **promote** | Move to top of menu | Reorder array |
| **hide** | Move to "More options" submenu | Filter out |
| **suggest_next** | Add "Did you mean X?" hint | Add hint text |
| **merge_suggestions** | Combine similar options | Propose merge |

## Best Practices

1. **Record all selections** - Even cancellations and exits
2. **Include context** - What led to this menu (task, error, etc.)
3. **Review analysis weekly** - Check recommendations
4. **Manual overrides** - Promote/hide based on explicit user feedback
5. **Essential options** - Never hide "Exit", "Back", "Help"

## Menu Design Guidelines

For best learning results:

1. **Stable IDs** - Option IDs should not change between versions
2. **Descriptive labels** - Clear, consistent naming
3. **Logical grouping** - Related options together
4. **Reasonable size** - 5-10 options per menu (not 20+)
5. **Consistent structure** - Same pattern across similar menus

## Trigger Word

**menu-learning** (on its own)
- Open menu learning management menu
- Options: View stats, Analyze patterns, Promote/Hide options, Reset learning

## Related

- `docs/instructions/triggers/q.md` - Q questioning system
- `skills/router/config/menu.json` - Example structured menu
- `AGENTS.md` - Question tool enforcement section
