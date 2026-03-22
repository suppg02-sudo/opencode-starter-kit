---
name: news
description: News aggregation from Hacker News, GitHub, and custom sources
color: "#FF6600"
license: MIT
trigger_words:
  - "news"
  - "hn"
  - "hackernews"
metadata:
  category: productivity
  scope: news
  last_updated: 2026-03-22
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
```

## Sources

| Source | Type | Trigger |
|--------|------|---------|
| Hacker News | Tech | default |
| GitHub Trending | Code | `news github` |
| Custom RSS | Configurable | `news rss` |

## Commands

### Fetch News
```bash
python3 ~/.config/opencode/skills/news/scripts/fetch_news.py --source hn --limit 10
```

### Search News
```bash
python3 ~/.config/opencode/skills/news/scripts/fetch_news.py --search "topic"
```

## Output

News items displayed as:
```
1. [Title](url) - source
   Score: 123 | Comments: 45
   
2. ...
```

## Deduplication

- Previously seen URLs tracked in `seen_urls.json`
- Only new items shown
- Prunes after 500 entries

## Configuration

```json
// ~/.config/opencode/skills/news/context/rss-feeds.json
{
  "feeds": [
    {"name": "TechCrunch", "url": "https://techcrunch.com/feed/"},
    {"name": "Ars Technica", "url": "https://feeds.arstechnica.com/arstechnica/index"}
  ]
}
```

## Related Skills

- **blog-post-creator** - Create blog from news
- **telegram** - Send news digest

---
*Trigger: `news` or `hn`*
