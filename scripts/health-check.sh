#!/bin/bash

#############################################################################
# n8n Health Check Script
# 
# Verifies that all services are running and healthy
# Usage: ./scripts/health-check.sh
#############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log "Checking n8n services health..."
echo ""

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    error "docker-compose not found"
    exit 1
fi

# Check service status
log "Service Status:"
docker-compose ps

echo ""
log "Service Health Details:"
echo ""

# Check PostgreSQL
if docker-compose exec -T postgres pg_isready -U root &> /dev/null; then
    success "PostgreSQL is healthy"
else
    error "PostgreSQL is not responding"
fi

# Check Redis
if docker-compose exec -T redis redis-cli ping &> /dev/null; then
    success "Redis is healthy"
else
    error "Redis is not responding"
fi

# Check n8n
if curl -s http://localhost:5678/healthz &> /dev/null; then
    success "n8n is healthy"
else
    warning "n8n health check failed (may still be starting)"
fi

# Check Evolution API
if curl -s http://localhost:8080/health &> /dev/null; then
    success "Evolution API is healthy"
else
    warning "Evolution API health check failed (may still be starting)"
fi

echo ""
log "Disk Usage:"
docker system df

echo ""
log "Recent Logs (last 20 lines):"
docker-compose logs --tail=20

echo ""
success "Health check complete!"

