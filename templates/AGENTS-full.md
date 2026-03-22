# AGENTS.md - OpenCode Configuration

## Trigger Commands

### System & Infrastructure
| Trigger | Action |
|---------|--------|
| `setup` | Interactive setup menu |
| `status` | System health check |
| `skill` or `sd` | Discover skills |
| `containers` | Docker management |

### Memory & Context
| Trigger | Action |
|---------|--------|
| `mem` or `memory` | Memory gateway |
| `cr` | Context registry |
| `checkpoint` | Save session state |

### Communication
| Trigger | Action |
|---------|--------|
| `remind` | Set reminders (Telegram) |
| `notify` | Send notification |
| `blog` or `bp` | Create blog post |

### Tools & Services
| Trigger | Action |
|---------|--------|
| `cron` | Scheduled tasks |
| `rag` | Document retrieval |
| `a [url]` | Browser automation |
| `space` | Disk cleanup |

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

## Custom Triggers

Add your own:
```markdown
| `mycommand` | What it does |
```

---
*OpenCode Starter Kit - Customize at ~/.config/opencode/AGENTS.md*
