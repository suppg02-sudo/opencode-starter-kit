---
name: telegram
description: Telegram bot integration - AI chat, notifications, system commands, blog publishing
color: "#0088cc"
license: MIT
compatibility: opencode
trigger_words:
  - "telegram"
  - "tg"
  - "notify"
  - ">t"
metadata:
  category: communication
  scope: notifications
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.0.0
  created_by: opencode-starter-kit
  dependencies:
    - curl
    - jq
  optional_dependencies:
    - python3
  tags: [telegram, bot, notifications, chat]
---

## Trigger

Type `telegram`, `tg`, `notify`, or `>t` to send messages.

## Quick Usage

```
notify "Server backup complete"
telegram send "Alert: disk space low"
>t                  # Send last response via Telegram
```

## Docker Container (Optional)

### Option 1: Python Telegram Bot Container
```bash
# Create docker-compose.telegram.yml
cat > ~/docker/docker-compose.telegram.yml << 'EOF'
version: '3.8'
services:
  telegram-bot:
    image: python:3.11-slim
    container_name: telegram-bot
    restart: unless-stopped
    environment:
      TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN}
      TELEGRAM_CHAT_ID: ${TELEGRAM_CHAT_ID}
    volumes:
      - ./telegram-bot:/app
    working_dir: /app
    command: python bot.py
    networks:
      - opencode
networks:
  opencode:
    external: true
EOF

# Start container
cd ~/docker && docker compose -f docker-compose.telegram.yml up -d
```

### Option 2: Direct API (No Container)
```bash
# Set environment variables
export TELEGRAM_BOT_TOKEN="your-bot-token"
export TELEGRAM_CHAT_ID="your-chat-id"
```

## Setup

### 1. Create Bot
1. Open [@BotFather](https://t.me/botfather) in Telegram
2. Send `/newbot`
3. Follow prompts, save the token

### 2. Get Chat ID
```bash
# Send message to your bot, then:
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates" | jq '.result[0].message.chat.id'
```

### 3. Configure Environment
```bash
# Add to ~/.config/opencode/.paths or .env
echo "TELEGRAM_BOT_TOKEN=your-token" >> ~/docker/.env
echo "TELEGRAM_CHAT_ID=your-chat-id" >> ~/docker/.env
```

## Commands

### Send Message
```bash
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d text="Message here" \
  -d parse_mode="Markdown"
```

### Send with Buttons
```bash
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d text="Choose:" \
  -d reply_markup='{"inline_keyboard":[[{"text":"Yes","callback_data":"yes"},{"text":"No","callback_data":"no"}]]}'
```

### Send Photo
```bash
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendPhoto" \
  -F chat_id="${TELEGRAM_CHAT_ID}" \
  -F photo="@/path/to/image.png"
```

### Send Document
```bash
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument" \
  -F chat_id="${TELEGRAM_CHAT_ID}" \
  -F document="@/path/to/file.pdf"
```

## Integration Points

| Skill | Integration |
|-------|-------------|
| reminder | Sends scheduled reminders |
| cron | Notification on job completion |
| blog-post-creator | Notify when post published |
| health-check | Send alerts on failures |

## Troubleshooting

### Bot Not Responding
```bash
# Check bot status
curl "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe"

# Check for updates
curl "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates"
```

### Rate Limits
- 30 messages/second max
- 20 messages/minute to same group
- Use `parse_mode="HTML"` for formatting

### Common Errors
| Error | Fix |
|-------|-----|
| 401 Unauthorized | Check bot token |
| 400 Bad Request | Check chat ID format |
| 429 Too Many Requests | Add delay between messages |

## Scripts

### notify.sh
```bash
#!/bin/bash
# ~/.config/opencode/scripts/notify.sh
MESSAGE="${1:-Notification}"
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d text="$MESSAGE" \
  -d parse_mode="Markdown" > /dev/null
```

## Related Skills

- **reminder** - Scheduled Telegram reminders
- **cron** - Trigger notifications from cron jobs
- **news** - Send news digest via Telegram

---
*Trigger: `telegram`, `tg`, `notify`, or `>t`*
