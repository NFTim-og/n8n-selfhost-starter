# Systemd Service Files

These systemd service files enable automatic startup and management of n8n services on Linux systems.

## Installation

### 1. Update Service Files

Before installing, update the following placeholders:

**n8n-docker-compose.service:**
- `WorkingDirectory=/opt/n8n` → Your n8n installation path

**ngrok.service:**
- `User=YOUR_USERNAME` → Your Linux username
- `YOUR_NGROK_DOMAIN` → Your ngrok domain (e.g., `abc123.ngrok-free.dev`)

### 2. Copy Service Files

```bash
# Copy service files to systemd directory
sudo cp systemd/n8n-docker-compose.service /etc/systemd/system/
sudo cp systemd/ngrok.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload
```

### 3. Enable Services

```bash
# Enable auto-start on boot
sudo systemctl enable n8n-docker-compose.service
sudo systemctl enable ngrok.service

# Start services now
sudo systemctl start n8n-docker-compose.service
sudo systemctl start ngrok.service
```

## Usage

### Check Status

```bash
# Check n8n service
sudo systemctl status n8n-docker-compose.service

# Check ngrok service
sudo systemctl status ngrok.service
```

### Start/Stop/Restart

```bash
# Start
sudo systemctl start n8n-docker-compose.service
sudo systemctl start ngrok.service

# Stop
sudo systemctl stop ngrok.service
sudo systemctl stop n8n-docker-compose.service

# Restart
sudo systemctl restart n8n-docker-compose.service
sudo systemctl restart ngrok.service
```

### View Logs

```bash
# View n8n service logs
sudo journalctl -u n8n-docker-compose.service -f

# View ngrok logs
sudo journalctl -u ngrok.service -f
```

## Troubleshooting

### Service fails to start

```bash
# Check logs
sudo journalctl -u n8n-docker-compose.service -n 50

# Verify Docker is running
sudo systemctl status docker

# Check file paths in service files
cat /etc/systemd/system/n8n-docker-compose.service
```

### ngrok service fails

```bash
# Check logs
sudo journalctl -u ngrok.service -n 50

# Verify ngrok is installed
which ngrok

# Test ngrok manually
ngrok http 5678
```

## Disable Auto-Start

```bash
sudo systemctl disable n8n-docker-compose.service
sudo systemctl disable ngrok.service
```

