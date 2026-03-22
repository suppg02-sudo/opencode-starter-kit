---
name: blog-post-creator
version: 1.0.0
description: Create Hugo blog posts with YouTube video pipeline integration
trigger: blog | blog post | new post | bp
maturity: L3
created: 2026-03-22
dependencies:
  - hugo
tags:
  - content
  - blogging
  - hugo
---

# Blog Post Creator

Create Hugo blog posts with YouTube video pipeline integration.

## Trigger Commands

- `blog` - Create new blog post
- `bp` - Short form
- `blog create "title"` - Create with specific title

---

## Section 1: Hugo Setup

### Docker Installation

```bash
# Create Hugo directory
mkdir -p ~/docker/website
cd ~/docker/website

# Create docker-compose.yml (use template from starter kit)
cp /path/to/starter-kit/templates/docker/docker-compose.hugo.yml docker-compose.yml

# Initialize new Hugo site
docker-compose run hugo hugo new site .

# Start Hugo server
docker-compose up -d
```

### Directory Structure

```
~/docker/website/
├── docker-compose.yml
├── config.toml           # Hugo config
├── content/
│   └── posts/
│       └── my-post/
│           ├── index.md
│           └── images/
├── layouts/
├── static/
├── themes/
└── public/              # Generated site
```

### Hugo Configuration (config.toml)

```toml
baseURL = 'https://yourdomain.com/'
languageCode = 'en-us'
title = 'My Blog'

[params]
  description = 'Blog description'
  author = 'Your Name'

[menu]
  [[menu.main]]
    name = 'Home'
    url = '/'
    weight = 1
  [[menu.main]]
    name = 'Posts'
    url = '/posts/'
    weight = 2
```

---

## Section 2: Create Blog Post

### Manual Creation

```bash
# Create new post
hugo new posts/my-post/index.md

# Or use CLI script
~/.config/opencode/skills/blog-post-creator/scripts/blog-cli.sh create "My Post Title"
```

### From YouTube URL

```
blog https://youtube.com/watch?v=VIDEO_ID
```

This triggers:
1. Transcription skill extracts transcript
2. Summary generated
3. Blog post created automatically

---

## Section 3: Post Structure

### File Location

```
~/docker/website/content/posts/{slug}/
├── index.md
└── images/
    └── cover.jpg
```

### Frontmatter Template

```yaml
---
title: "Post Title"
date: 2026-03-22
lastmod: 2026-03-22
draft: false
description: "Brief description for SEO"
tags: [tag1, tag2]
categories: [category]
image: /posts/{slug}/images/cover.jpg
---
```

### Content Template

```markdown
## Introduction

Brief intro paragraph.

## Main Content

Your content here...

## Conclusion

Wrap up.

---

*Published: {{ .Date }}*
```

---

## Section 4: Hugo Commands

### Development

```bash
# Start dev server
docker-compose up -d

# View at http://${SERVER_HOST}:1313

# Live reload enabled by default
```

### Build & Deploy

```bash
# Build static site
docker-compose exec hugo hugo

# Output in public/ directory

# Deploy (example with rsync)
rsync -avz public/ user@server:/var/www/blog/
```

### Content Management

```bash
# List all posts
docker-compose exec hugo hugo list all

# Check for draft posts
docker-compose exec hugo hugo list drafts

# Clean public directory
rm -rf public/
```

---

## Section 5: Menu Configuration

**Trigger**: `blog` or `bp`

```json
{
  "questions": [{
    "question": "Blog Post Creator - What would you like to do?",
    "header": "Blog",
    "options": [
      {"label": "Create New Post (Recommended)", "description": "Start writing a new blog post"},
      {"label": "Create from YouTube", "description": "Generate post from video URL"},
      {"label": "List Posts", "description": "View all existing posts"},
      {"label": "Start Hugo Server", "description": "Launch development server"},
      {"label": "Build Site", "description": "Generate static files"},
      {"label": "Setup Hugo", "description": "Initialize Hugo blog"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Section 6: CLI Script

### blog-cli.sh

```bash
#!/bin/bash
# Blog Post Creator CLI

BLOG_DIR="${BLOG_DIR:-$HOME/docker/website}"
SKILL_DIR="$HOME/.config/opencode/skills/blog-post-creator"

case "$1" in
  create)
    TITLE="$2"
    SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    POST_DIR="$BLOG_DIR/content/posts/$SLUG"
    mkdir -p "$POST_DIR/images"
    
    cat > "$POST_DIR/index.md" << EOF
---
title: "$TITLE"
date: $(date +%Y-%m-%d)
draft: true
tags: []
---
    
# $TITLE
    
Content goes here...
EOF
    
    echo "Created: $POST_DIR/index.md"
    ;;
    
  list)
    ls -la "$BLOG_DIR/content/posts/"
    ;;
    
  serve)
    cd "$BLOG_DIR" && docker-compose up -d
    echo "Hugo server running at http://localhost:1313"
    ;;
    
  build)
    cd "$BLOG_DIR" && docker-compose exec hugo hugo
    echo "Site built to $BLOG_DIR/public/"
    ;;
    
  *)
    echo "Usage: blog-cli.sh {create|list|serve|build}"
    ;;
esac
```

---

## Related Skills

- **transcription** - YouTube video to blog pipeline
- **presentation** - Convert slides to blog posts

---

## History

**Created**: 2026-03-22
