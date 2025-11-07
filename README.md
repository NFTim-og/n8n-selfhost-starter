# n8n Self-Hosted Starter with Evolution API

> 🚀 Production-ready Docker Compose setup for self-hosting n8n with WhatsApp integration

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)
[![n8n](https://img.shields.io/badge/n8n-latest-orange.svg)](https://n8n.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

Save **$50-110/month** by self-hosting n8n with this production-ready Docker Compose setup. Includes PostgreSQL, Redis, Evolution API (WhatsApp), health monitoring, and auto-updates.

## 💰 Cost Savings

| Service | Cloud Cost | Self-Hosted | Monthly Savings |
|---------|-----------|-------------|-----------------|
| n8n Hosting | $20-50 | $0 | $20-50 |
| WhatsApp API | $15-30 | $0 | $15-30 |
| PostgreSQL | $10-20 | $0 | $10-20 |
| Redis | $5-10 | $0 | $5-10 |
| **Total** | **$50-110** | **$0** | **$50-110** |

## ⚡ Quick Start

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/n8n-selfhost-starter.git
cd n8n-selfhost-starter

# Configure environment
cp .env.template .env
nano .env  # Add your passwords

# Start services
docker-compose up -d

# Access n8n
open http://localhost:5678
```

**That's it!** You're running n8n in under 5 minutes.

📖 **Detailed guide:** [Quick Start Documentation](docs/QUICK_START.md)

## 🎯 Features

### Core Services
- ✅ **n8n** (latest) - Workflow automation platform
- ✅ **PostgreSQL 17** - Reliable data persistence
- ✅ **Redis 7** - Fast caching and session storage
- ✅ **Evolution API v2.1.1** - WhatsApp Business integration

### Production Features
- ✅ **Auto-restart** - Services restart automatically on failure
- ✅ **Health monitoring** - Built-in health check scripts
- ✅ **Auto-updates** - Weekly n8n updates (optional)
- ✅ **Systemd services** - Auto-start on boot (Linux)
- ✅ **Canvas support** - Generate PDFs and images
- ✅ **Backup scripts** - Easy data backup and restore

### Security
- ✅ **Environment variables** - Secure credential management
- ✅ **Docker isolation** - Containerized services
- ✅ **No hardcoded secrets** - All credentials in .env
- ✅ **Optional HTTPS** - ngrok or reverse proxy support

## 📁 What's Included

```
n8n-selfhost-starter/
├── docker-compose.yml          # Main orchestration
├── Dockerfile                  # Custom n8n image
├── .env.template              # Environment template
├── init-data.sh               # Database initialization
├── docs/                      # Comprehensive documentation
│   ├── QUICK_START.md        # 5-minute setup
│   ├── UBUNTU_DEPLOYMENT.md  # Production deployment
│   ├── EVOLUTION_API_GUIDE.md # WhatsApp integration
│   └── TROUBLESHOOTING.md    # Common issues
├── scripts/                   # Utility scripts
│   ├── health-check.sh       # Service health verification
│   ├── setup.sh              # Automated setup
│   └── update-n8n.sh         # Update script
└── systemd/                   # Linux auto-start services
    ├── n8n-docker-compose.service
    └── ngrok.service
```

## 🚀 Use Cases

Perfect for:
- 🏢 **Small businesses** - Automate workflows without monthly fees
- 👨‍💻 **Developers** - Full control over your automation platform
- 🔧 **Agencies** - Deploy for multiple clients
- 📱 **WhatsApp automation** - Built-in Evolution API
- 🏠 **Home labs** - Run on old hardware or Raspberry Pi

## 📊 Architecture

```
┌─────────────────────────────────────────┐
│           n8n Web Interface             │
│         (Port 5678)                     │
└─────────────┬───────────────────────────┘
              │
┌─────────────┴───────────────────────────┐
│         n8n Container                   │
│  - Workflow Engine                      │
│  - Canvas Support                       │
│  - Community Packages                   │
└─────┬───────┬───────┬───────────────────┘
      │       │       │
      │       │       └──────────────┐
      │       │                      │
┌─────▼───┐ ┌─▼──────┐ ┌────────────▼─────┐
│PostgreSQL│ │ Redis  │ │  Evolution API   │
│  (5432) │ │ (6379) │ │    (8080)        │
│         │ │        │ │  WhatsApp API    │
└─────────┘ └────────┘ └──────────────────┘
```

## 📚 Documentation

| Guide | Description |
|-------|-------------|
| [Quick Start](docs/QUICK_START.md) | Get running in 5 minutes |
| [Ubuntu Deployment](docs/UBUNTU_DEPLOYMENT.md) | Production server setup |
| [Evolution API](docs/EVOLUTION_API_GUIDE.md) | WhatsApp integration |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues & solutions |

## 🛠️ Requirements

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **4GB RAM** minimum
- **20GB disk space** minimum
- **Linux/macOS/Windows** (with WSL2)

## 🔧 Configuration

### Environment Variables

All configuration is in `.env` file:

```bash
# Database
POSTGRES_PASSWORD=your-secure-password
POSTGRES_NON_ROOT_PASSWORD=another-secure-password

# Redis
REDIS_PASSWORD=redis-secure-password

# Evolution API (WhatsApp)
EVOLUTION_API_KEY=evolution-api-key

# Optional: ngrok for external access
NGROK_DOMAIN=your-domain.ngrok-free.dev
```

**Generate secure passwords:**
```bash
openssl rand -base64 32
```

## 📦 Services

| Service | Local URL | Purpose |
|---------|-----------|---------|
| n8n | http://localhost:5678 | Workflow automation |
| Evolution API | http://localhost:8080 | WhatsApp integration |
| PostgreSQL | localhost:5432 | Database (internal) |
| Redis | localhost:6379 | Cache (internal) |

## 🎓 Getting Started

### 1. Local Development

```bash
docker-compose up -d
```

Access at: http://localhost:5678

### 2. Production Deployment

See [Ubuntu Deployment Guide](docs/UBUNTU_DEPLOYMENT.md) for:
- 24/7 operation setup
- Auto-start on boot
- Health monitoring
- External access

### 3. WhatsApp Integration

See [Evolution API Guide](docs/EVOLUTION_API_GUIDE.md) for:
- Creating WhatsApp instances
- Sending messages
- Webhook configuration

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If this project helped you save money and time, please give it a ⭐!

## 🙏 Acknowledgments

- [n8n](https://n8n.io/) - Amazing workflow automation platform
- [Evolution API](https://evolution-api.com/) - WhatsApp Business API
- Community contributors

## 📞 Support

- 📖 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/YOUR_USERNAME/n8n-selfhost-starter/issues)
- 💬 [Discussions](https://github.com/YOUR_USERNAME/n8n-selfhost-starter/discussions)

---

**Made with ❤️ for the n8n community**

