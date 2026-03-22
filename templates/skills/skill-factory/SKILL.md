---
name: skill-factory
version: 1.0.0
description: Meta-skill for creating and updating skills with consistent structure, progressive disclosure, and optional RAG integration
trigger: skill-factory | sf | skill-create
maturity: L3
created: 2026-03-22
dependencies:
  - question-tool
tags:
  - meta
  - skill-management
  - automation
---

# Skill Factory

Meta-skill for creating and updating skills with consistent structure.

## Overview

This skill provides a standardized protocol for:
- Creating consistent filing structures
- Implementing progressive disclosure with sections
- Managing documentation
- Setting up scripts, cron jobs, and menus
- Registering triggers in AGENTS.md

## Trigger Commands

- `skill-factory` - Full skill creation/update workflow
- `sf` - Short form
- `skill-create` - Alias

---

## Section 1: Skill Type Selection

```json
{
  "questions": [{
    "question": "What type of skill operation?",
    "header": "Skill Type",
    "options": [
      {"label": "Create New Skill (Recommended)", "description": "Full new skill creation from scratch"},
      {"label": "Update Existing Skill", "description": "Modify existing skill with new features"},
      {"label": "Evolve Skill Level", "description": "Move skill to next maturity level (L1→L2, etc.)"},
      {"label": "Validate Skill Structure", "description": "Run quality gates and validation"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Section 2: Filing Structure

### Standard Directory Layout

```
~/.config/opencode/skills/{skill-name}/
├── SKILL.md              # Main skill file (REQUIRED)
├── scripts/              # Automation scripts
│   ├── install.sh        # Installation/setup
│   └── status.sh         # Status check
├── context/              # Progressive disclosure data
│   └── metadata.json     # Structured metadata
├── templates/            # Reusable templates
├── history/              # Historical data
│   └── changes.log       # Change history
└── docs/                 # Local documentation
```

### Creation Protocol

```bash
SKILL_PATH=~/.config/opencode/skills/{skill-name}
mkdir -p "$SKILL_PATH"/{scripts,context,templates,history,docs}
echo '{"created": "'$(date -I)'", "version": "1.0.0"}' > "$SKILL_PATH/context/metadata.json"
```

---

## Section 3: SKILL.md Template

```markdown
---
name: {skill-name}
version: 1.0.0
description: {description}
trigger: {trigger-words}
maturity: L{1-5}
created: {date}
dependencies: []
---

# {Skill Name}

## Overview
{Brief description}

## Trigger Commands
- `{trigger}` - {description}

---

## Section 1: {Feature Category}
### Purpose
{Why this section exists}

### Process
{Step-by-step instructions}

---

## Menu Configuration
{Menu options for trigger command}

## Scripts Reference
{Available scripts}

## Related Skills
{Linked skills}

## History
{Link to history file}
```

---

## Section 4: Backup Protocol

### When to Backup
- BEFORE any modifications to existing skills
- BEFORE merging or evolving skills

### Backup Process

```bash
BACKUP_DIR=~/.config/opencode/backups/skills
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"
cp -r ~/.config/opencode/skills/$SKILL_NAME "$BACKUP_DIR/${SKILL_NAME}_$TIMESTAMP"
```

---

## Section 5: Scripts & Automation

### Script Standards

```bash
#!/bin/bash
# Script: {action}.sh
# Purpose: {description}
# Usage: ./{action}.sh [options]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="{skill-name}"

log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

main() {
    log_info "Starting {action}..."
    # Implementation
    log_info "Completed"
}

main "$@"
```

---

## Section 6: Menu Configuration

### Standard Menu Structure

Every skill menu MUST include:
1. Domain-specific options
2. Exit option

```json
{
  "questions": [{
    "question": "{Skill Name} - What would you like to do?",
    "header": "{Skill} Menu",
    "options": [
      {"label": "Option 1 (Recommended)", "description": "Primary action"},
      {"label": "Option 2", "description": "Secondary action"},
      {"label": "View Status", "description": "Check current state"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Section 7: Trigger Registration

### AGENTS.md Update Protocol

After creating/updating a skill:

```markdown
**{trigger-word}** (on its own)
- Brief description
- Key features (bullet points)
- Location: `~/.config/opencode/skills/{skill-name}/SKILL.md`
```

---

## Section 8: Quality Gates

### Per-Maturity Level

| Level | Requirements | Validation |
|-------|--------------|------------|
| **L1** | SKILL.md exists | File present |
| **L2** | YAML metadata, sections | Schema validation |
| **L3** | Scripts attached | Scripts executable |
| **L4** | API documented | Endpoints tested |
| **L5** | MCP server | Tools registered |

---

## Section 9: Post-Creation Checklist

```json
{
  "questions": [{
    "question": "Skill created! What post-creation actions?",
    "header": "Post-Creation",
    "options": [
      {"label": "Validate structure (Recommended)", "description": "Run quality gates"},
      {"label": "Add to AGENTS.md", "description": "Update trigger documentation"},
      {"label": "Create trigger word", "description": "Add trigger for quick access"},
      {"label": "Save to backup", "description": "Include in version-controlled backup"},
      {"label": "All of the above", "description": "Run all post-creation actions"},
      {"label": "Done", "description": "No additional actions needed"}
    ],
    "multiple": true
  }]
}
```

---

## Quick Reference

### Complete Workflow Checklist

- [ ] Analyze requirements
- [ ] Ask: New or Update skill?
- [ ] Create filing structure
- [ ] Backup existing (if updating)
- [ ] Create SKILL.md with sections
- [ ] Create scripts (if L3+)
- [ ] Set up cron jobs (if needed)
- [ ] Configure menu options
- [ ] Register trigger in AGENTS.md
- [ ] Run quality gate validation
- [ ] Update backup repository

---

## Menu Configuration

**Trigger**: `skill-factory` | `sf` | `skill-create`

```json
{
  "questions": [{
    "question": "Skill Factory - What would you like to do?",
    "header": "Skill Factory",
    "options": [
      {"label": "Create New Skill (Recommended)", "description": "Full workflow for new skill creation"},
      {"label": "Update Existing Skill", "description": "Modify existing skill with new features"},
      {"label": "Evolve Skill Level", "description": "Advance skill to next maturity level"},
      {"label": "Validate Skill Structure", "description": "Run quality gates and validation"},
      {"label": "Backup All Skills", "description": "Create timestamped backups"},
      {"label": "Exit", "description": "Return to previous context"}
    ],
    "multiple": false
  }]
}
```

---

## Related Skills

- **menu-factory**: Menu standardization
- **menu-learning**: Adaptive menus
- **cron**: Scheduled tasks

---

## History

**Created**: 2026-03-22
