# Phase 3: Skills

**Installs**: Selected skill packages
**Duration**: ~1-2 minutes

## Execute

```bash
setup/scripts/copy-skills.sh ${SELECTED_SKILLS[@]}
```

## Available Skills

| Skill | Trigger | Dependencies |
|-------|---------|--------------|
| cron | cron | none |
| reminder | remind | none |
| blog-post-creator | blog | docker-base |
| memory-skill | mem | memory-system |
| tracking-skill | cr | tracking-system |
| openrag | rag | docker-base |

## Validate
- [ ] Each selected skill has SKILL.md
- [ ] Skills appear in `ls ~/.config/opencode/skills/`
