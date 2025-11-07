# Troubleshooting Guide

Common issues and solutions for n8n self-hosted setup.

## Table of Contents

- [Services Won't Start](#services-wont-start)
- [Database Connection Errors](#database-connection-errors)
- [n8n Won't Load](#n8n-wont-load)
- [Evolution API Issues](#evolution-api-issues)
- [Performance Issues](#performance-issues)
- [Backup and Restore](#backup-and-restore)

## Services Won't Start

### Symptom
`docker-compose up -d` fails or containers keep restarting.

### Solutions

**1. Check Docker is running:**
```bash
docker ps
```

**2. View detailed logs:**
```bash
docker-compose logs
```

**3. Rebuild images:**
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**4. Check disk space:**
```bash
df -h
docker system df
```

**5. Clean up Docker:**
```bash
docker system prune -a
```

## Database Connection Errors

### Symptom
n8n shows "Database connection failed" or similar errors.

### Solutions

**1. Verify PostgreSQL is healthy:**
```bash
docker-compose exec postgres pg_isready -U ${POSTGRES_USER}
```

**2. Check database credentials:**
```bash
# Verify .env file has correct values
cat .env | grep POSTGRES
```

**3. Check database user:**
```bash
docker-compose exec postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "\du"
```

**4. Restart PostgreSQL:**
```bash
docker-compose restart postgres
docker-compose restart n8n
```

**5. Reset database (⚠️ destroys data):**
```bash
docker-compose down -v
docker-compose up -d
```

## n8n Won't Load

### Symptom
Browser shows "Connection refused" or blank page at http://localhost:5678

### Solutions

**1. Verify n8n is running:**
```bash
docker-compose ps
```

**2. Check n8n logs:**
```bash
docker-compose logs n8n
```

**3. Verify port is not in use:**
```bash
lsof -i :5678
# or
netstat -an | grep 5678
```

**4. Check firewall:**
```bash
# Linux
sudo ufw status
sudo ufw allow 5678

# macOS
sudo pfctl -sr | grep 5678
```

**5. Try different browser:**
- Clear cache (Ctrl+Shift+R)
- Try incognito mode
- Try different browser

**6. Check n8n health:**
```bash
curl http://localhost:5678/healthz
```

## Evolution API Issues

### Instance Not Connecting

**1. Check Evolution API logs:**
```bash
docker-compose logs evolution-api
```

**2. Verify Redis is running:**
```bash
docker-compose exec redis redis-cli ping
```

**3. Check API key:**
```bash
cat .env | grep EVOLUTION_API_KEY
```

**4. Restart Evolution API:**
```bash
docker-compose restart evolution-api
```

### QR Code Expired

**Delete and recreate instance:**
```bash
curl -X DELETE http://localhost:8080/instance/delete/INSTANCE_NAME \
  -H 'apikey: YOUR_API_KEY'

# Create new instance
curl -X POST http://localhost:8080/instance/create \
  -H 'Content-Type: application/json' \
  -H 'apikey: YOUR_API_KEY' \
  -d '{"instanceName": "INSTANCE_NAME", "qrcode": true}'
```

### API Returns 401 Unauthorized

**Verify API key matches:**
```bash
# Check .env file
cat .env | grep EVOLUTION_API_KEY

# Test with correct key
curl -X GET http://localhost:8080/instance/fetchInstances \
  -H 'apikey: YOUR_ACTUAL_API_KEY'
```

## Performance Issues

### n8n is Slow

**1. Check resource usage:**
```bash
docker stats
```

**2. Increase Docker resources:**
- Docker Desktop → Settings → Resources
- Increase CPU and RAM allocation

**3. Check database size:**
```bash
docker-compose exec postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "
SELECT pg_size_pretty(pg_database_size('${POSTGRES_DB}'));
"
```

**4. Optimize PostgreSQL:**
```bash
docker-compose exec postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "VACUUM ANALYZE;"
```

### High Memory Usage

**1. Check container memory:**
```bash
docker stats --no-stream
```

**2. Limit container memory:**

Edit `docker-compose.yml`:
```yaml
services:
  n8n:
    mem_limit: 2g
```

**3. Clear Redis cache:**
```bash
docker-compose exec redis redis-cli FLUSHALL
```

## Backup and Restore

### Backup Data

**1. Backup n8n data:**
```bash
docker run --rm \
  -v n8n_storage:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/n8n_backup.tar.gz -C /data .
```

**2. Backup database:**
```bash
docker-compose exec postgres pg_dump -U ${POSTGRES_USER} ${POSTGRES_DB} > backup.sql
```

**3. Backup .env file:**
```bash
cp .env .env.backup
```

### Restore Data

**1. Restore n8n data:**
```bash
docker run --rm \
  -v n8n_storage:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/n8n_backup.tar.gz"
```

**2. Restore database:**
```bash
cat backup.sql | docker-compose exec -T postgres psql -U ${POSTGRES_USER} ${POSTGRES_DB}
```

## Getting More Help

### Check Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f n8n
docker-compose logs -f postgres
docker-compose logs -f evolution-api

# Last 100 lines
docker-compose logs --tail=100
```

### Run Health Check

```bash
./scripts/health-check.sh
```

### Community Support

- [n8n Community Forum](https://community.n8n.io/)
- [n8n Documentation](https://docs.n8n.io/)
- [Evolution API Docs](https://doc.evolution-api.com/)
- [GitHub Issues](https://github.com/NFTim-og/n8n-selfhost-starter/issues)

## Still Having Issues?

1. Check the logs: `docker-compose logs`
2. Run health check: `./scripts/health-check.sh`
3. Search existing issues on GitHub
4. Create a new issue with:
   - Error messages
   - Logs
   - Steps to reproduce
   - System information

