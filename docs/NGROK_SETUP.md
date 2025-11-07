# ngrok Setup Guide

Complete guide for setting up external access to your n8n instance using ngrok.

## Overview

ngrok creates a secure tunnel from the public internet to your local n8n instance, enabling:
- ✅ External webhook access
- ✅ WhatsApp message delivery
- ✅ Remote workflow triggers
- ✅ HTTPS encryption (automatic)

## Pricing Comparison

### Free Tier

**Good for:**
- Testing and development
- Low-traffic workflows
- Learning n8n

**Limitations:**
- ⚠️ **40 requests/minute** (2,400/hour)
- ⚠️ **2-hour session timeout** (must restart)
- ✅ 1 static domain
- ✅ HTTPS included

**Cost:** $0/month

### Paid Tier ($10/month)

**Good for:**
- Production workloads
- WhatsApp automation
- Multiple workflows
- Business use

**Benefits:**
- ✅ **500 requests/minute** (30,000/hour) - **12.5x more**
- ✅ **No session timeouts** (24/7 uptime)
- ✅ 3 static domains
- ✅ Custom domains
- ✅ Better performance

**Cost:** $10/month

**Sign up:** https://dashboard.ngrok.com/billing/subscription

### When to Upgrade

Upgrade to paid if you experience:
- 🚫 "Rate limit exceeded" errors
- 🚫 Webhooks failing intermittently
- 🚫 Session timeouts disrupting workflows
- 🚫 WhatsApp messages not delivering

**Rule of thumb:** If you're using n8n for business or have >100 webhook calls/hour, upgrade to paid.

## Installation

### 1. Install ngrok

**macOS:**
```bash
brew install ngrok
```

**Linux:**
```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok
```

**Windows:**
Download from: https://ngrok.com/download

### 2. Get Your Auth Token

1. Sign up at: https://dashboard.ngrok.com/signup
2. Go to: https://dashboard.ngrok.com/get-started/your-authtoken
3. Copy your authtoken

### 3. Configure ngrok

```bash
ngrok config add-authtoken YOUR_AUTH_TOKEN
```

### 4. Get Your Static Domain

**Free tier:**
```bash
# Start ngrok
ngrok http 5678

# Look for the "Forwarding" line:
# Forwarding  https://abc123.ngrok-free.dev -> http://localhost:5678

# Your domain is: abc123.ngrok-free.dev
```

**Paid tier:**
1. Go to: https://dashboard.ngrok.com/cloud-edge/domains
2. Click "New Domain"
3. Choose your domain (e.g., `my-n8n.ngrok.app`)

### 5. Update .env File

```bash
# Edit .env
nano .env

# Add your domain
NGROK_DOMAIN=abc123.ngrok-free.dev
# or
NGROK_DOMAIN=my-n8n.ngrok.app
```

### 6. Restart Services

```bash
docker-compose down
docker-compose up -d
```

## Running ngrok

### Manual Start

```bash
# Free tier (random domain each time)
ngrok http 5678

# With static domain
ngrok http 5678 --domain=abc123.ngrok-free.dev
```

### Auto-Start with systemd (Linux)

See [systemd/README.md](../systemd/README.md) for setting up ngrok to start automatically on boot.

## Monitoring Usage

### Check Current Usage

1. Go to: https://dashboard.ngrok.com/observability/traffic-inspector
2. View real-time requests
3. Monitor rate limits

### Free Tier Limits

If you see "429 Too Many Requests" errors:
- You've hit the 40 requests/minute limit
- Consider upgrading to paid tier
- Or reduce webhook frequency

## Alternatives to ngrok

### Cloudflare Tunnel (Free, Unlimited)

**Pros:**
- ✅ Completely free
- ✅ No request limits
- ✅ Custom domains
- ✅ DDoS protection

**Cons:**
- ⚠️ More complex setup
- ⚠️ Requires Cloudflare account

**Setup:** https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/

### Tailscale (Free for Personal Use)

**Pros:**
- ✅ Free for personal use
- ✅ Secure mesh network
- ✅ No public exposure

**Cons:**
- ⚠️ Requires Tailscale on all devices
- ⚠️ Not suitable for public webhooks

**Setup:** https://tailscale.com/kb/1017/install/

## Troubleshooting

### ngrok session expired

**Free tier only** - sessions expire after 2 hours.

**Solution:**
- Restart ngrok manually
- Upgrade to paid tier ($10/month)
- Use systemd service to auto-restart

### Rate limit exceeded

**Error:** `429 Too Many Requests`

**Solutions:**
1. Upgrade to paid tier (500 req/min)
2. Reduce webhook frequency
3. Use Cloudflare Tunnel instead

### Domain not working

**Check:**
```bash
# Verify ngrok is running
curl https://YOUR_DOMAIN.ngrok-free.dev/healthz

# Check ngrok logs
ngrok http 5678 --log=stdout
```

## Security Best Practices

1. **Never share your ngrok domain publicly** - it exposes your local network
2. **Use strong n8n passwords** - your instance is now internet-accessible
3. **Enable n8n authentication** - always require login
4. **Monitor ngrok traffic** - check for suspicious activity
5. **Use environment variables** - never hardcode domains

## Cost Summary

| Scenario | ngrok Cost | Total Monthly Cost | vs Cloud Savings |
|----------|-----------|-------------------|------------------|
| **Testing/Learning** | $0 (free) | $0 | Save $50-110 |
| **Light Production** | $0 (free) | $0 | Save $50-110 |
| **Heavy Production** | $10 (paid) | $10 | Save $40-100 |

**Even with paid ngrok, you still save $40-100/month vs cloud services!**

## Resources

- [ngrok Documentation](https://ngrok.com/docs)
- [ngrok Pricing](https://ngrok.com/pricing)
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
- [n8n Webhook Documentation](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)

