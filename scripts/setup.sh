#!/bin/bash

#############################################################################
# n8n Setup Script
# 
# Automated setup for n8n with Evolution API
# Usage: ./scripts/setup.sh
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

log "Starting n8n setup..."
echo ""

# Check prerequisites
log "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    error "Docker is not installed. Please install Docker first."
    exit 1
fi
success "Docker is installed"

if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
success "Docker Compose is installed"

# Check if .env file exists
if [ ! -f .env ]; then
    error ".env file not found!"
    echo ""
    log "Please create .env file from template:"
    echo "  cp .env.template .env"
    echo "  nano .env  # Edit with your values"
    exit 1
fi
success ".env file found"

# Validate .env has required values
if grep -q "CHANGE_ME" .env; then
    error ".env file contains placeholder values!"
    echo ""
    log "Please update all CHANGE_ME_* values in .env file"
    echo "  nano .env"
    exit 1
fi
success ".env file configured"

echo ""
log "Building Docker images..."
docker-compose build --no-cache

echo ""
log "Starting services..."
docker-compose up -d

echo ""
log "Waiting for services to be ready..."
sleep 10

echo ""
log "Checking service health..."
./scripts/health-check.sh

echo ""
success "Setup complete!"
echo ""
log "Access n8n at: http://localhost:5678"
log "For external access, configure ngrok (see docs/QUICK_START.md)"

