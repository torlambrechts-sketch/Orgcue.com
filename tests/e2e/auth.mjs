// Sign-up / log-in checks in Chromium against a running app. No test sends an email: the Supabase endpoints that
// would (sign-up, resend, password reset) are intercepted. With ORGCUE_TEST_EMAIL / ORGCUE_TEST_PASSWORD in
// .env.local (a confirmed account), it also logs in for real and logs out.
// Usage: npm run test:auth -- [baseUrl]
import { readFileSync } from 'node:fs';
import { chromium } from 'playwright-core';

const fileEnv = Object.fromEntries(readFileSync(new URL('../../.env.local', import.meta.url), 'utf8').split('\n').filter((l) => l.includes('=')).map((l) => [l.slice(0, l.indexOf('=')), l.slice(l.indexOf('=') + 1).trim()]));
// ORGCUE_TEST_* and E2E_SUPABASE_URL (e.g. the local mock-auth server) may come from the shell; nothing else does,
// because this container exports a NEXT_PUBLIC_SUPABASE_URL for another project.
const env = { ...fileEnv, ...Object.fromEntries(Object.entries(process.env).filter(([k]) => k.startsWith('ORGCUE_TEST_'))), ...(process.env.E2E_SUPABASE_URL ? { NEXT_PUBLIC_SUPABASE_URL: process.env.E2E_SUPABASE_URL } : {}) };
const base = process.argv[2] || 'http://localhost:3000';
const browser = await chromium.launch({ executablePath: process.env.CHROMIUM_PATH || '/opt/pw-browsers/chromium', args: ['--no-sandbox'] });
let pass = 0, fail = 0;
const ok = (name, cond, extra = '') => { cond ? pass++ : fail++; console.log((cond ? 'PASS ' : 'FAIL ') + name + (extra ? ' · ' + extra : '')); };
const fresh = async () => { const ctx = await browser.newContext({ viewport: { width: 1280, height: 860 } }); const page = await ctx.newPage(); page.on('pageerror', (e) => console.log('PAGEERROR', String(e).slice(0, 200))); return page; };
const json = (body, status = 200) => ({ status, contentType: 'application/json', body: JSON.stringify(body) });
const fakeUser = (email, identities) => ({ id: '00000000-0000-4000-8000-000000000001', aud: 'authenticated', role: 'authenticated', email, identities, user_metadata: {}, app_metadata: {}, created_at: new Date().toISOString() });

