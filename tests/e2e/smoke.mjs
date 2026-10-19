// Smoke test: visits every route, reports page errors and failed requests, saves screenshots.
// Usage: npm run test:smoke -- [outDir]   (BASE=https://orgcue.vercel.app to test a deployment)
import { chromium } from 'playwright-core';
import { mkdirSync } from 'node:fs';
const out = process.argv[2] || 'tests/e2e/shots';
mkdirSync(out, { recursive: true });
const base = process.env.BASE || 'http://localhost:3000';
const browser = await chromium.launch({ executablePath: process.env.CHROMIUM_PATH || '/opt/pw-browsers/chromium', args: ['--no-sandbox'] });
const page = await browser.newPage({ viewport: { width: 1280, height: 860 } });
const errs = [];
page.on('console', (m) => { if (m.type() === 'error' && !m.text().startsWith('Failed to load resource')) errs.push(m.text().slice(0, 300)); });
const bad = new Set(); page.on('response', (r) => { if (r.status() >= 400) bad.add(r.status() + ' ' + r.url().slice(0, 140)); });
page.on('pageerror', (e) => errs.push('PAGEERROR ' + String(e).slice(0, 400)));
const routes = (process.argv[3] || '/home,/projects,/templates,/library,/portfolio,/p/it-helpdesk/overview,/p/it-helpdesk/members,/p/it-helpdesk/input,/p/it-helpdesk/brainstorm,/p/it-helpdesk/spec,/p/it-helpdesk/generate,/p/it-helpdesk/actions,/settings/integrations,/settings/questions-library,/phone,/customer').split(',');
for (const r of routes) {
  const before = errs.length;
  await page.goto(base + r, { waitUntil: 'networkidle' });
  await page.waitForTimeout(400);
  const name = r.replace(/\//g, '_').replace(/^_/, '') || 'root';
  await page.screenshot({ path: `${out}/${name}.png` });
  const text = await page.evaluate(() => document.querySelector('main')?.innerText.slice(0, 160).replace(/\n/g, ' | '));
  console.log(r, '→', JSON.stringify(text), errs.length > before ? `ERRORS: ${errs.slice(before).join(' || ')}` : '');
}
console.log('BAD RESPONSES', [...bad].slice(0, 30).join('\n'));
await browser.close();
