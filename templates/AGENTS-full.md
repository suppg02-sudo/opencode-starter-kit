# AGENTS.md - OpenCode Configuration

## Core Triggers

| Trigger | Action |
|---------|--------|
| `setup` | Interactive setup menu |
| `status` | System health check |
| `skill` or `sd` | Discover all skills |

## Factory Skills

| Trigger | Purpose |
|---------|---------|
| `sf` or `skill-factory` | Create/update skills (13-section workflow) |
| `mf` or `menu-factory` | Validate skill menus against standards |
| `ml` or `menu-learning` | Adaptive menus that learn from choices |

## Finding Skills

Type `skill` to discover all available skills and their triggers.

Each skill is self-documenting:
```
~/.config/opencode/skills/{skill-name}/SKILL.md
```

### Memory & Context
| Trigger | Action |
|---------|--------|
| `mem` or `memory` | Memory gateway |
| `cr` | Context registry |
| `checkpoint` | Save session state |

### Common Skills
| Trigger | Skill |
|---------|-------|
| `brainstorm` or `bs` | Design exploration |
| `research` or `r` | Deep research with citations |
| `news` | Hacker News + RSS aggregation |
| `youtube URL` | Transcribe to blog |
| `cron` | Scheduled tasks |
| `remind` | Telegram reminders |
| `blog` | Hugo blog posts |
| `rag` | Document retrieval |
| `telegram` or `tg` | Bot integration |

---

## Agent Behavior

### Response Style
- Concise: <4 lines unless detail requested
- Direct: No preamble, answer first
- Structured: Use tables/lists for options

### Question Tool (Use When)
- User must choose between options
- Confirmation needed for destructive actions
- Next steps unclear

### Memory Protocol
```bash
# Save decision
pghmem save "Decision: chose X because Y" --type decision

# Search memory
pghmem search "topic"
```

### Safety Rules
- **Ask before**: `rm -rf`, deleting containers, pushing to main
- **Never**: Delete Docker images without confirmation
- **Always**: Verify before claiming task complete

---

## Environment

| Variable | Value |
|----------|-------|
| Server | `{{SERVER_HOST}}` |
| Install Path | `~/.config/opencode` |
| Docker Dir | `~/docker` |

---

## Adding New Skills

Use skill-factory to create properly structured skills:

```
sf create my-skill --description "What it does"
```

Or manually:
```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

Add `SKILL.md` with trigger_words in frontmatter.

Use `mf` (menu-factory) to validate menus.

---
*OpenCode Starter Kit - Customize at ~/.config/opencode/AGENTS.md*
