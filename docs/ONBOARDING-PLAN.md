# Onboarding System

Progressive post-install guide that doesn't overwhelm.

## Flow

```
Installation Complete
    ↓
Show Summary
    ↓
Onboarding Choice (question tool)
    ↓
    ├─→ Start Tour (guided steps)
    ├─→ Quick Start (essential commands only)
    └─→ Skip (show again later)
```

## Onboarding Steps (If User Chooses Tour)

| Step | Content | Time |
|------|---------|------|
| 1. Welcome | What was installed, access URLs | 30s |
| 2. First Memory | Store and search a memory | 1min |
| 3. Try a Reminder | Set a test reminder | 30s |
| 4. System Check | Run health-check.sh | 30s |
| 5. What's Next | Options to explore or finish | 30s |

**Total: ~3 minutes if user proceeds through all steps**

## Key Design Decisions

1. **Each step has "Skip" and "Done for now" options**
2. **Progress saved** - can resume later
3. **Non-blocking** - nothing forces engagement
4. **Quick Start option** - just show commands, no interaction

## Files

- `setup/scripts/onboarding.sh` - Main onboarding script
- `docs/ONBOARDING.md` - Onboarding content
- `~/.config/opencode/.onboarding` - Progress tracking file
