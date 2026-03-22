---
name: cron
description: Manage system cron jobs - list, add, remove, backup, and schedule tasks via crontab
color: "#4A90D9"
license: MIT
compatibility: opencode
trigger_words:
  - "cron"
  - "crontab"
  - "schedule"
  - "scheduled task"
  - "cron job"
  - "cron menu"
metadata:
  category: system
  scope: task-scheduling
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.3.0
  created_by: opencode-starter-kit
  dependencies: []
  optional_dependencies:
    - chronicle
    - telegram
  tags: [cron, scheduling, automation]
  working_directory: ~/.config/opencode/skills/cron
---

## Trigger

Type `cron` or `cron menu` to see options.

## Quick Usage

```
cron list              # List all jobs
cron add "0 8 * * * /path/to/script.sh"  # Add job
cron backup            # Backup crontab
cron restore           # Restore from backup
```

## Docker Container (Optional)

### Chronicle Web UI
```bash
cat > ~/docker/docker-compose.chronicle.yml << 'EOF'
version: '3.8'
services:
  chronicle:
    image: blakeblackshear/chronicle:latest
    container_name: chronicle
    restart: unless-stopped
    ports:
      - "19997:8080"
    volumes:
      - chronicle_data:/config
    environment:
      TZ: UTC
    networks:
      - opencode

volumes:
  chronicle_data:

networks:
  opencode:
    external: true
EOF

cd ~/docker && docker compose -f docker-compose.chronicle.yml up -d
```

Dashboard: http://SERVER_HOST:19997

## Commands

### List All Jobs
```bash
crontab -l
```

With line numbers:
```bash
crontab -l | nl -v0
```

### Edit Jobs
```bash
crontab -e
```

### Add Job
```bash
# Quick method
echo "0 8 * * * /path/to/script.sh" | crontab -

# Preserve existing
(crontab -l 2>/dev/null; echo "0 8 * * * /path/to/script.sh") | crontab -
```

### Remove Job
```bash
# Edit and delete line
crontab -e

# Remove all
crontab -r
```

### Backup
```bash
crontab -l > ~/.config/opencode/backups/crontab-$(date +%Y%m%d).txt
```

### Restore
```bash
crontab ~/.config/opencode/backups/crontab-20260322.txt
```

## Schedule Format

```
┌───────────── minute (0-59)
│ ┌───────────── hour (0-23)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-6, 0=Sunday)
│ │ │ │ │
* * * * * command
```

## Common Schedules

| Schedule | Meaning |
|----------|---------|
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour |
| `0 0 * * *` | Daily at midnight |
| `0 8 * * *` | Daily at 8 AM |
| `0 0 * * 0` | Weekly on Sunday |
| `0 0 1 * *` | Monthly on 1st |
| `*/15 * * * *` | Every 15 minutes |
| `0 9-17 * * 1-5` | Hourly 9-5 weekdays |

## Cron Jobs

### Common Tasks
```bash
# Daily backup at 2 AM
0 2 * * * /root/.config/opencode/scripts/backup.sh >> /var/log/backup.log 2>&1

# Health check every hour
0 * * * * /root/.config/opencode/scripts/health-check.sh --json >> /var/log/health.log

# Weekly cleanup at 3 AM Sunday
0 3 * * 0 docker system prune -f >> /var/log/docker-cleanup.log 2>&1

# Daily news digest at 8 AM
0 8 * * * /root/.config/opencode/skills/news/scripts/fetch-news.sh | telegram send "$(cat -)"
```

## Environment

Cron runs with minimal environment. Always use full paths:

```bash
# In scripts
#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
export HOME=/root
export TELEGRAM_BOT_TOKEN="token"
export TELEGRAM_CHAT_ID="id"
```

## Logging

### Capture Output
```bash
# Redirect both stdout and stderr
0 8 * * * /path/to/script.sh >> /var/log/cron.log 2>&1

# Use logger
0 8 * * * /path/to/script.sh 2>&1 | logger -t myscript
```

### Check Logs
```bash
# System cron log
grep CRON /var/log/syslog | tail -20

# Journal
journalctl -u cron --since "1 hour ago"
```

## Troubleshooting

### Job Not Running
1. Check cron service: `systemctl status cron`
2. Verify script is executable: `chmod +x script.sh`
3. Check paths (use full paths)
4. Test manually first
5. Check logs for errors

### Permission Denied
```bash
chmod +x /path/to/script.sh
```

### Environment Issues
```bash
# In crontab
SHELL=/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
HOME=/root
```

## Related Skills

- **reminder** - Scheduled Telegram reminders
- **telegram** - Send notifications
- **backup** - Automated backups
- **maintenance** - System cleanup

---
*Trigger: `cron`, `crontab`, or `schedule`*
