#!/bin/bash

#############################################################################
# Create GitHub Repository Script
# 
# This script creates the GitHub repository and pushes the code
#############################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Creating GitHub repository...${NC}"
echo ""

# Check if gh CLI is installed
if command -v gh &> /dev/null; then
    echo -e "${GREEN}✓${NC} GitHub CLI found, using gh"
    
    # Create repository using gh CLI
    gh repo create n8n-selfhost-starter \
        --public \
        --description "🚀 Production-ready Docker Compose setup for self-hosting n8n with WhatsApp integration. Save \$50-110/month with PostgreSQL, Redis, Evolution API, health monitoring, and auto-updates." \
        --source=. \
        --remote=origin \
        --push
    
    echo ""
    echo -e "${GREEN}✓${NC} Repository created and code pushed!"
    echo ""
    echo "Repository URL: https://github.com/NFTim-og/n8n-selfhost-starter"
    
else
    echo -e "${RED}✗${NC} GitHub CLI (gh) not found"
    echo ""
    echo "Please install GitHub CLI or create the repository manually:"
    echo ""
    echo "Option 1: Install GitHub CLI"
    echo "  brew install gh"
    echo "  gh auth login"
    echo "  ./create-github-repo.sh"
    echo ""
    echo "Option 2: Manual creation"
    echo "  1. Go to: https://github.com/new"
    echo "  2. Repository name: n8n-selfhost-starter"
    echo "  3. Description: 🚀 Production-ready Docker Compose setup for self-hosting n8n with WhatsApp integration. Save \$50-110/month with PostgreSQL, Redis, Evolution API, health monitoring, and auto-updates."
    echo "  4. Visibility: Public"
    echo "  5. Do NOT initialize with README"
    echo "  6. Click 'Create repository'"
    echo "  7. Run: git push -u origin master"
    echo ""
    exit 1
fi

# Add topics
echo -e "${BLUE}Adding topics...${NC}"
gh repo edit --add-topic n8n,automation,self-hosted,docker,docker-compose,whatsapp,evolution-api,postgresql,redis,workflow-automation

echo ""
echo -e "${GREEN}✓${NC} Topics added!"
echo ""
echo -e "${GREEN}🎉 All done!${NC}"
echo ""
echo "Next steps:"
echo "  1. View your repository: https://github.com/NFTim-og/n8n-selfhost-starter"
echo "  2. Enable Discussions in Settings → General → Features"
echo "  3. Share with the community (see PUBLISH_TO_GITHUB.md)"

