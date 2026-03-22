---
name: tracking
description: Track flows, actions, and context across OpenCode sessions
color: "#F59E0B"
license: MIT
trigger_words:
  - "cr"
  - "tracking"
  - "flow"
metadata:
  category: core
  scope: tracking
  last_updated: 2026-03-22
---

## Trigger

Type `cr` or `tracking` to see tracking options.

## Quick Usage

```
cr list              # List all flows
cr show FLOW_ID      # Show flow details
cr start "task"      # Start new flow
cr checkpoint        # Save current state
```

## What Gets Tracked

| Type | Description |
|------|-------------|
| Flows | Multi-step workflows |
| Actions | Tool invocations, commands |
| Context | Session state, decisions |
| Skills | Which skills were used |

## Commands

### List Flows
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py flow list
```

### Show Flow
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py flow show FLOW_ID
```

### Track Action
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py action "description"
```

## Data Location

```
~/.config/opencode/tracking/
├── flows.db         # SQLite database
├── context/         # Session context files
└── exports/         # Exported flow data
```

## Integration

- Automatic tracking via PostToolUse hooks
- Memory system integration
- Flow reconstruction for debugging

## Related Skills

- **memory-skill** - Persistent memory storage
- **context-registry** - Context tracking

---
*Trigger: `cr` or `tracking`*
