# Troubleshooting

## Common Issues

### Docker Issues

**Problem**: "Cannot connect to Docker daemon"
```bash
# Check Docker status
sudo systemctl status docker

# Start Docker
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker $USER
# Then log out and back in
```

**Problem**: "Port already in use"
```bash
# Find what's using the port
ss -tlnp | grep :PORT_NUMBER

# Stop conflicting container
docker stop CONTAINER_NAME
```

---

### OpenMemory Issues

**Problem**: "OpenMemory not responding"
```bash
# Check container
docker ps | grep openmemory

# View logs
docker logs openmemory --tail 50

# Restart
docker restart openmemory

# Full reset
cd ~/docker && docker compose down && docker compose up -d
```

**Problem**: "MCP connection failed"
```bash
# Check API health
curl http://localhost:8081/health

# Check opencode.json
cat ~/.config/opencode/opencode.json | grep -A5 openmemory
```

---

### Skills Issues

**Problem**: "Skill not found"
```bash
# Check if installed
ls ~/.config/opencode/skills/YOUR_SKILL/

# Reinstall from backup
cp -r ~/freshstart/skills/YOUR_SKILL ~/.config/opencode/skills/
```

**Problem**: "Trigger not working"
- Check AGENTS.md has the trigger defined
- Restart OpenCode session
- Check SKILL.md exists in skill directory

---

### Installation Issues

**Problem**: "Installation failed midway"
```bash
# Preview rollback
rollback.sh --dry-run

# Execute rollback
rollback.sh

# Start fresh
setup
```

**Problem**: "Permission denied"
```bash
# Fix permissions
chmod +x ~/.config/opencode/scripts/*.sh
sudo chown -R $USER ~/.config/opencode/
```

---

## Diagnostic Commands

```bash
# Full system check
health-check.sh

# Validate installation
validate.sh

# Check Docker
docker ps
docker system df

# Check ports
ss -tlnp | grep LISTEN

# Check logs
journalctl -u docker --since "1 hour ago"
```

---

## Getting More Help

1. Run `health-check.sh` for system status
2. Check container logs: `docker logs CONTAINER_NAME`
3. Review OpenCode config: `cat ~/.config/opencode/opencode.json`
4. Check AGENTS.md for trigger definitions

---

## Reset to Defaults

**Warning**: This removes all customizations!

```bash
# Backup first
backup.sh

# Uninstall
uninstall.sh

# Fresh install
git clone https://github.com/suppg02-sudo/opencode-starter-kit.git
# Open in OpenCode and run: setup
```
