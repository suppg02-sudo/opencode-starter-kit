---
name: research
description: Deep research mode with evidence-based methodology and citation tracking
color: "#8B5CF6"
license: MIT
compatibility: opencode
trigger_words:
  - "research"
  - "r"
  - "deep"
  - "investigate"
  - "verify"
metadata:
  category: productivity
  scope: research
  output_format: markdown
  last_updated: 2026-03-22
  version: 1.0.0
  created_by: opencode-starter-kit
  dependencies:
    - curl
    - python3
  optional_dependencies:
    - context7
    - openrag
  tags: [research, verification, citations, analysis]
---

## Trigger

Type `research` or `r` to start deep research mode.

## Quick Usage

```
research topic              # Deep dive on topic
r compare React vs Vue      # Compare options
research verify "claim"     # Verify claim with sources
r analyze topic             # Multi-perspective analysis
```

## Research Modes

| Mode | Use For | Sources | Time |
|------|---------|---------|------|
| Quick | Simple lookups | 1-2 | 1 min |
| Standard | Most topics | 3-5 | 3 min |
| Deep | Complex topics | 10+ | 10+ min |
| Verify | Fact-checking | 5+ | 5 min |

## Process

1. **Clarify** - Understand the question
2. **Search** - Find relevant sources
3. **Verify** - Cross-reference claims
4. **Synthesize** - Combine findings
5. **Cite** - Provide sources

## Commands

### Research Topic
```
research "What are the best practices for API authentication?"
```
Agent will:
1. Search web for sources
2. Verify claims across sources
3. Summarize with citations
4. Save to memory

### Compare Options
```
research compare React vs Vue vs Svelte
```
Returns: Feature comparison table with recommendations

### Verify Claim
```
research verify "TypeScript is faster than JavaScript"
```
Returns: True/False/Partial with evidence

### Deep Analysis
```
r analyze "microservices vs monolith"
```
Returns: Pros/cons, use cases, recommendations

## Output Format

```markdown
# Research: Topic

## Summary
Brief answer (2-3 sentences)

## Key Findings
- Finding 1
- Finding 2
- Finding 3

## Details
Extended analysis with subsections

## Comparison (if applicable)
| Option | Pros | Cons |
|--------|------|------|
| A | ... | ... |
| B | ... | ... |

## Sources
1. [Title](url) - Date - Credibility: High/Medium/Low
2. [Title](url) - Date

## Confidence: High/Medium/Low

## Recommendations
- Primary recommendation
- Alternative approaches
```

## Research Sources

### Primary
| Source | Use For |
|--------|---------|
| Official docs | Definitive answers |
| GitHub repos | Code examples |
| Stack Overflow | Solutions, issues |
| Academic papers | Research, evidence |

### Secondary
| Source | Use For |
|--------|---------|
| Blog posts | Tutorials, opinions |
| News articles | Current events |
| Reddit/HN | Community discussion |

## Docker Container (Optional)

### Research Stack with RAG
```bash
cat > ~/docker/docker-compose.research.yml << 'EOF'
version: '3.8'
services:
  research-rag:
    image: ghcr.io/opencode/research-rag:latest
    container_name: research-rag
    restart: unless-stopped
    ports:
      - "8002:8000"
    volumes:
      - research_data:/data
    environment:
      EMBEDDING_MODEL: all-MiniLM-L6-v2
      DATABASE_PATH: /data/research.db
    networks:
      - opencode

volumes:
  research_data:

networks:
  opencode:
    external: true
EOF

cd ~/docker && docker compose -f docker-compose.research.yml up -d
```

API: http://SERVER_HOST:8002

## Integration

### Save to Memory
```bash
# Automatic after research
pghmem save "Research: topic - key finding" --type decision --tags research
```

### Export to Blog
```
research "topic" | blog create
```

### Use with Context7
```
research react hooks --with-context7
```

## Verification Criteria

| Factor | Weight | Check |
|--------|--------|-------|
| Source authority | High | Official docs > Blogs |
| Recency | Medium | Date within 2 years |
| Corroboration | High | Multiple sources agree |
| Methodology | Medium | Citations, evidence |

## Troubleshooting

### Conflicting Sources
1. Check publication dates
2. Verify source authority
3. Look for consensus
4. Note disagreement in output

### Outdated Information
1. Always check dates
2. Prefer official docs
3. Cross-reference with recent sources

## Related Skills

- **brainstorming** - Design exploration
- **blog-post-creator** - Publish research
- **openrag** - Document retrieval
- **context7** - Library documentation

---
*Trigger: `research`, `r`, `deep`, `investigate`, or `verify`*
