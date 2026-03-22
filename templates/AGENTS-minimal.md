# AGENTS.md - OpenCode

## Core Triggers

| Trigger | Action |
|---------|--------|
| `setup` | Run interactive setup menu |
| `skill` | Discover all available skills |
| `mem` | Memory system gateway |

## Finding Skills

Type `skill` to see all available skills and their triggers.

Each skill defines its own triggers in `~/.config/opencode/skills/{skill}/SKILL.md`

## Agent Behavior

- Be concise (fewer than 4 lines unless detail requested)
- No preamble ("Here is...", "I will...")
- Direct answers first
- Use question tool when multiple options exist
- Ask before `rm -rf` or deleting containers
- Never delete Docker images without confirmation

## Memory

Save important decisions:
```bash
pghmem save "Decision: chose X because Y" --type decision
```

---
*Customize: ~/.config/opencode/AGENTS.md*
