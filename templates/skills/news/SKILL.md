---
name: news
description: News aggregation from Hacker News, GitHub Trending, and custom RSS feeds
color: "#FF6600"
license: MIT
compatibility: opencode
trigger_words:
  - "news"
  - "hn"
  - "hackernews"
  - "daily"
metadata:
  category: productivity
  scope: news
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.0.0
  created_by: opencode-starter-kit
  dependencies:
    - python3
    - curl
  optional_dependencies:
    - telegram
  tags: [news, hackernews, rss, aggregation]
  working_directory: ~/.config/opencode/skills/news
---

## Trigger

Type `news` to get latest tech news.

## Quick Usage

```
news                 # Tech news (default)
news tech            # Tech news
news ai              # AI/ML news
news geopolitics     # Geopolitics news
news daily           # Daily briefing
news github          # GitHub trending
```

## Docker Container (Optional)

### News Aggregator Stack
```bash
cat > ~/docker/docker-compose.news.yml << 'EOF'
version: '3.8'
services:
  news-aggregator:
    image: python:3.11-slim
    container_name: news-aggregator
    restart: unless-stopped
    ports:
      - "5005:5000"
    volumes:
      - ./news:/app
      - news_data:/data
    working_dir: /app
    environment:
      FEEDS_CONFIG: /data/feeds.json
      SEEN_URLS: /data/seen_urls.json
    command: python app.py
    networks:
      - opencode

volumes:
  news_data:

networks:
  opencode:
    external: true
EOF

cd ~/docker && docker compose -f docker-compose.news.yml up -d
```

API: http://SERVER_HOST:5005

## Sources

| Source | Type | Trigger |
|--------|------|---------|
| Hacker News | Tech | default, `news tech` |
| GitHub Trending | Code | `news github` |
| Custom RSS | Configurable | `news rss` |
| Reddit | Communities | `news reddit` |

## Commands

### Fetch News
```bash
# Hacker News top 10
curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" | \
  jq '.[:10]' | \
  jq -r '.[]' | \
  while read id; do
    curl -s "https://hacker-news.firebaseio.com/v0/item/$id.json" | \
      jq -r '"\(.title) - \(.url) (\(.score) pts)"'
  done
```

### GitHub Trending
```bash
curl -s "https://api.github.com/repos?since=daily" | \
  jq -r '.[] | "\(.full_name): \(.description) (\(.stargazers_count) stars)"' | \
  head -10
```

### Custom RSS
```bash
# Using Python
python3 << 'PYTHON'
import feedparser
feed = feedparser.parse("https://techcrunch.com/feed/")
for entry in feed.entries[:10]:
    print(f"{entry.title} - {entry.link}")
PYTHON
```

## Configuration

### RSS Feeds
```bash
mkdir -p ~/.config/opencode/skills/news/context

cat > ~/.config/opencode/skills/news/context/rss-feeds.json << 'EOF'
{
  "tech": [
    {"name": "TechCrunch", "url": "https://techcrunch.com/feed/"},
    {"name": "Ars Technica", "url": "https://feeds.arstechnica.com/arstechnica/index"},
    {"name": "The Verge", "url": "https://www.theverge.com/rss/index.xml"}
  ],
  "ai": [
    {"name": "AI News", "url": "https://artificialintelligence-news.com/feed/"},
    {"name": "MIT AI", "url": "https://www.technologyreview.com/feed/"}
  ],
  "geopolitics": [
    {"name": "BBC World", "url": "https://feeds.bbci.co.uk/news/world/rss.xml"},
    {"name": "Reuters", "url": "https://www.reutersagency.com/feed/"}
  ]
}
EOF
```

## Deduplication

### Tracking Seen URLs
```bash
# Location
~/.config/opencode/skills/news/context/seen_urls.json

# Format
{
  "urls": ["url1", "url2", ...],
  "last_updated": "2026-03-22T10:00:00Z"
}

# Maintenance (prune after 500)
jq '.urls = .urls[-500:]' seen_urls.json > tmp.json && mv tmp.json seen_urls.json
```

## Output Format

```
1. [Title](url) - Source
   Score: 123 | Comments: 45 | Source: Hacker News
   
2. [Next Article](url) - Source
   Score: 98 | Comments: 23 | Source: TechCrunch
```

## Cron Integration

### Daily News Digest
```bash
# Add to crontab
0 8 * * * /root/.config/opencode/skills/news/scripts/fetch-news.sh | mail -s "Daily News" user@example.com
```

### Telegram Notifications
```bash
# Send to Telegram
news | telegram send "$(cat -)"
```

## Scripts

### fetch-news.sh
```bash
#!/bin/bash
# Fetch and format news
curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" | \
  jq -r '.[:10][]' | \
  while read id; do
    curl -s "https://hacker-news.firebaseio.com/v0/item/$id.json"
  done | \
  jq -r '"\(.title)\n  \(.url) (\(.score) pts)\n"'
```

## Related Skills

- **blog-post-creator** - Create blog from news
- **telegram** - Send news digest
- **cron** - Schedule news fetches

---
*Trigger: `news`, `hn`, `hackernews`, or `daily`*
