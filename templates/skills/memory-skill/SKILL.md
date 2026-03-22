---
name: memory-skill
description: Memory gateway skill for storing and searching persistent memories
color: "#8B5CF6"
license: MIT
trigger_words:
  - "mem"
  - "memory"
metadata:
  category: core
  scope: memory
  last_updated: 2026-03-22
---

## Trigger

Type `mem` to see memory options

## Quick Usage

```
mem store "Important decision: chose X because Y"
mem search "decision"
mem list
```

## Commands

### Store Memory
```bash
mem store "content here" --tags tag1,tag2
```

### Search Memory
```bash
mem search "query"
```

### List Recent
```bash
mem list --limit 10
```

## Memory Types

| Type | Use For |
|------|---------|
| decision | Choices, preferences |
| action | Files created, commands run |
| conversation | Research, discussions |
| learning | Patterns, insights |

## Requirements

- OpenMemory Lite installed
- Docker running

## Dashboard

View memories: http://SERVER_HOST:3006

---
*Trigger: `mem` or `memory`*
