---
name: telegram
description: Telegram bot integration - AI chat, notifications, system commands
color: "#0088cc"
license: MIT
trigger_words:
  - "telegram"
  - "tg"
  - "notify"
metadata:
  category: communication
  scope: notifications
  last_updated: 2026-03-22
---

## Trigger

Type `telegram` or `notify` to send messages via Telegram bot.

## Quick Usage

```
notify "Server backup complete"
telegram send "Alert: disk space low"
>t                  # Shorthand - send last response via Telegram
```

## Setup Requirements

1. Create Telegram bot via [@BotFather](https://t.me/botfather)
2. Get bot token and chat ID
3. Set environment variables:
```bash
export TELEGRAM_BOT_TOKEN="your-token"
export TELEGRAM_CHAT_ID="your-chat-id"
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
  -d reply_markup='{"inline_keyboard":[[{"text":"Option A","callback_data":"a"}]]}'
```

## Integration Points

- **Reminder skill** - Sends scheduled reminders
- **Cron jobs** - Notification on completion
- **System alerts** - Disk space, errors

## Troubleshooting

### Bot Not Responding
1. Check token: `curl "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe"`
2. Verify chat ID: Send message to bot, then check `getUpdates`
3. Check rate limits (30 messages/sec max)

---
*Trigger: `telegram`, `tg`, or `notify`*
