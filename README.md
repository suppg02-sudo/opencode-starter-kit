# OpenCode Starter Kit

A menu-driven setup system for OpenCode AI agent environments.

## What It Installs

### Core Systems
- **AGENTS.md Config** - Agent behavior and trigger commands
- **Skill Factory** - Meta-skill for creating/managing skills
- **Menu Factory** - Standardize and validate skill menus
- **Menu Learning** - Adaptive menus that learn from choices
- **OpenMemory Lite** - SQLite-based persistent memory with conversations
- **Tracking System** - Flow and context tracking
- **OpenTelemetry** - Observability and tracing (optional)

### Skills
- **Cron** - Scheduled task management
- **Reminder** - Telegram reminders with cron
- **Blog Post Creator** - Hugo blog workflow with YouTube pipeline
- **YouTube Transcription** - Extract transcripts, auto-create blog posts
- **Memory Gateway** - Memory skill interface (trigger: mem)
- **Tracking Gateway** - Tracking skill interface (trigger: cr)
- **OpenRAG** - Document retrieval stack

### Container Services
- Docker Compose base
- Portainer (container management)
- Homepage (dashboard)
- NextExplorer (file browser)
- UserMemos (notes)

## Usage

1. Clone this repo
2. Open in OpenCode
3. Type `setup`
4. Follow the interactive menu

## Presets

| Preset | Time | What's Included |
|--------|------|-----------------|
| **Full Install** | ~10 min | Everything |
| Recommended | ~5 min | Core + skills + essential containers |
| Minimal | ~2 min | Just essentials |
| Custom | varies | Pick components |

## Requirements

- Linux server
- Docker installed
- Python 3.10+
- OpenCode agent

## After Install

Run the guided tour:
```bash
~/.config/opencode/scripts/onboarding.sh
```

Check system health:
```bash
~/.config/opencode/scripts/health-check.sh
```
