---
name: glm-slide
version: 1.0.0
description: Create professional slides and posters using GLM Slide/Poster Agent from Z.ai with intelligent content gathering and visual design
trigger: ai slides | ai presentation | generate slides | glm slide
maturity: L3
created: 2026-03-22
dependencies:
  - zai-api-key
tags:
  - presentation
  - slides
  - ai-generated
  - zai
---

# GLM Slide Skill

AI-powered slide and poster generation via Z.ai GLM Slide Agent.

## Overview

Create professional presentations using AI:
- **Smart Information Search**: Auto-retrieve and organize relevant materials
- **Elegant Visual Design**: Built-in professional visual standards
- **Rich Content Display**: Text, charts, and multimedia integration
- **One-Click Generation**: Natural language to polished slides

## Trigger Commands

- `ai slides` - Generate slides with AI
- `ai presentation` - Create AI presentation
- `generate slides` - AI-powered generation

---

## Section 1: API Configuration

### Required

Get API key from: https://platform.zhipu.ai/

```bash
export ZAI_API_KEY="your_api_key_here"
```

### API Endpoint

```
POST https://open.bigmodel.cn/api/paas/v4/agents/agent
Authorization: Bearer YOUR_API_KEY
Content-Type: application/json
```

### Cost

- **Pricing**: $0.7 per 1M tokens (pay-as-you-go)
- **Billing**: Automatic token counting across generation workflow

---

## Section 2: Generate Slides

### Basic Request

```bash
curl -X POST https://open.bigmodel.cn/api/paas/v4/agents/agent \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "agent_name": "slide_poster",
    "prompt": "Create a presentation about container orchestration best practices"
  }'
```

### Advanced Request

```bash
curl -X POST https://open.bigmodel.cn/api/paas/v4/agents/agent \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "agent_name": "slide_poster",
    "prompt": "Create a product launch poster for new AI model",
    "page_count": 5,
    "style": "professional",
    "language": "en"
  }'
```

---

## Section 3: Example Prompts

### Business Presentations

- "Create a quarterly business review with revenue metrics"
- "Generate a project roadmap presentation for Q1 2026"
- "Design a competitor analysis for executive team"

### Educational Content

- "Create teaching slides on machine learning fundamentals"
- "Generate workshop training on cybersecurity basics"
- "Design academic poster for ML conference"

### Personal Projects

- "Create personal portfolio highlighting my skills"
- "Generate event invitation poster for tech meetup"
- "Design knowledge sharing about remote work"

---

## Section 4: Workflow

1. **Describe Your Needs** - Enter topic in natural language
2. **Smart Information Gathering** - AI searches and organizes content
3. **Slide/Poster Generation** - Creates visually engaging output
4. **Refinement** - Modify based on feedback
5. **Export** - Download as PDF (PPTX coming soon)

---

## Section 5: Response Format

The API returns:
- **PDF Download**: Direct download link
- **PPTX Export**: Coming soon
- **Content Structure**: Organized slides with layouts
- **Metadata**: Generation statistics, token usage

---

## Menu Configuration

**Trigger**: `ai slides`

```json
{
  "questions": [{
    "question": "GLM Slide - What would you like to create?",
    "header": "AI Slides",
    "options": [
      {"label": "Business Presentation (Recommended)", "description": "Reports, roadmaps, analysis"},
      {"label": "Educational Slides", "description": "Teaching, training, academic"},
      {"label": "Poster", "description": "Event, product launch, invitation"},
      {"label": "Personal Portfolio", "description": "Skills showcase, knowledge sharing"},
      {"label": "Custom Prompt", "description": "Describe what you need"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Related Skills

- **presentation**: Manual slide creation with Slidev, Pandoc
- **blog-post-creator**: Publish presentations as blog posts

---

## History

**Created**: 2026-03-22
