---
name: tracking-skill
description: Track flows, actions, and context across sessions
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

Type `cr` to see tracking options

## Quick Usage

```
cr list
cr show FLOW_ID
cr start "task description"
```

## Commands

### List Flows
```bash
~/.config/opencode/scripts/hybrid_tracker.py flow list
```

### Show Flow
```bash
~/.config/opencode/scripts/hybrid_tracker.py flow show FLOW_ID
```

### Track Action
```bash
~/.config/opencode/scripts/hybrid_tracker.py action "description"
```

## What Gets Tracked

- Session context
- Tool invocations
- Skill usage
- Question interactions
- Flow progress

## Data Location

```
~/.config/opencode/tracking/
├── flows.db
└── context/
```

---
*Trigger: `cr` or `tracking`*
