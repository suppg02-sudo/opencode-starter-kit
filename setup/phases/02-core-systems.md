# Phase 2: Core Systems

**Installs**: Selected core components
**Duration**: ~2-5 minutes

## Components

### skill-factory
```bash
setup/scripts/copy-skills.sh skill-factory
```

### memory-system
```bash
# Create PostgreSQL container
cat > ~/docker/docker-compose.memory.yml << 'EOF'
version: '3.8'
services:
  postgres-pgvector:
    image: pgvector/pgvector:pg16
    container_name: pghmem
    environment:
      POSTGRES_DB: hybrid_memory
      POSTGRES_USER: memory
      POSTGRES_PASSWORD: ${MEMORY_DB_PASSWORD:-changeme}
    volumes:
      - pghmem_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped
volumes:
  pghmem_data:
EOF

cd ~/docker && docker compose -f docker-compose.memory.yml up -d
sleep 10
pip3 install pghmem
```

### tracking-system
```bash
setup/scripts/copy-skills.sh tracking
```

### opentelemetry
```bash
setup/scripts/copy-skills.sh opentelemetry
```

## Validate
- [ ] Selected core skills installed
- [ ] PostgreSQL running (if memory selected)
