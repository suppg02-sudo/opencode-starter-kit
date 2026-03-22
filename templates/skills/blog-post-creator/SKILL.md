---
name: blog-post-creator
description: Create Hugo blog posts with YouTube video pipeline integration
color: "#10B981"
license: MIT
trigger_words:
  - "blog"
  - "blog post"
  - "new post"
metadata:
  category: content
  scope: blogging
  last_updated: 2026-03-22
---

## Trigger

Type `blog` or `blog create "title"`

## Quick Usage

```
blog create "My New Post"
blog https://youtube.com/watch?v=xxx
```

## Commands

### Create Post
```bash
~/.config/opencode/skills/blog-post-creator/scripts/blog-cli.sh create "Title"
```

### From YouTube
```
blog https://youtube.com/watch?v=VIDEO_ID
```
This triggers the transcription pipeline automatically.

## Structure

Posts are created in:
```
~/docker/website/content/posts/
├── post-slug/
│   ├── index.md
│   └── images/
```

## Frontmatter

```yaml
---
title: "Post Title"
date: 2026-03-22
draft: false
tags: [tag1, tag2]
categories: [category]
---
```

## Requirements

- Hugo blog set up
- YouTube transcription skill (for video posts)

## Related Skills

- **transcription** - YouTube video to blog pipeline

---
*Trigger: `blog` or `bp`*
