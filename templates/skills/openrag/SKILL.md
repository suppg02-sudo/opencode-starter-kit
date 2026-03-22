---
name: openrag
description: Document retrieval stack with Langflow, OpenSearch, and Docling
color: "#06B6D4"
license: MIT
trigger_words:
  - "rag"
  - "openrag"
  - "document search"
metadata:
  category: ai
  scope: document-retrieval
  last_updated: 2026-03-22
---

## Trigger

Type `rag` to see OpenRAG options

## Quick Usage

```
rag search "query"
rag ingest /path/to/document.pdf
rag status
```

## Components

| Service | Port | Purpose |
|---------|------|---------|
| Langflow | 7860 | Visual flow builder |
| OpenSearch | 9200 | Vector search |
| Docling | 5001 | Document parsing |

## Commands

### Search Documents
```bash
curl -X POST http://localhost:9200/documents/_search -d '{"query": {"match": {"content": "query"}}}'
```

### Ingest Document
```bash
curl -X POST http://localhost:5001/parse -F "file=@document.pdf"
```

### Check Status
```bash
curl http://localhost:9200/_cluster/health
curl http://localhost:7860/health
```

## Requirements

- Docker running
- OpenRAG stack deployed

## Dashboard

- Langflow: http://SERVER_HOST:7860
- OpenSearch: http://SERVER_HOST:5601 (if Dashboards installed)

---
*Trigger: `rag` or `openrag`*
