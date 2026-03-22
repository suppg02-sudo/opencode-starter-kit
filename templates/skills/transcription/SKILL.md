# Transcription Skill

## Overview
YouTube video transcript extraction with automatic blog post creation.

**Trigger**: Paste a YouTube URL when chatting

## Automatic Workflow

When you paste a YouTube URL, the skill runs automatically:

1. **Extract** transcript via youtube-transcript-api
2. **Validate** quality (min 200 segments)
3. **Summarize** comprehensively (800-1200 words)
4. **Create** short summary (2-3 sentences)
5. **Publish** to Hugo blog via blog-post-creator
6. **Notify** via Telegram (if configured)

**No user intervention required** - all phases execute automatically.

## Manual Usage

```bash
# Extract transcript
python3 skills/transcription/transcription.py "https://youtube.com/watch?v=VIDEO_ID"

# With options
python3 skills/transcription/transcription.py "URL" --summary --blog
```

## Dependencies

- `youtube-transcript-api` (pip install)
- Blog-post-creator skill (for publishing)

## Output Location

- Transcripts: `~/.config/opencode/docs/output/youtube_*.md`
- Blog posts: `~/docker/website/content/posts/`

## Configuration

Edit `~/.config/opencode/skills/transcription/SKILL.md` for advanced options.

---
*YouTube Pipeline: URL → Transcript → Summary → Blog Post*
