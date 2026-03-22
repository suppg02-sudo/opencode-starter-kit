# OpenCode Starter Kit - Deployment Checklist

## Pre-Deployment (Fresh Ubuntu VM)

- [ ] Ubuntu 20.04+ minimal install
- [ ] Internet connectivity verified
- [ ] SSH access available
- [ ] Sudo access for Docker commands

## Installation Steps

### Step 1: Clone Repository
```bash
cd ~
git clone https://github.com/suppg02-sudo/opencode-starter-kit
cd opencode-starter-kit
```

**Expected**: Repo cloned, 100+ files, all scripts present

### Step 2: Check Prerequisites
```bash
./setup/scripts/check-prereqs.sh
```

**Expected**:
- ✓ Docker detected
- ✓ Python3 detected
- ✓ Git detected
- ✓ jq detected
- ✓ Directories created

**If fails**: Install missing tools:
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose python3 git jq
sudo usermod -aG docker $USER
newgrp docker
```

### Step 3: Detect Paths
```bash
./setup/scripts/detect-paths.sh
```

**Expected**:
- ✓ Server hostname detected
- ✓ Paths saved to `~/.config/opencode/.paths`
- ✓ Output shows: "Server: ubuntu4 (192.168.1.X)"

### Step 4: Start Setup
In OpenCode CLI:
```
setup
```

**Expected**:
- Question tool shows 4 presets
- "Full Install (Recommended)" is first option
- Can navigate with arrow keys

### Step 5: Select Preset
Select: **Full Install (Recommended)**

**Expected**:
- All components listed
- Summary shows complete feature set
- Confirmation prompt appears

### Step 6: Confirm & Proceed
Answer: **Yes, proceed**

**Expected**:
- Installation begins
- Components installed in sequence:
  1. AGENTS.md config
  2. Core systems (skill-factory, memory)
  3. Skills (brainstorming, research, blog, etc.)
  4. Docker containers (Portainer, Homepage, Hugo, etc.)
- Each step shows progress

### Step 7: Wait for Completion
Estimated time: **8-12 minutes**

Progress indicators:
- Docker images pulled (~5 min)
- Containers started (~2 min)
- Skills synced (~1 min)

### Step 8: Verification
```bash
./setup/scripts/verify-installation.sh
```

**Expected**:
- Core files: ✓ AGENTS.md, ✓ skill-factory
- Skills: ✓ 15+ skills installed
- Memory: ✓ Connected (PostgreSQL or JSON)
- Docker: ✓ 5+ containers running
- Network: ✓ Internet connectivity
- Summary: **✓ Verification passed**

**If fails**: See troubleshooting below

### Step 9: Quick Test
```bash
./setup/scripts/quick-test.sh
```

**Expected**:
- ✓ AGENTS.md
- ✓ skill-factory
- ✓ 4-5 key skills
- ✓ Docker running
- ✓ Memory working
- Summary: **✓ Quick test passed!**

### Step 10: Access Services

**Portainer** (container management):
```
http://ubuntu4:9000
```

**Homepage** (dashboard):
```
http://ubuntu4:3000
```

**NextExplorer** (file browser):
```
http://ubuntu4:8080
```

**Hugo Blog** (optional):
```
http://ubuntu4:1313
```

Replace `ubuntu4` with your actual server hostname.

## Post-Installation

### Quick Commands
```bash
# Test skills
skill

# Memory system
mem

# Create skill
sf

# System health
./setup/scripts/health-check.sh

# Blog management
./setup/scripts/../../.config/opencode/skills/blog-post-creator/scripts/blog-cli.sh status
```

### Test Workflows

1. **Create a memory entry**:
   ```
   mem store "Test memory from fresh install"
   ```

2. **Test brainstorming**:
   ```
   brainstorm
   ```

3. **Create a blog post** (if Hugo installed):
   ```
   blog create "My First Post"
   ```

4. **Check system status**:
   ```
   health-check.sh
   ```

## Troubleshooting

### Docker Not Found
```bash
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
```

### Python3 Not Found
```bash
sudo apt-get install -y python3
```

### Question Tool Not Available
```bash
# Upgrade OpenCode
opencode update
# Or use alternative menu system
```

### Port Already in Use
Edit `docker-compose.yml`:
```yaml
ports:
  - "9001:9000"  # Use 9001 instead of 9000
```

### Memory Not Responding
```bash
# Check container
docker ps | grep openmemory

# View logs
docker logs openmemory

# Restart
docker restart openmemory
```

### Skills Not Visible
```bash
# Check installation
ls ~/.config/opencode/skills/

# Resync from backup
./setup/scripts/update.sh

# Regenerate index
python3 ~/.config/opencode/skills/skill-discovery/scripts/analyze-structure.py --all
```

## Success Criteria

### Minimum (Must Pass)
- [x] Prerequisites installed
- [x] Paths detected
- [x] AGENTS.md exists
- [x] skill-factory installed
- [x] 3+ containers running
- [x] verify-installation.sh passes

### Standard (Should Pass)
- [x] All 15+ skills installed
- [x] Memory system connected
- [x] 5+ containers running
- [x] All quick-test checks pass
- [x] All services accessible via browser

### Complete (Nice to Have)
- [x] 0 warnings in verification
- [x] All Docker containers healthy
- [x] Hugo blog running
- [x] Portainer accessible
- [x] Quick start commands work

## Rollback

If something goes wrong:

```bash
# Restore from backup
./setup/scripts/restore.sh

# Or clean uninstall
./setup/scripts/uninstall.sh

# Then re-run setup
setup
```

## Reporting Results

After successful installation, report:

```markdown
# Installation Report

**VM**: Ubuntu 22.04
**Time**: 10 minutes
**Result**: ✓ Success

## Verification Summary
- Errors: 0
- Warnings: 0
- Passed: 15/15

## Services Running
- Portainer: ✓ http://ubuntu4:9000
- Homepage: ✓ http://ubuntu4:3000
- NextExplorer: ✓ http://ubuntu4:8080
- Hugo: ✓ http://ubuntu4:1313
- Memory: ✓ PostgreSQL

## Next Steps
1. Configure Portainer credentials
2. Set up memory reminders
3. Create first blog post
4. Customize skill triggers

**Status**: Ready for production
```

## Support

For issues:
1. Check `docs/TROUBLESHOOTING.md`
2. Run `verify-installation.sh` with verbose flag
3. Check container logs: `docker logs [container]`
4. See GitHub issues: https://github.com/suppg02-sudo/opencode-starter-kit/issues

## Version Info

- **Starter Kit**: 1.0.0
- **Components**: 17 skills, 6 Docker services
- **Last Updated**: 2026-03-22
