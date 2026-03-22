---
name: presentation
version: 1.0.0
description: Manage presentation creation across multiple platforms (Slidev, Reveal.js, Marp, Pandoc) with export capabilities (PDF, PPTX, HTML, images)
trigger: create presentation | make presentation | new presentation | build presentation | create slides
maturity: L3
created: 2026-03-22
dependencies:
  - docker
tags:
  - presentation
  - slides
  - pptx
  - pdf
---

# Presentation Skill

Create and export presentations across multiple platforms.

## Overview

Multi-platform presentation management with:
- **Slidev** (primary): Markdown-based, Vue.js powered, Docker containerized
- **Reveal.js**: HTML-based, rich plugin ecosystem
- **Marp**: Markdown to PDF conversion
- **Pandoc**: Universal document converter

Export formats: PDF, PPTX, HTML, PNG images

## Trigger Commands

- `create presentation` - Start new presentation
- `make presentation` - Create from template
- `create slides` - Quick slide creation

---

## Section 1: Platform Selection

```json
{
  "questions": [{
    "question": "Which presentation platform?",
    "header": "Platform",
    "options": [
      {"label": "Slidev (Recommended)", "description": "Markdown-based, Docker containerized, auto-reload"},
      {"label": "Pandoc", "description": "Universal converter - Markdown → PPTX/PDF/HTML"},
      {"label": "Reveal.js", "description": "HTML-based, rich plugins"},
      {"label": "Marp", "description": "Markdown to PDF slides"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Section 2: Slidev Setup

### Docker Compose

```yaml
services:
  slidev:
    image: tangramor/slidev:latest
    container_name: slidev
    restart: unless-stopped
    ports:
      - "${PORT_SLIDEV:-3030}:3030"
    tty: true
    stdin_open: true
    environment:
      - VITE_SERVER_ORIGIN=http://${SERVER_HOST:-localhost}:${PORT_SLIDEV:-3030}
      - HOST=${SERVER_HOST:-localhost}
    volumes:
      - ./presentations:/app
    working_dir: /app
    command: ["slidev", "slides.md", "--port", "3030", "--remote", "--bind", "0.0.0.0"]
```

### Commands

```bash
# Start container
docker-compose up -d

# Export to PDF
docker-compose exec slidev slidev export slides.md

# Export to PNG
docker-compose exec slidev slidev export slides.md --format png
```

---

## Section 3: Presentation Template

```markdown
---
title: "Presentation Title"
theme: default
class: text-center
highlighter: shiki
lineNumbers: false
transition: slide-left
---

# Welcome Slide

Content goes here with markdown formatting.

---

layout: center
class: text-center
---

# Centered Title

Centered content...

---

layout: image-right
image: https://images.unsplash.com/photo-123456/800x600
---

# Slide with Image

Content on left, image on right.

<v-clicks>
- Item 1
- Item 2
- Item 3
</v-clicks>
```

---

## Section 4: Export Options

### Via Browser

1. Navigate to `http://${SERVER_HOST}:3030/export/`
2. Select format: PDF, PPTX, or PNG
3. Download file

### Via CLI

```bash
# PDF export
pandoc slides.md -o presentation.pdf --pdf-engine=weasyprint

# PPTX export
pandoc slides.md -o presentation.pptx

# HTML export
pandoc slides.md -o presentation.html -s --toc
```

---

## Section 5: Troubleshooting

### Container Exits Immediately

Add TTY support:
```yaml
tty: true
stdin_open: true
```

### Port Already in Use

Change port in docker-compose.yml:
```yaml
ports:
  - "3031:3030"  # Use different host port
```

---

## Menu Configuration

**Trigger**: `create presentation`

```json
{
  "questions": [{
    "question": "Presentation - What would you like to do?",
    "header": "Presentation",
    "options": [
      {"label": "Create New Presentation (Recommended)", "description": "Start from template"},
      {"label": "Start Slidev Container", "description": "Launch presentation server"},
      {"label": "Export to PPTX", "description": "Generate PowerPoint file"},
      {"label": "Export to PDF", "description": "Generate PDF slides"},
      {"label": "View Presentations", "description": "List existing presentations"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Related Skills

- **glm-slide**: AI-powered slide generation via Z.ai API
- **blog-post-creator**: Publish presentations as blog posts

---

## History

**Created**: 2026-03-22
