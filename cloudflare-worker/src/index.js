// LiveKit Token Server on Cloudflare Workers
// Deploy: npx wrangler deploy
// Docs: https://developers.cloudflare.com/workers/

export default {
  async fetch(request, env) {
    // CORS headers for iOS app access
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    // Handle CORS preflight request
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // Only allow POST requests
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { 
        status: 405,
        headers: corsHeaders 
      });
    }

    try {
      // Parse request body
      const { room, participant } = await request.json();

      // Validate inputs
      if (!room || !participant) {
        return new Response('Missing room or participant', { 
          status: 400,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ error: 'Missing room or participant' }),
        });
      }

      // Get credentials from environment variables
      const API_KEY = env.API_KEY;
      const API_SECRET = env.API_SECRET;

      if (!API_KEY || !API_SECRET) {
        return new Response('Server configuration error', { 
          status: 500,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ error: 'Missing API credentials' }),
        });
      }

      // Generate JWT token
      const token = await generateToken(API_KEY, API_SECRET, {
        identity: participant,
        name: participant,
        room: room,
      });

      return new Response(JSON.stringify({ token }), {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      });
    } catch (error) {
      console.error('Token generation error:', error);
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      });
    }
  },
};

/**
 * Generate LiveKit JWT token
 * @param {string} apiKey - LiveKit API Key
 * @param {string} apiSecret - LiveKit API Secret
 * @param {Object} options - Token options
 * @returns {Promise<string>} JWT token
 */
async function generateToken(apiKey, apiSecret, options) {
  const header = {
    alg: 'HS256',
    typ: 'JWT',
  };

  const now = Math.floor(Date.now() / 1000);
  const payload = {
    exp: now + 86400, // Token valid for 24 hours
    iat: now,
    iss: apiKey,
    nbf: now,
    sub: options.identity,
    video: {
      room: options.room,
      roomJoin: true,
      canPublish: true,
      canPublishData: true,
      canSubscribe: true,
    },
  };

  // Base64URL encode
  const encoder = new TextEncoder();
  const base64Url = (obj) => 
    btoa(JSON.stringify(obj))
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=+$/, '');

  const headerStr = base64Url(header);
  const payloadStr = base64Url(payload);

  // Sign with HMAC-SHA256 using Web Crypto API
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(apiSecret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );

  const signature = await crypto.subtle.sign(
    'HMAC',
    key,
    encoder.encode(`${headerStr}.${payloadStr}`)
  );

  const signatureStr = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');

  return `${headerStr}.${payloadStr}.${signatureStr}`;
}
