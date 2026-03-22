# OpenCode Starter Kit - Testing Plan

## Environment
- **Target**: Fresh Ubuntu VM (minimal install)
- **Scenario**: Complete setup from scratch
- **Presets to test**: Full Install (Recommended)
- **Duration**: ~10 minutes

## Pre-Test Checklist

- [ ] Git cloned to test VM
- [ ] OpenCode CLI available
- [ ] Docker installed and running
- [ ] Internet connectivity (for Docker pulls)

## Test Phases

### Phase 1: Prerequisites Check
**Script**: `./setup/scripts/check-prereqs.sh`

Expected:
- ✓ Docker detection
- ✓ Python3 detection
- ✓ Git detection
- ✓ jq detection
- ✓ Directories created

### Phase 2: Path Detection
**Script**: `./setup/scripts/detect-paths.sh`

Expected:
- ✓ Server hostname detected
- ✓ Home directory identified
- ✓ `.paths` file created in `~/.config/opencode/`
- ✓ Can source `.paths` in other scripts

### Phase 3: Setup Flow
**Command**: `setup`

Expected:
- ✓ Question tool available
- ✓ Presets presented (Full Install first)
- ✓ Components selected correctly
- ✓ Menu navigation works

### Phase 4: Installation
**Components to verify**:

**Core Systems**:
- [ ] AGENTS.md created
- [ ] skill-factory installed
- [ ] menu-factory installed
- [ ] menu-learning installed
- [ ] OpenMemory Lite configured

**Skills** (test 5 key ones):
- [ ] brainstorming SKILL.md exists
- [ ] research SKILL.md exists
- [ ] blog-post-creator SKILL.md exists
- [ ] cron SKILL.md exists
- [ ] telegram SKILL.md exists

**Docker Containers**:
- [ ] docker-compose.yml in place
- [ ] Portainer container running
- [ ] Homepage container running
- [ ] NextExplorer container running
- [ ] Hugo container running (optional)

### Phase 5: Verification
**Script**: `./setup/scripts/verify-installation.sh`

Expected:
- ✓ Core files check
- ✓ Skills validation
- ✓ Memory system connectivity
- ✓ Docker services status
- ✓ Network connectivity
- ✓ All components verified

### Phase 6: Quick Start
**Commands to test**:
- [ ] `skill` - Discover skills
- [ ] `mem` - Memory system
- [ ] `health-check.sh` - System status
- [ ] `blog-cli.sh status` - Blog status

## Success Criteria

### Must Pass
1. All prerequisites detected
2. Paths file created and sourced correctly
3. AGENTS.md and skill-factory exist
4. At least 3 Docker containers running
5. Verification script completes with 0 errors
6. Quick start commands work

### Should Pass
1. All 17 skill templates installed
2. All Docker containers running
3. Memory system connected
4. 0 warnings in verification

### Nice to Have
1. No errors in any phase
2. Installation takes < 15 minutes
3. All 6 Docker services running
4. Memory system fully functional

## Test Results Documentation

After testing, document:

```markdown
# Test Results

## Environment
- VM OS: Ubuntu 22.04 (or version tested)
- Docker version: X.X.X
- Python version: X.X.X
- Git version: X.X.X

## Phase Results
- [x/x] Phase 1: Prerequisites - PASSED/FAILED
- [x/x] Phase 2: Path Detection - PASSED/FAILED
- [x/x] Phase 3: Setup Flow - PASSED/FAILED
- [x/x] Phase 4: Installation - PASSED/FAILED
- [x/x] Phase 5: Verification - PASSED/FAILED
- [x/x] Phase 6: Quick Start - PASSED/FAILED

## Issues Found
1. [Issue description]
   - Severity: Low/Medium/High
   - Impact: X
   - Fix: Y

## Time Breakdown
- Prerequisites: X min
- Installation: X min
- Verification: X min
- Total: X min

## Recommendations
- [ ] Update [component] for clarity
- [ ] Add [feature]
- [ ] Fix [issue]

## Sign-Off
- Tested by: [name]
- Date: [date]
- Recommendation: Ready for production / Needs fixes
```

## How to Run Test

1. **Prepare VM**:
   ```bash
   ssh user@vm
   git clone https://github.com/suppg02-sudo/opencode-starter-kit
   cd opencode-starter-kit
   ```

2. **Run Prerequisites**:
   ```bash
   ./setup/scripts/check-prereqs.sh
   ```

3. **Start Setup**:
   ```bash
   # In OpenCode CLI on the VM
   setup
   ```

4. **Select Full Install** when prompted

5. **Run Verification**:
   ```bash
   ./setup/scripts/verify-installation.sh
   ```

6. **Document Results** in test results section above

## Rollback Plan

If testing fails:
1. Run: `./setup/scripts/restore.sh`
2. Or: `./setup/scripts/uninstall.sh` to clean up
3. Fix identified issues
4. Re-test specific phases

## Notes

- Test user should have sudo access for Docker commands
- Fresh VM: Start with nothing installed except base Ubuntu
- Monitor: Watch for network timeouts during Docker pulls
- Safety: Keep rollback scripts handy
