# OpenCode Agent Configuration

## Trigger Words

| Trigger | Action |
|---------|--------|
| `setup` | Run interactive setup menu from starter kit |
| `skill` | Discover available skills |
| `mem` | Memory system gateway |
| `cron` | Cron management |

## Setup Flow

When user types `setup`:

1. Read `setup/menu.json`
2. Present presets using question tool
3. If custom, present categories
4. Collect selections
5. Dispatch to build agent

Do not deviate from this flow.
