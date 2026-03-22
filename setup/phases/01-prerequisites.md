# Phase 1: Prerequisites

**Checks**: Question tool, Docker, Python3, Git, detects paths
**Duration**: ~30 seconds

## Execute

```bash
# CRITICAL: Verify question tool is available
setup/scripts/check-question-tool.sh || {
    echo "ERROR: Question tool check failed"
    echo "Fix issues before proceeding"
    exit 1
}

# Detect system paths (creates ~/.config/opencode/.paths)
setup/scripts/detect-paths.sh

# Check Docker
docker --version || (curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $USER)

# Check Python3
python3 --version || sudo apt install -y python3 python3-pip

# Check Git
git --version || sudo apt install -y git

# Create directories
mkdir -p ~/.config/opencode/{skills,scripts,context,docs}
mkdir -p ~/docker
```

## Output
Paths file created at `~/.config/opencode/.paths` containing:
- `SERVER_HOST` - hostname for URLs
- `DOCKER_DIR` - docker config location
- `HOME_DIR` - user home path
- Port defaults for all services

## Validate
- [ ] Question tool available (critical!)
- [ ] Docker installed
- [ ] Python3 installed
- [ ] Git installed
- [ ] Directories created
- [ ] .paths file created