try {
  let page = await fresh();
  // 1. Signed-out visitors are sent to log in, with the page they wanted kept.
  await page.goto(base + '/p/it-helpdesk/spec', { waitUntil: 'networkidle' });
  const u = new URL(page.url());
  ok('signed-out deep link goes to /login with next', u.pathname === '/login' && u.searchParams.get('next') === '/p/it-helpdesk/spec', page.url());
  await page.goto(base + '/', { waitUntil: 'networkidle' });
  ok('signed-out / goes to /login', new URL(page.url()).pathname === '/login');
  await page.goto(base + '/reset-password', { waitUntil: 'networkidle' });
  ok('reset-password needs a session', new URL(page.url()).pathname === '/login');
  await page.goto(base + '/login?next=//evil.example', { waitUntil: 'networkidle' });
  ok('login page renders', (await page.getByRole('heading', { name: 'Log in' }).count()) === 1);

  // 2. Real Supabase error for wrong credentials (no email involved).
  await page.getByLabel('Email').fill('nobody-' + Date.now() + '@orgcue.test');
  await page.getByLabel('Password').fill('not-the-password');
  await page.getByRole('button', { name: 'Log in', exact: true }).click();
  await page.locator('main [role=alert]').waitFor({ timeout: 10000 });
  ok('wrong credentials show a plain message', /don’t match an account/.test(await page.locator('main [role=alert]').innerText()));

  // 3. Sign-up validation and the confirmation state (Supabase sign-up is intercepted: no email is sent).
  await page.goto(base + '/signup', { waitUntil: 'networkidle' });
  await page.getByLabel('Full name').fill('Ada Test');
  await page.getByLabel('Work email').fill('ada@');
  await page.getByLabel('Password').fill('short');
  ok('password helper counts down', /3 more characters/.test(await page.locator('main').innerText()));
  await page.getByRole('button', { name: 'Create account' }).click();
  ok('invalid email is caught before calling Supabase', /full email address/.test(await page.locator('main [role=alert]').innerText()));
  let signupBody = null;
  let signupUrl = '';
  await page.route('**/auth/v1/signup*', (route) => { signupBody = route.request().postDataJSON(); signupUrl = route.request().url(); route.fulfill(json(fakeUser('ada@lumio.test', [{ id: 'x', provider: 'email' }]))); });
  await page.getByLabel('Work email').fill('ada@lumio.test');
  await page.getByLabel('Password').fill('correct-horse-battery');
  await page.getByRole('button', { name: 'Create account' }).click();
  await page.getByRole('heading', { name: 'Check your email' }).waitFor({ timeout: 10000 });
  ok('sign-up shows "Check your email" with the address', (await page.locator('main').innerText()).includes('ada@lumio.test'));
  const redirectTo = new URL(signupUrl).searchParams.get('redirect_to') || '';
  ok('sign-up sends the name and the /auth/callback redirect', signupBody && signupBody.data && signupBody.data.full_name === 'Ada Test' && redirectTo === base + '/auth/callback?next=%2Fhome', redirectTo);
  let resent = false;
  await page.route('**/auth/v1/resend*', (route) => { resent = true; route.fulfill(json({})); });
  await page.getByRole('button', { name: 'Send the link again' }).click();
  await page.getByText('Sent again').waitFor({ timeout: 10000 });
  ok('resend confirmation link', resent);

  page = await fresh();
  await page.route('**/auth/v1/signup*', (route) => route.fulfill(json(fakeUser('kari@lumio.test', []))));
  await page.goto(base + '/signup', { waitUntil: 'networkidle' });
  await page.getByLabel('Full name').fill('Kari Again'); await page.getByLabel('Work email').fill('kari@lumio.test'); await page.getByLabel('Password').fill('correct-horse-battery');
  await page.getByRole('button', { name: 'Create account' }).click();
  await page.locator('main [role=alert]').waitFor({ timeout: 10000 });
  ok('existing email is told to log in instead', /already exists/.test(await page.locator('main [role=alert]').innerText()));

  // 4. Forgot password (intercepted) answers the same for every address.
  let recover = null;
  await page.route('**/auth/v1/recover*', (route) => { recover = route.request().postDataJSON(); route.fulfill(json({})); });
  await page.goto(base + '/forgot-password', { waitUntil: 'networkidle' });
  await page.getByLabel('Email').fill('kari@lumio.test');
  await page.getByRole('button', { name: 'Send reset link' }).click();
  await page.getByRole('heading', { name: 'Check your email' }).waitFor({ timeout: 10000 });
  ok('forgot password sends to Supabase and confirms neutrally', recover && recover.email === 'kari@lumio.test' && /If .* has an Orgcue account/.test(await page.locator('main').innerText()));

  // 5. Expired email links land on the login page with an explanation.
  await page.goto(base + '/auth/callback?code=not-a-real-code', { waitUntil: 'networkidle' });
  ok('bad email link explains itself on /login', new URL(page.url()).pathname === '/login' && (await page.locator('main').innerText()).includes('If you just confirmed your email'));

  // 6. The customer answer page needs no account and shows no workspace chrome.
  page = await fresh();
  await page.goto(base + '/customer', { waitUntil: 'networkidle' });
  await page.waitForTimeout(500);
  const body = await page.locator('body').innerText();
  ok('customer page is public and bare', new URL(page.url()).pathname === '/customer' && body.includes('Help us build a better support assistant') && !body.includes('Demo controls') && !body.includes('Back to the project'));

  // 7. Real log-in and log-out with a confirmed test account.
  if (env.ORGCUE_TEST_EMAIL && env.ORGCUE_TEST_PASSWORD) {
    page = await fresh();
    await page.goto(base + '/library', { waitUntil: 'networkidle' });
    await page.getByLabel('Email').fill(env.ORGCUE_TEST_EMAIL);
    await page.getByLabel('Password').fill(env.ORGCUE_TEST_PASSWORD);
    await page.getByRole('button', { name: 'Log in', exact: true }).click();
    await page.waitForURL('**/library', { timeout: 15000 });
    await page.getByRole('heading', { name: 'Library' }).waitFor({ timeout: 15000 });
    ok('log in returns to the page asked for', new URL(page.url()).pathname === '/library');
    await page.goto(base + '/login', { waitUntil: 'networkidle' });
    ok('signed-in /login goes to /home', new URL(page.url()).pathname === '/home');
    await page.getByRole('button', { name: /^Account · / }).click();
    ok('account menu shows the email', (await page.getByRole('menu').innerText()).includes(env.ORGCUE_TEST_EMAIL));
    await page.getByRole('menuitem', { name: 'Log out' }).click();
    await page.waitForURL('**/login', { timeout: 15000 });
    await page.goto(base + '/home', { waitUntil: 'networkidle' });
    ok('after log out the app is closed again', new URL(page.url()).pathname === '/login');
  } else console.log('SKIP real log-in: set ORGCUE_TEST_EMAIL and ORGCUE_TEST_PASSWORD in .env.local');
} catch (e) { fail++; console.log('FAIL exception', String(e).slice(0, 500)); }
console.log(`\n${pass} passed, ${fail} failed`);
process.exitCode = fail ? 1 : 0;
await browser.close();
