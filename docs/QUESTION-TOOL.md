# Question Tool Reference

## Overview

The question tool is **critical** for the starter kit's interactive menu system. All user choices MUST use this tool.

## Usage Pattern

```json
{
  "questions": [{
    "question": "What would you like to do?",
    "header": "Select Option",
    "options": [
      {"label": "Option A (Recommended)", "description": "Why this is best"},
      {"label": "Option B", "description": "Alternative choice"},
      {"label": "Exit", "description": "Cancel operation"}
    ],
    "multiple": false
  }]
}
```

## Key Rules

| Rule | Why |
|------|-----|
| Always use for choices | Provides consistent UX |
| Include "(Recommended)" | Guides users to best option |
| Always include "Exit" | Let users cancel |
| Use `multiple: true` | When several options valid |
| Use `multiple: false` | When only one choice |

## Common Patterns

### Preset Selection
```json
{
  "question": "Choose installation preset:",
  "options": [
    {"label": "Minimal (Recommended)", "description": "Core only, 2 min"},
    {"label": "Recommended", "description": "Full featured, 5 min"},
    {"label": "Full", "description": "Everything, 10 min"}
  ],
  "multiple": false
}
```

### Multi-Select Components
```json
{
  "question": "Select skills to install:",
  "options": [
    {"label": "Cron", "description": "Scheduled tasks"},
    {"label": "Reminder", "description": "Notifications"},
    {"label": "Blog", "description": "Content creation"}
  ],
  "multiple": true
}
```

### Confirmation
```json
{
  "question": "Proceed with installation?",
  "options": [
    {"label": "Yes, proceed (Recommended)", "description": "Start now"},
    {"label": "No, cancel", "description": "Abort"}
  ],
  "multiple": false
}
```

## Troubleshooting

If question tool doesn't work:
1. Ensure interactive session (not batch/cron)
2. Check OpenCode version
3. Verify no MCP conflicts
4. Run `check-question-tool.sh`
