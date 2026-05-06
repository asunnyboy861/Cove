# LiveKit Cloud Configuration

## Credentials
- **Server URL**: `wss://cove-kql9fowp.livekit.cloud`
- **API Key**: `APIMHobLy2Nny6k`
- **API Secret**: ⚠️ **NEEDS TO BE GENERATED AND STORED SECURELY**

## Security Notes

### ⚠️ IMPORTANT: API Secret Security

The API Secret should **NEVER** be stored in the iOS app code. It must be kept on a backend server.

### Current Setup (Development Only)
For testing purposes only, you can temporarily add the secret to the app:

```swift
// In LiveKitService.swift - DEVELOPMENT ONLY
private let apiSecret = "YOUR_GENERATED_SECRET" // ⚠️ Replace before production
```

### Production Setup (Required)

For production, implement a token server:

1. **Create a simple backend** (Node.js example):
```javascript
const express = require('express');
const { AccessToken } = require('livekit-server-sdk');

const app = express();
const API_KEY = 'APIMHobLy2Nny6k';
const API_SECRET = 'YOUR_SECRET';

app.post('/token', (req, res) => {
  const { room, participant } = req.body;
  
  const token = new AccessToken(API_KEY, API_SECRET, {
    identity: participant,
    name: participant,
  });
  
  token.addGrant({ roomJoin: true, room });
  
  res.json({ token: token.toJwt() });
});

app.listen(3000);
```

2. **Update LiveKitService.swift**:
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

## Next Steps

1. Generate API Secret in LiveKit Cloud Console
2. For MVP testing: Add secret to code temporarily
3. For production: Deploy token server
4. Update `generateToken()` method to use backend

## LiveKit Cloud Dashboard

Access your project: https://cloud.livekit.io/projects/p:livekit-cove
