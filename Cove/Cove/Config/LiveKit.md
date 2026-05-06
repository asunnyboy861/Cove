# LiveKit Cloud Configuration

## Credentials
- **Server URL**: `wss://cove-kql9fowp.livekit.cloud`
- **API Key**: `APIMHobLy2Nny6k`
- **API Secret**: ⚠️ **Store securely in backend**

## Current Setup (MVP Testing)

For MVP testing, a pre-generated token is embedded in `LiveKitService.swift`:
```swift
private let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Limitations**:
- Token expires after 15 minutes
- Fixed participant identity (testuser)
- Fixed room name (test-room)
- Not suitable for production

## Production Setup (Required)

### Option 1: Simple Token Server (Recommended)

Create a minimal backend to generate tokens dynamically:

**Node.js Example**:
```javascript
const express = require('express');
const { AccessToken } = require('livekit-server-sdk');

const app = express();
const API_KEY = 'APIMHobLy2Nny6k';
const API_SECRET = 'YOUR_SECRET_FROM_LIVEKIT';

app.post('/token', (req, res) => {
  const { room, participant } = req.body;
  
  const token = new AccessToken(API_KEY, API_SECRET, {
    identity: participant,
    name: participant,
  });
  
  token.addGrant({ roomJoin: true, room });
  
  res.json({ token: token.toJwt() });
});

app.listen(3000, () => {
  console.log('Token server running on port 3000');
});
```

**Update LiveKitService.swift**:
```swift
private func generateToken(room: String, participant: String) async throws -> String {
    let url = URL(string: "https://your-backend.com/token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: [
        "room": room,
        "participant": participant
    ])
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONDecoder().decode(TokenResponse.self, from: data)
    return response.token
}

struct TokenResponse: Codable {
    let token: String
}
```

### Option 2: LiveKit Cloud Token Server

LiveKit Cloud offers a hosted token server. Configure in:
1. Go to https://cloud.livekit.io/projects/p:livekit-cove
2. Settings → Token Server
3. Enable and configure

Then update `LiveKitService.swift` to use the token server URL.

## Next Steps

1. **Get API Secret**:
   - Go to LiveKit Cloud → API keys
   - Click menu (⋮) next to your key
   - Select "View Secret" or "Regenerate"
   - Save it securely

2. **For MVP Testing**:
   - Current setup works for 15 minutes
   - Generate new token when expired
   - Use LiveKit Cloud dashboard to generate tokens

3. **For Production**:
   - Deploy token server (Node.js example above)
   - Store API Secret in environment variables
   - Update `generateToken()` method

## LiveKit Cloud Dashboard

- **Project**: https://cloud.livekit.io/projects/p:livekit-cove
- **API Keys**: Settings → API keys
- **Token Generator**: Use dashboard to generate test tokens

## Testing

To test voice rooms:
1. Build and run app
2. Navigate to Voice Rooms
3. Join a room
4. Test audio (mute/unmute)
