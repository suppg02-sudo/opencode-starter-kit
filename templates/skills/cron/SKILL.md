---
name: cron
description: Manage system cron jobs - list, add, remove, backup, and schedule tasks
color: "#4A90D9"
license: MIT
compatibility: opencode
trigger_words:
  - "cron"
  - "crontab"
  - "schedule"
  - "scheduled task"
metadata:
  category: system
  scope: task-scheduling
  last_updated: 2026-03-22
  version: 1.0.0
---

## Trigger

Type `cron` or `cron menu` to see options.

## Overview

Manage system crontab entries:
- List scheduled jobs
- Add new jobs
- Remove jobs
- Backup/restore crontab

## Commands

### List All Jobs
```bash
crontab -l
```

### Add Job
```bash
# Add job interactively
crontab -e

# Add job directly
(crontab -l 2>/dev/null; echo "0 8 * * * /path/to/script.sh") | crontab -
```

### Remove Job
```bash
# Edit and remove line
crontab -e

# Remove all jobs
crontab -r
```

### Backup Crontab
```bash
crontab -l > ~/crontab-backup-$(date +%Y%m%d).txt
```

### Restore Crontab
```bash
crontab ~/crontab-backup.txt
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

### Common Schedules

| Schedule | Meaning |
|----------|---------|
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour |
| `0 0 * * *` | Daily at midnight |
| `0 8 * * *` | Daily at 8 AM |
| `0 0 * * 0` | Weekly on Sunday |
| `0 0 1 * *` | Monthly on 1st |

## Troubleshooting

### Job Not Running
1. Check cron service: `systemctl status cron`
2. Check logs: `grep CRON /var/log/syslog`
3. Verify script is executable: `chmod +x /path/to/script.sh`
4. Use full paths in scripts

### Environment Issues
Cron runs with minimal environment. In scripts:
```bash
#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
```

## Related Skills

- **reminder** - Telegram reminders with cron integration

---
*Trigger: `cron` or `crontab`*
