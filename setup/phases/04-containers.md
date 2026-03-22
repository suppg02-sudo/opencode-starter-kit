# Phase 4: Container Services

**Deploys**: Selected Docker containers
**Duration**: ~3-5 minutes

## docker-base
```bash
cat > ~/docker/docker-compose.yml << 'EOF'
version: '3.8'
networks:
  opencode:
    driver: bridge
volumes:
  portainer_data:
  homepage_data:
  nextexplorer_data:
  usermemos_data:
services:
EOF
```

## portainer
```bash
cat >> ~/docker/docker-compose.yml << 'EOF'
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - opencode
EOF
```

## homepage
```bash
cat >> ~/docker/docker-compose.yml << 'EOF'
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - "8765:3000"
    volumes:
      - ./homepage:/app/config
      - homepage_data:/app/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - opencode
EOF
```

## Deploy
```bash
cd ~/docker && docker compose up -d
sleep 15
```

## Validate
- [ ] Containers running: `docker ps`
- [ ] Portainer accessible: http://${SERVER_HOST}:9000
- [ ] Homepage accessible: http://${SERVER_HOST}:8765
