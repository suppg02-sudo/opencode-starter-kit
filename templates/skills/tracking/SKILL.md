---
name: tracking
description: Track flows, actions, and context across OpenCode sessions with SQLite storage
color: "#F59E0B"
license: MIT
compatibility: opencode
trigger_words:
  - "cr"
  - "tracking"
  - "flow"
  - "context"
metadata:
  category: core
  scope: tracking
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.0.0
  created_by: opencode-starter-kit
  dependencies:
    - python3
    - sqlite3
  tags: [tracking, flows, context, sessions]
  working_directory: ~/.config/opencode/tracking
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

## Docker Container (Optional)

### Tracking Dashboard
```bash
cat > ~/docker/docker-compose.tracking.yml << 'EOF'
version: '3.8'
services:
  tracking-dashboard:
    image: ghcr.io/opencode/tracking-dashboard:latest
    container_name: tracking-dashboard
    restart: unless-stopped
    ports:
      - "3010:3000"
    volumes:
      - ~/.config/opencode/tracking:/data:ro
    environment:
      DATABASE_PATH: /data/flows.db
    networks:
      - opencode
networks:
  opencode:
    external: true
EOF

cd ~/docker && docker compose -f docker-compose.tracking.yml up -d
```

Dashboard: http://SERVER_HOST:3010

## What Gets Tracked

| Type | Description | Example |
|------|-------------|---------|
| Flows | Multi-step workflows | "Build feature X" |
| Actions | Tool invocations | bash, edit, read |
| Context | Session state | Decisions, preferences |
| Skills | Which skills used | brainstorming, cron |
| Questions | User choices | Menu selections |

## Commands

### List Flows
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py flow list
```

### Show Flow
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py flow show FLOW_ID
```

### Start Flow
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py flow start "Task description"
```

### Track Action
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py action "Ran backup script"
```

### Checkpoint
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py checkpoint "Before major change"
```

### Search History
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py search "topic"
```

## Data Location

```
~/.config/opencode/tracking/
├── flows.db           # SQLite database
├── context/           # Session context files
│   ├── current.json   # Current session
│   └── archive/       # Past sessions
└── exports/           # Exported flow data
```

## Database Schema

```sql
CREATE TABLE flows (
    id TEXT PRIMARY KEY,
    name TEXT,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    status TEXT
);

CREATE TABLE actions (
    id TEXT PRIMARY KEY,
    flow_id TEXT,
    tool TEXT,
    input TEXT,
    output TEXT,
    timestamp TIMESTAMP
);
```

## Integration

### Automatic Tracking
Add to PostToolUse hook:
```bash
~/.config/opencode/scripts/hybrid_tracker.py action "${TOOL}:${INPUT}"
```

### Manual Checkpoints
Call before/after major changes:
```bash
python3 ~/.config/opencode/scripts/hybrid_tracker.py checkpoint "Pre-refactor state"
```

## Troubleshooting

### Database Locked
```bash
# Check for locks
fuser ~/.config/opencode/tracking/flows.db

# Reset if needed
rm ~/.config/opencode/tracking/flows.db
python3 ~/.config/opencode/scripts/hybrid_tracker.py init
```

### Missing Flows
```bash
# Rebuild from logs
python3 ~/.config/opencode/scripts/hybrid_tracker.py rebuild
```

## Related Skills

- **memory-skill** - Persistent memory storage
- **context-registry** - Context tracking
- **opentelemetry** - Distributed tracing

---
*Trigger: `cr` or `tracking`*
