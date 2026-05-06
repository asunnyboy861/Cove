# LiveKit Cloud Configuration

## Credentials
- **Server URL**: `wss://cove-kql9fowp.livekit.cloud`
- **API Key**: `API9m8qZmwgKCKp`
- **API Secret**: ✅ Configured in Cloudflare Worker

## Production Setup (Complete)

### Token Server: Cloudflare Workers
- **URL**: `https://cove-token-server.iocompile67692.workers.dev`
- **Status**: ✅ Deployed
- **Cost**: Free (100K requests/day)

The token server automatically generates JWT tokens for LiveKit room access.

## How It Works

1. iOS app requests token from Cloudflare Worker
2. Worker validates request and generates JWT token
3. Token is valid for 24 hours
4. App uses token to join LiveKit voice rooms

## Configuration Files

- `cloudflare-worker/src/index.js` - Token server code
- `cloudflare-worker/wrangler.toml` - Cloudflare config
- `Cove/Services/LiveKitService.swift` - iOS integration

## Testing

Test the token server:
```bash
curl -X POST https://cove-token-server.iocompile67692.workers.dev \
  -H "Content-Type: application/json" \
  -d '{"room":"test-room","participant":"testuser"}'
```

Expected response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## LiveKit Cloud Dashboard

- **Project**: https://cloud.livekit.io/projects/p:livekit-cove
- **API Keys**: Settings → API keys
- **Sessions**: Monitor active voice rooms

## Next Steps

1. ✅ Deploy Cloudflare Worker
2. ✅ Configure API credentials
3. ✅ Update iOS code
4. ⏳ Test voice room functionality

## Security Notes

- API Secret is stored securely in Cloudflare Workers (not in iOS app)
- Tokens expire after 24 hours
- Each participant gets a unique token
- CORS enabled for iOS app access
