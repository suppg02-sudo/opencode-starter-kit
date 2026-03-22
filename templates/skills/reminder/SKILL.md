---
name: reminder
description: Schedule and manage reminders via Telegram with cron integration
color: "#FF6B6B"
license: MIT
trigger_words:
  - "remind"
  - "reminder"
  - "remind me"
metadata:
  category: productivity
  scope: notifications
  last_updated: 2026-03-22
---

## Trigger

Type `remind` or `remind me to X in Y`

## Quick Usage

```
remind me to water plants in 2 hours
remind me to check server at 3pm
remind me daily at 9am to review tasks
```

## Commands

### Set Reminder
```bash
~/.config/opencode/skills/reminder/scripts/reminder.sh "message" "duration"
```

### List Reminders
```bash
cat ~/.config/opencode/skills/reminder/context/reminders.json
```

### Remove Reminder
```bash
# Edit crontab and remove the job
crontab -e
```

## Requirements

- Telegram bot configured
- Cron skill installed
- `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` environment variables

## Related Skills

- **cron** - Scheduled task management

---
*Trigger: `remind me to X in Y`*
