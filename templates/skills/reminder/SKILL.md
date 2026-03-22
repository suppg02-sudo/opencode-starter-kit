---
name: reminder
description: Schedule and manage reminders via Telegram with cron integration
color: "#FF6B6B"
license: MIT
compatibility: opencode
trigger_words:
  - "remind"
  - "reminder"
  - "remind me"
metadata:
  category: productivity
  scope: notifications
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.0.0
  created_by: opencode-starter-kit
  dependencies:
    - cron
  optional_dependencies:
    - telegram
  tags: [reminder, notifications, scheduling, telegram]
  working_directory: ~/.config/opencode/skills/reminder
---

## Trigger

Type `remind` or `remind me to X in Y`

## Quick Usage

```
remind me to water plants in 2 hours
remind me to check server at 3pm
remind me daily at 9am to review tasks
remind list
remind cancel ID
```

## Docker Container (Optional)

### Reminder Service
```bash
cat > ~/docker/docker-compose.reminder.yml << 'EOF'
version: '3.8'
services:
  reminder-service:
    image: python:3.11-slim
    container_name: reminder-service
    restart: unless-stopped
    volumes:
      - ./reminder:/app
      - reminder_data:/data
    working_dir: /app
    environment:
      TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN}
      TELEGRAM_CHAT_ID: ${TELEGRAM_CHAT_ID}
      REMINDERS_DB: /data/reminders.json
    command: python reminder_daemon.py
    networks:
      - opencode

volumes:
  reminder_data:

networks:
  opencode:
    external: true
EOF

cd ~/docker && docker compose -f docker-compose.reminder.yml up -d
```

## How It Works

1. **Parse request** - Extract time, message, recurrence
2. **Create cron job** - Schedule the reminder
3. **Fire at time** - Send via Telegram

## Commands

### Set Reminder
```bash
# Via natural language
remind me to "call mom" in 2 hours

# Via script
~/.config/opencode/skills/reminder/scripts/reminder.sh "call mom" "2h"
```

### List Reminders
```bash
cat ~/.config/opencode/skills/reminder/context/reminders.json | jq '.'
```

### Cancel Reminder
```bash
# Remove from crontab
crontab -e  # Delete the reminder line

# Or via script
~/.config/opencode/skills/reminder/scripts/reminder.sh cancel REMINDER_ID
```

## Time Formats

| Format | Example | Meaning |
|--------|---------|---------|
| `Xm` | `30m` | X minutes |
| `Xh` | `2h` | X hours |
| `Xd` | `1d` | X days |
| `HH:MM` | `14:30` | Specific time today |
| `daily HH:MM` | `daily 9:00` | Every day at time |

## Scripts

### reminder.sh
```bash
#!/bin/bash
# ~/.config/opencode/skills/reminder/scripts/reminder.sh

MESSAGE="$1"
TIME="$2"
REMINDER_DIR=~/.config/opencode/skills/reminder

# Parse time
if [[ "$TIME" =~ ^([0-9]+)h$ ]]; then
    MINUTES=$((BASH_REMATCH[1] * 60))
elif [[ "$TIME" =~ ^([0-9]+)m$ ]]; then
    MINUTES=${BASH_REMATCH[1]}
else
    echo "Invalid time format. Use: Xm, Xh, or HH:MM"
    exit 1
fi

# Calculate cron time
FIRE_TIME=$(date -d "+$MINUTES minutes" +"%M %H %d %m *")

# Add to crontab
(crontab -l 2>/dev/null; echo "$FIRE_TIME ~/.config/opencode/skills/reminder/scripts/fire_reminder.sh \"$MESSAGE\"") | crontab -

# Store reminder
ID=$(date +%s)
jq ". += [{\"id\": \"$ID\", \"message\": \"$MESSAGE\", \"time\": \"$FIRE_TIME\", \"created\": \"$(date -Iseconds)\"}]" \
    "$REMINDER_DIR/context/reminders.json" > /tmp/reminders.json && \
    mv /tmp/reminders.json "$REMINDER_DIR/context/reminders.json"

echo "Reminder set: $MESSAGE (in $TIME)"
```

### fire_reminder.sh
```bash
#!/bin/bash
# ~/.config/opencode/skills/reminder/scripts/fire_reminder.sh

MESSAGE="$1"

# Send via Telegram
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="⏰ Reminder: $MESSAGE" \
    > /dev/null

# Remove from crontab after firing
crontab -l | grep -v "$MESSAGE" | crontab -
```

## Requirements

| Requirement | How to Set Up |
|-------------|----------------|
| Telegram bot | See telegram skill |
| Cron | Usually pre-installed |
| jq | `apt install jq` |

## Configuration

```bash
# Ensure directories exist
mkdir -p ~/.config/opencode/skills/reminder/{context,scripts}

# Initialize reminders file
echo '[]' > ~/.config/opencode/skills/reminder/context/reminders.json
```

## Cron Integration

Reminders create cron jobs:
```bash
# Check reminder cron jobs
crontab -l | grep reminder
```

## Troubleshooting

### Reminder Not Firing
1. Check cron: `systemctl status cron`
2. Verify crontab entry: `crontab -l`
3. Check Telegram credentials
4. Test fire script manually

### Telegram Not Working
1. Check `TELEGRAM_BOT_TOKEN`
2. Check `TELEGRAM_CHAT_ID`
3. Test: `curl "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe"`

## Related Skills

- **cron** - The underlying scheduler
- **telegram** - Notification delivery
- **news** - Daily news digest

---
*Trigger: `remind` or `reminder`*
