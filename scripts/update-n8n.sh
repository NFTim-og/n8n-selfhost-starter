#!/bin/bash

#############################################################################
# n8n Auto-Update Script
# 
# This script automatically updates n8n to the latest version by:
# 1. Pulling the latest n8nio/n8n:latest image
# 2. Rebuilding the custom n8n image with Canvas support
# 3. Restarting the n8n service
# 4. Verifying the new version
#
# Usage:
#   ./update-n8n.sh           # Update n8n
#   ./update-n8n.sh --check   # Check for updates without applying
#############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Log function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} ✓ $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} ⚠ $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} ✗ $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Get current n8n version
get_current_version() {
    if docker ps --format '{{.Names}}' | grep -q "locally-self-host-n8n-n8n-1"; then
        docker exec locally-self-host-n8n-n8n-1 n8n --version 2>/dev/null || echo "unknown"
    else
        echo "not running"
    fi
}

# Check for updates
check_updates() {
    log "Checking for n8n updates..."
    
    # Pull latest image info without downloading
    LATEST_DIGEST=$(docker manifest inspect n8nio/n8n:latest 2>/dev/null | grep -o '"digest": "sha256:[^"]*"' | head -1 | cut -d'"' -f4)
    CURRENT_DIGEST=$(docker inspect n8nio/n8n:latest 2>/dev/null | grep -o '"Id": "sha256:[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [ "$LATEST_DIGEST" != "$CURRENT_DIGEST" ]; then
        log_warning "New version available!"
        return 0
    else
        log_success "Already on latest version"
        return 1
    fi
}

# Update n8n
update_n8n() {
    log "Starting n8n update process..."
    
    # Get current version
    CURRENT_VERSION=$(get_current_version)
    log "Current version: $CURRENT_VERSION"
    
    # Pull latest n8n image
    log "Pulling latest n8n image..."
    docker pull n8nio/n8n:latest
    
    # Rebuild custom n8n image
    log "Rebuilding custom n8n image with Canvas support..."
    docker-compose build --pull --no-cache n8n
    
    # Restart n8n service
    log "Restarting n8n service..."
    docker-compose up -d n8n
    
    # Wait for n8n to start
    log "Waiting for n8n to start..."
    sleep 10
    
    # Get new version
    NEW_VERSION=$(get_current_version)
    
    if [ "$NEW_VERSION" != "unknown" ] && [ "$NEW_VERSION" != "not running" ]; then
        log_success "n8n updated successfully!"
        log_success "Previous version: $CURRENT_VERSION"
        log_success "New version: $NEW_VERSION"

        # Restart tunnel if it's running
        if pgrep -f "localtunnel --port 5678" > /dev/null; then
            log "Restarting localtunnel tunnel..."
            ./start-localtunnel.sh restart
        elif pgrep -f "ngrok http 5678" > /dev/null; then
            log "Restarting ngrok tunnel..."
            ./start-ngrok.sh restart
        fi
        
        return 0
    else
        log_error "Failed to verify n8n version after update"
        return 1
    fi
}

# Main script
main() {
    # Check Docker
    check_docker

    # Parse arguments
    if [ "$1" == "--check" ]; then
        check_updates
        exit $?
    fi

    # Auto mode (for cron)
    if [ "$1" == "--auto" ]; then
        log "Running in automatic mode..."
        CURRENT_VERSION=$(get_current_version)
        log "Current version: $CURRENT_VERSION"

        # Perform update without confirmation
        if update_n8n; then
            log_success "Automatic update completed successfully"
            exit 0
        else
            log_error "Automatic update failed"
            exit 1
        fi
    fi

    # Interactive mode
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                          n8n Auto-Update Script                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Confirm update
    CURRENT_VERSION=$(get_current_version)
    echo "Current n8n version: $CURRENT_VERSION"
    echo ""
    read -p "Do you want to update n8n to the latest version? (y/N): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Update cancelled"
        exit 0
    fi

    # Perform update
    if update_n8n; then
        echo ""
        echo "╔══════════════════════════════════════════════════════════════════════════════╗"
        echo "║                          Update Complete!                                    ║"
        echo "╚══════════════════════════════════════════════════════════════════════════════╝"
        echo ""
        log_success "n8n is now running the latest version"
        log "Access n8n at: http://localhost:5678"
        echo ""
    else
        echo ""
        log_error "Update failed. Please check the logs above for details."
        exit 1
    fi
}

# Run main function
main "$@"

