# Evolution API - WhatsApp Integration Guide

Complete guide for integrating WhatsApp Business API with n8n using Evolution API.

## Overview

Evolution API provides a complete WhatsApp Business API solution that integrates seamlessly with n8n.

**Features:**
- ✅ Send and receive WhatsApp messages
- ✅ Media support (images, videos, documents)
- ✅ Group messaging
- ✅ Webhook support for real-time events
- ✅ Multiple WhatsApp instances
- ✅ QR code authentication

## Quick Start

### 1. Access Evolution API

Evolution API is running at: **http://localhost:8080**

### 2. Get Your API Key

Your API key is in the `.env` file:

```bash
cat .env | grep EVOLUTION_API_KEY
```

### 3. Create WhatsApp Instance

```bash
curl -X POST http://localhost:8080/instance/create \
  -H 'Content-Type: application/json' \
  -H 'apikey: YOUR_EVOLUTION_API_KEY' \
  -d '{
    "instanceName": "my-whatsapp",
    "qrcode": true
  }'
```

**Response:** You'll receive a QR code to scan with WhatsApp.

### 4. Scan QR Code

1. Open WhatsApp on your phone
2. Go to Settings → Linked Devices
3. Tap "Link a Device"
4. Scan the QR code from the API response

### 5. Verify Connection

```bash
curl -X GET http://localhost:8080/instance/connectionState/my-whatsapp \
  -H 'apikey: YOUR_EVOLUTION_API_KEY'
```

## Common Operations

### Send Text Message

```bash
curl -X POST http://localhost:8080/message/sendText/my-whatsapp \
  -H 'Content-Type: application/json' \
  -H 'apikey: YOUR_EVOLUTION_API_KEY' \
  -d '{
    "number": "5511999999999",
    "text": "Hello from n8n!"
  }'
```

### Send Image

```bash
curl -X POST http://localhost:8080/message/sendMedia/my-whatsapp \
  -H 'Content-Type: application/json' \
  -H 'apikey: YOUR_EVOLUTION_API_KEY' \
  -d '{
    "number": "5511999999999",
    "mediatype": "image",
    "media": "https://example.com/image.jpg",
    "caption": "Check this out!"
  }'
```

### List Instances

```bash
curl -X GET http://localhost:8080/instance/fetchInstances \
  -H 'apikey: YOUR_EVOLUTION_API_KEY'
```

### Delete Instance

```bash
curl -X DELETE http://localhost:8080/instance/delete/my-whatsapp \
  -H 'apikey: YOUR_EVOLUTION_API_KEY'
```

## n8n Integration

### Method 1: HTTP Request Node (Recommended)

**Configuration:**
- **Method:** POST
- **URL:** `http://evolution-api:8080/message/sendText/my-whatsapp`
- **Authentication:** None
- **Headers:**
  ```json
  {
    "apikey": "{{ $env.EVOLUTION_API_KEY }}",
    "Content-Type": "application/json"
  }
  ```
- **Body:**
  ```json
  {
    "number": "{{ $json.phone }}",
    "text": "{{ $json.message }}"
  }
  ```

**Why use `evolution-api` hostname?**
- Containers in the same Docker network can communicate directly
- Faster than going through ngrok
- No external dependencies

### Method 2: External URL (via ngrok)

If calling from outside Docker network:

- **URL:** `https://YOUR_NGROK_DOMAIN/evolution-api/message/sendText/my-whatsapp`

## Webhook Configuration

### Set Up Webhook in n8n

1. Create a Webhook node in n8n
2. Copy the webhook URL
3. Configure Evolution API to send events to this URL

```bash
curl -X POST http://localhost:8080/webhook/set/my-whatsapp \
  -H 'Content-Type: application/json' \
  -H 'apikey: YOUR_EVOLUTION_API_KEY' \
  -d '{
    "url": "https://YOUR_NGROK_DOMAIN/webhook/whatsapp",
    "webhook_by_events": true,
    "events": [
      "MESSAGES_UPSERT",
      "MESSAGES_UPDATE",
      "CONNECTION_UPDATE"
    ]
  }'
```

### Webhook Events

- `MESSAGES_UPSERT` - New message received
- `MESSAGES_UPDATE` - Message status updated
- `CONNECTION_UPDATE` - Connection status changed
- `QRCODE_UPDATED` - QR code updated
- `GROUPS_UPSERT` - Group created/updated

## Troubleshooting

### Instance not connecting

```bash
# Check Evolution API logs
docker-compose logs evolution-api

# Verify Redis is running
docker-compose exec redis redis-cli ping

# Restart Evolution API
docker-compose restart evolution-api
```

### API returns 401 Unauthorized

Check your API key matches the one in `.env`:

```bash
cat .env | grep EVOLUTION_API_KEY
```

### QR code expired

Delete and recreate the instance:

```bash
curl -X DELETE http://localhost:8080/instance/delete/my-whatsapp \
  -H 'apikey: YOUR_EVOLUTION_API_KEY'

# Then create new instance
```

## Resources

- [Evolution API Documentation](https://doc.evolution-api.com/v2/en)
- [n8n HTTP Request Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/)
- [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp)

