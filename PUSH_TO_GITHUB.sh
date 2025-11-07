#!/bin/bash

#############################################################################
# Push to GitHub Script
# 
# Run this AFTER creating the repository on GitHub
#############################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Push n8n-selfhost-starter to GitHub  ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if repository exists on GitHub
echo -e "${YELLOW}Before running this script:${NC}"
echo ""
echo "1. Go to: https://github.com/new"
echo "2. Repository name: n8n-selfhost-starter"
echo "3. Description: 🚀 Production-ready Docker Compose setup for self-hosting n8n with WhatsApp integration. Save \$50-110/month"
echo "4. Visibility: Public ✅"
echo "5. Do NOT initialize with README"
echo "6. Click 'Create repository'"
echo ""
read -p "Have you created the repository on GitHub? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Please create the repository first, then run this script again.${NC}"
    echo ""
    exit 1
fi

echo ""
echo -e "${BLUE}Pushing to GitHub...${NC}"
echo ""

# Push to GitHub
git push -u origin master

echo ""
echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
echo ""
echo -e "${GREEN}🎉 Your repository is now live!${NC}"
echo ""
echo "Repository URL: https://github.com/NFTim-og/n8n-selfhost-starter"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "1. Add topics (in repository settings):"
echo "   n8n, automation, self-hosted, docker, docker-compose,"
echo "   whatsapp, evolution-api, postgresql, redis, workflow-automation"
echo ""
echo "2. Enable Discussions:"
echo "   Settings → General → Features → Discussions ✅"
echo ""
echo "3. Share with the community:"
echo "   - n8n Community Forum"
echo "   - Reddit: r/selfhosted, r/docker"
echo "   - Twitter/X with #n8n #automation #selfhosted"
echo ""
echo "See PUBLISH_TO_GITHUB.md for detailed instructions!"
echo ""

