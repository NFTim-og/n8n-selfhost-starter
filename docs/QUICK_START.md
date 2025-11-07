# Quick Start Guide

Get n8n running in 5 minutes with Docker Compose.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- At least 4GB RAM and 20GB disk space

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/n8n-selfhost-starter.git
cd n8n-selfhost-starter
```

### 2. Configure Environment

```bash
# Copy the template
cp .env.template .env

# Generate secure passwords (run 4 times)
openssl rand -base64 32

# Edit .env and replace all CHANGE_ME_* values
nano .env
```

**Required values in .env:**
- `POSTGRES_PASSWORD` - PostgreSQL root password
- `POSTGRES_NON_ROOT_PASSWORD` - n8n database user password
- `REDIS_PASSWORD` - Redis password
- `EVOLUTION_API_KEY` - Evolution API key
- `NGROK_DOMAIN` - Your ngrok domain (optional for local-only)

### 3. Start Services

```bash
# Build and start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 4. Access n8n

Open your browser: **http://localhost:5678**

Create your admin account and start building workflows!

## What's Running?

| Service | Port | Purpose |
|---------|------|---------|
| **n8n** | 5678 | Workflow automation |
| **PostgreSQL** | 5432 | Database (internal) |
| **Redis** | 6379 | Cache (internal) |
| **Evolution API** | 8080 | WhatsApp integration |

## Next Steps

### For Local Development

You're all set! Start creating workflows at http://localhost:5678

### For Production Deployment

See [Ubuntu Deployment Guide](UBUNTU_DEPLOYMENT.md) for:
- 24/7 operation setup
- Auto-start on boot
- Health monitoring
- External access with ngrok

### For WhatsApp Integration

See [Evolution API Guide](EVOLUTION_API_GUIDE.md) for:
- Creating WhatsApp instances
- Sending messages
- Webhook configuration

## Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f n8n

# Check health
./scripts/health-check.sh

# Update n8n
./scripts/update-n8n.sh
```

## Troubleshooting

### Services won't start

```bash
# Check logs
docker-compose logs

# Rebuild images
docker-compose build --no-cache
docker-compose up -d
```

### Can't access n8n

```bash
# Verify n8n is running
docker-compose ps

# Check n8n logs
docker-compose logs n8n

# Verify port is not in use
lsof -i :5678
```

### Database connection errors

```bash
# Check PostgreSQL is healthy
docker-compose exec postgres pg_isready

# Verify credentials in .env
cat .env | grep POSTGRES
```

## Getting Help

- [Full Documentation](../README.md)
- [Ubuntu Deployment](UBUNTU_DEPLOYMENT.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [n8n Documentation](https://docs.n8n.io/)

## Security Note

⚠️ **Never commit your .env file!** It contains sensitive credentials.

For production use:
- Use strong passwords (20+ characters)
- Enable HTTPS
- Configure firewall rules
- Regular backups

