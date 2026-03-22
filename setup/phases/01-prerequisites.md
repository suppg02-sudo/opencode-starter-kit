# Phase 1: Prerequisites

**Checks**: Docker, Python3, Git
**Duration**: ~30 seconds

## Execute

```bash
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

## Validate
- [ ] Docker installed
- [ ] Python3 installed
- [ ] Git installed
- [ ] Directories created
