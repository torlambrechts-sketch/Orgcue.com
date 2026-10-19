// Local stand-in for Supabase Auth, for testing the signed-in app without real accounts or emails.
// It answers /auth/v1/* itself (one fixed account) and forwards everything else (/rest/v1/*) to the real
// Supabase project with the anon key. Build the app with NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321.
// Only useful while the database still grants anon access (before supabase/migrations/0003_auth.sql).
// Usage: node tests/e2e/mock-auth.mjs   (reads the real URL and key from .env.local)
import http from 'node:http';
import { readFileSync } from 'node:fs';

const env = Object.fromEntries(readFileSync(new URL('../../.env.local', import.meta.url), 'utf8').split('\n').filter((l) => l.includes('=')).map((l) => [l.slice(0, l.indexOf('=')), l.slice(l.indexOf('=') + 1).trim()]));
const UPSTREAM = env.NEXT_PUBLIC_SUPABASE_URL, KEY = env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
export const MOCK = { email: 'mock@orgcue.test', password: 'mock-password-123', name: 'Mock Tester' };
const user = { id: '7a6b5c4d-0000-4000-8000-00000000abcd', aud: 'authenticated', role: 'authenticated', email: MOCK.email, email_confirmed_at: new Date().toISOString(), identities: [{ id: 'i', provider: 'email' }], user_metadata: { full_name: MOCK.name }, app_metadata: { provider: 'email' }, created_at: new Date().toISOString() };
const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
const now = () => Math.floor(Date.now() / 1000);
const token = b64({ alg: 'HS256', typ: 'JWT' }) + '.' + b64({ sub: user.id, role: 'authenticated', aud: 'authenticated', email: MOCK.email, exp: now() + 3600 * 24, iat: now(), session_id: 's' }) + '.mock';
const CORS = { 'access-control-allow-origin': '*', 'access-control-allow-headers': '*', 'access-control-allow-methods': 'GET,POST,PUT,PATCH,DELETE,OPTIONS', 'access-control-expose-headers': '*' };
const send = (res, status, body) => { res.writeHead(status, { ...CORS, 'content-type': 'application/json' }); res.end(body === undefined ? '' : JSON.stringify(body)); };
const read = (req) => new Promise((ok) => { const c = []; req.on('data', (d) => c.push(d)); req.on('end', () => ok(Buffer.concat(c))); });

http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') { res.writeHead(204, CORS); return res.end(); }
  const url = new URL(req.url, 'http://x');
  const body = await read(req);
  if (url.pathname.startsWith('/auth/v1/')) {
    const p = url.pathname.slice(9), auth = req.headers.authorization || '';
    if (p === 'token') {
      const j = JSON.parse(body.toString() || '{}');
      if (url.searchParams.get('grant_type') === 'refresh_token' || (j.email === MOCK.email && j.password === MOCK.password))
        return send(res, 200, { access_token: token, token_type: 'bearer', expires_in: 86400, expires_at: now() + 86400, refresh_token: 'mock-refresh', user });
      return send(res, 400, { code: 'invalid_credentials', error_code: 'invalid_credentials', msg: 'Invalid login credentials' });
    }
    if (p === 'user') return auth === 'Bearer ' + token ? send(res, 200, user) : send(res, 403, { code: 'bad_jwt', msg: 'invalid JWT' });
    if (p === 'logout') return send(res, 204);
    return send(res, 200, {});
  }
  // Data: forward to the real project as the anon role.
  const headers = { ...req.headers, apikey: KEY, authorization: 'Bearer ' + KEY };
  delete headers.host; delete headers['content-length']; delete headers.origin; delete headers.referer;
  const r = await fetch(UPSTREAM + req.url, { method: req.method, headers, body: ['GET', 'HEAD'].includes(req.method) ? undefined : body });
  const out = Buffer.from(await r.arrayBuffer());
  const h = { ...CORS }; r.headers.forEach((v, k) => { if (!['content-encoding', 'content-length', 'transfer-encoding', 'connection'].includes(k) && !k.startsWith('access-control')) h[k] = v; });
  res.writeHead(r.status, h); res.end(out);
}).listen(54321, () => console.log('mock auth on http://localhost:54321 → data from', UPSTREAM));
