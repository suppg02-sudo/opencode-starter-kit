---
name: research
description: Deep research mode with evidence-based methodology
color: "#8B5CF6"
license: MIT
trigger_words:
  - "research"
  - "r"
  - "deep"
metadata:
  category: productivity
  scope: research
  last_updated: 2026-03-22
---

## Trigger

Type `research` or `r` to start deep research mode.

## Quick Usage

```
research topic       # Deep dive on topic
r compare X vs Y     # Compare options
research verify X    # Verify claim with sources
```

## Research Modes

| Mode | Use For | Depth |
|------|---------|-------|
| Quick | Simple lookups | 1-2 sources |
| Standard | Most topics | 3-5 sources |
| Deep | Complex topics | 10+ sources, citations |

## Process

1. **Clarify** - Understand the question
2. **Search** - Find relevant sources
3. **Verify** - Cross-reference claims
4. **Synthesize** - Combine findings
5. **Cite** - Provide sources

## Commands

### Research Topic
```bash
# Agent will:
# 1. Search web for sources
# 2. Verify claims across sources
# 3. Summarize with citations
# 4. Save to memory
```

### Compare Options
```
research compare React vs Vue vs Svelte
```
Returns: Feature comparison table with recommendations

### Verify Claim
```
research verify "Claim to verify"
```
Returns: True/False/Partial with evidence

## Output Format

```markdown
# Research: Topic

## Summary
Brief answer (2-3 sentences)

## Details
- Point 1
- Point 2

## Sources
1. [Title](url) - Date
2. [Title](url) - Date

## Confidence: High/Medium/Low
```

## Integration

- Results saved to memory automatically
- Can export to blog post
- Citations tracked

## Related Skills

- **brainstorming** - Design exploration
- **blog-post-creator** - Publish research

---
*Trigger: `research` or `r`*
