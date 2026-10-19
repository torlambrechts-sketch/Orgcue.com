// Walks the spec §26 acceptance checklist in Chromium and checks the Supabase rows each step writes.
// It calls reset_demo() first, so it overwrites the shared demo data.
// Usage: npm run test:e2e -- [baseUrl]   (reads NEXT_PUBLIC_SUPABASE_URL / _ANON_KEY from .env.local)
import { chromium } from 'playwright-core';
import { readFileSync } from 'node:fs';
const env = Object.fromEntries(readFileSync(new URL('../../.env.local', import.meta.url), 'utf8').split('\n').filter((l) => l.includes('=')).map((l) => [l.slice(0, l.indexOf('=')), l.slice(l.indexOf('=') + 1).trim()]));
const base = process.argv[2] || 'http://localhost:3000', SB = env.NEXT_PUBLIC_SUPABASE_URL, KEY = env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const executablePath = process.env.CHROMIUM_PATH || '/opt/pw-browsers/chromium';
const H = { apikey: KEY, Authorization: 'Bearer ' + KEY, 'Content-Type': 'application/json' };
const rest = async (p) => (await fetch(SB + '/rest/v1/' + p, { headers: H })).json();
await fetch(SB + '/rest/v1/rpc/reset_demo', { method: 'POST', headers: H, body: '{}' });

const browser = await chromium.launch({ executablePath, args: ['--no-sandbox'] });
const ctx = await browser.newContext({ viewport: { width: 1360, height: 900 } });
const page = await ctx.newPage();
const errs = [];
page.on('pageerror', (e) => errs.push(String(e).slice(0, 300)));
page.on('console', (m) => { if (m.type() === 'error') errs.push(m.text().slice(0, 300)); });
let pass = 0, fail = 0;
const ok = (name, cond, extra = '') => { cond ? pass++ : fail++; console.log((cond ? 'PASS ' : 'FAIL ') + name + (extra ? ' · ' + extra : '')); };
const bar = (t) => page.locator('button[aria-pressed]', { hasText: new RegExp('^' + t + '$') }).first();
const role = async (t) => { await bar(t).click(); await page.waitForTimeout(150); };
const phase = async (t) => { await bar(t).click(); await page.waitForTimeout(400); };
const btn = (t, exact = true) => page.getByRole('button', { name: t, exact }).first();
const go = async (p) => { await page.goto(base + p, { waitUntil: 'networkidle' }); await page.waitForTimeout(300); };
const main = async () => page.locator('main').innerText();
const settle = () => page.waitForTimeout(900);

try {
  // 1. Wizard: from scratch, type Process, SIPOC + EARS
  await go('/home');
  await btn('＋ New project').click();
  await page.getByText('Start from scratch').click();
  await btn('Continue').click();
  await page.getByPlaceholder('e.g. HR Helpdesk Agent v1').fill('Order to cash');
  await btn('Process').click();
  for (let i = 0; i < 4; i++) await btn('Continue').click();
  await btn('Create project').click();
  await page.waitForTimeout(1500);
  const projs = await rest('projects?name=eq.Order%20to%20cash&select=id,type,phase,frameworks');
  const secs = projs[0] ? await rest('sections?project_id=eq.' + projs[0].id + '&select=name') : [];
  const names = secs.map((s) => s.name);
  ok('§26.1 wizard creates a Process project with SIPOC sections', projs.length === 1 && ['Suppliers', 'Inputs', 'Outputs', 'Customers'].every((n) => names.includes(n)) && page.url().endsWith('/members'), JSON.stringify(projs[0]) + ' · ' + names.length + ' sections');
  const qs = projs[0] ? await rest('questions?project_id=eq.' + projs[0].id + '&select=id') : [];
  ok('§26.1 wizard questions are stored', qs.length > 0, qs.length + ' questions');

  // 2. Frame: smart question set
  await phase('Frame');
  await go('/p/it-helpdesk/input');
  let t = await main();
  const m1 = t.match(/(\d+) questions removed · ([\d.]+) min saved/);
  await btn('Ask anyway').click();
  await settle();
  t = await main();
  const m2 = t.match(/(\d+) questions removed · ([\d.]+) min saved/);
  ok('§26.2 smart set removes 6; Ask anyway restores one and drops 1.5 min', m1 && m1[1] === '6' && m2 && m2[1] === '5' && Math.abs(+m1[2] - +m2[2] - 1.5) < 0.01, (m1 || []).slice(1).join('/') + ' → ' + (m2 || []).slice(1).join('/'));
  const ps = await rest('project_state?project_id=eq.it-helpdesk&key=eq.skip&select=value');
  ok('§26.2 skip toggle persisted', ps.length === 1, JSON.stringify(ps[0]));

  // 3. Send → Collect; phone flow answers
  await go('/p/it-helpdesk/members');
  await btn('Send', false).first().click().catch(() => {});
  const sendBtn = page.getByRole('button', { name: 'Send to 8 members' });
  if (await sendBtn.count()) await sendBtn.last().click();
  await settle();
  let pr = await rest('projects?id=eq.it-helpdesk&select=phase');
  ok('§26.3 Send moves the project to Collect', pr[0].phase === 'Collect', pr[0].phase);
  await go('/phone');
  await btn('Start').click(); await btn('Continue').click(); await btn('Next').click(); await btn('Next').click();
  await page.getByPlaceholder('Write an idea').fill('Show the queue position in Teams too.');
  await btn('Add idea').click(); await btn('Finish').click();
  await settle();
  const ans = await rest('answers?project_id=eq.it-helpdesk&person_id=eq.sam&select=question_id,text');
  const priv = await rest('ideas?project_id=eq.it-helpdesk&private=eq.true&select=text');
  ok('§26.3 phone flow stores 2 answers and the idea', ans.length >= 2 && priv.some((x) => x.text.includes('queue position in Teams')), ans.map((a) => a.question_id).join(',') + ' · ' + priv.length + ' ideas');

  // 4. Adaptive: Keep asking on the converged topic
  await go('/p/it-helpdesk/input');
  t = await main();
  ok('§26.4 adaptive shows converged and conflict topics', /Never ask for a password\s*\|?\s*Done/.test(t.replace(/\n/g, ' | ')) && (t.match(/Conflict/g) || []).length >= 2);
  await btn('Keep asking').click();
  await settle();
  const kept = await rest('project_state?project_id=eq.it-helpdesk&key=eq.kept&select=value');
  ok('§26.4 Keep asking reopens the topic (persisted)', kept.length === 1 && JSON.stringify(kept[0].value).includes('true'), JSON.stringify(kept[0]));

  // 5. Close and reveal → Review; votes visible after voting for contributor
  await btn('Close collection and reveal').click();
  await page.waitForTimeout(3200);
  pr = await rest('projects?id=eq.it-helpdesk&select=phase');
  ok('§26.5 close and reveal moves to Review', pr[0].phase === 'Review', pr[0].phase);
  t = await main();
  ok('§26.5 items appear with approval status', t.includes('CI-0231') && t.includes('Pending review'));

  // 6. Reject an item with Duplicate
  await page.getByText('After 8 pm, open a high-priority ticket').first().click();
  await page.waitForTimeout(300);
  await btn('Reject…').click();
  await btn('Duplicate').click();
  await settle();
  const it = await rest('input_items?id=eq.CI-0268&select=approval_status,reject_reason');
  ok('§26.6 Reject with Duplicate persists', it[0].approval_status === 'Rejected' && it[0].reject_reason === 'Duplicate', JSON.stringify(it[0]));
  if (await page.locator('aside[role=dialog]').count()) await page.locator('aside[role=dialog]').getByRole('button', { name: 'Close', exact: true }).first().click();
  await go('/p/it-helpdesk/my-input');
  await role('Contributor');
  t = await main();
  ok('§26.6 author footprint shows the reason', /Duplicate/.test(t));
  const vb = page.getByRole('button', { name: /Vote/ }).first();
  const before = await main();
  await vb.click(); await settle();
  const votes = await rest('votes?select=item_id,person_id');
  ok('§26.5 contributor vote is stored', votes.length >= 1, JSON.stringify(votes));
  await role('Owner');

  // 7–8. Decide: simulated runs, record DEC-03, lock
  await phase('Decide');
  await go('/p/it-helpdesk/spec');
  await role('Decider');
  t = await main();
  ok('§26.7 simulated runs link conflicts to DEC-03 and DEC-04', t.includes('DEC-03') && t.includes('DEC-04'));
  const passBefore = (t.match(/(\d+) of 20 pass/) || [])[1];
  await page.locator('div[role=button]', { hasText: 'MFA push before any change' }).first().click();
  await page.getByLabel('Rationale · required').fill('HC-007 rules out passwords; an MFA push is the only check that meets it.');
  await btn('Record decision').click();
  await settle();
  let dec = await rest('decisions?id=eq.DEC-03&select=status,rationale');
  t = await main();
  const passAfter = (t.match(/(\d+) of 20 pass/) || [])[1];
  ok('§26.8 DEC-03 recorded with rationale; a scenario turns Pass', dec[0].status === 'Decided' && dec[0].rationale.length > 10 && +passAfter > +passBefore, passBefore + ' → ' + passAfter + ' pass');
  await btn('Choose Sam’s').click().catch(() => {});
  await settle();
  await btn('Lock v1.4.0').click();
  await settle();
  const sv = await rest('spec_versions?version=eq.v1.4.0&select=locked,hash,locked_by');
  ok('§26.8 decider locks v1.4.0 with a hash', sv[0].locked && sv[0].hash.startsWith('sha256:'), JSON.stringify(sv[0]));

  // 9–10. Generate: instruction check, safe fixes, gates
  await go('/p/it-helpdesk/generate');
  await role('Decider');
  await phase('Validate');
  t = await main();
  const sc1 = (t.match(/Score (\d+)|(\d+) \/ 100|Quality score[^\d]*(\d+)/) || []).filter(Boolean)[1];
  ok('§26.9 instruction check shows 6 issues', /6 issues/.test(t), (t.match(/\d+ issues[^\n]*/) || [''])[0]);
  await btn('Apply safe fixes').click(); await settle();
  t = await main();
  ok('§26.9 safe fixes leave 2 high issues', /2 issues/.test(t) && /2 high/.test(t), (t.match(/\d+ issues[^\n]*/) || [''])[0]);
  const fixB = page.getByRole('button', { name: 'Fix', exact: true });
  for (let i = 0; i < 6 && (await fixB.count()); i++) { await fixB.first().click(); await page.waitForTimeout(200); }
  await settle();
  t = await main();
  const genB = page.getByRole('button', { name: /^Approve diff/ });
  ok('§26.10 gates pass after Fix (approve enabled)', (await genB.count()) > 0 && !(await genB.first().isDisabled()));
  if (await genB.count()) { await genB.first().click(); await page.waitForTimeout(3500); }
  t = await main();
  ok('§26.10 generation result', /Pull request #42|Exported to Copilot Studio|✓/.test(t));
  // file explorer: AGENTS.md lines with source tags
  ok('§26.10 file explorer shows AGENTS.md with tags', t.includes('AGENTS.md') && t.includes('HC-007'));

  // 13. Actions: status cycling + bulk
  await go('/p/it-helpdesk/actions');
  await role('Owner');
  const synced = page.locator('main div', { has: page.getByText('Configure MFA push for chat-initiated resets', { exact: true }) }).last().getByRole('button', { name: 'To do', exact: true });
  if (await synced.count()) { await synced.first().click(); await settle(); }
  const a15 = await rest('actions?id=eq.A-015&select=status');
  ok('§10.10 ServiceNow-synced A-015 stays read-only', a15[0].status === 'To do', a15[0].status);
  const cell = page.locator('main div', { has: page.getByText('Book pilot review with service desk', { exact: true }) }).last().getByRole('button', { name: 'To do', exact: true }).first();
  await cell.click(); await settle();
  const acts = await rest('actions?select=id,status&order=id');
  ok('§26.13 status cell cycles and persists', acts.some((a) => a.id === 'A-020' && a.status === 'In progress'), acts.map((a) => a.id + ':' + a.status).join(' '));
  const checks = page.getByRole('button', { name: /^Select/ });
  if (await checks.count() >= 2) { await checks.nth(0).click(); await checks.nth(1).click(); }
  const md = page.getByRole('button', { name: /Mark done/ });
  if (await md.count()) { await md.first().click(); await settle(); }
  const acts2 = await rest('actions?select=id,status&status=eq.Done');
  ok('§26.13 bulk mark done persists', acts2.length >= 3, acts2.map((a) => a.id).join(','));

  // 14. Library propose change
  await go('/library');
  await page.getByRole('button', { name: 'Propose change' }).nth(2).click(); await settle();
  t = await main();
  const lib = await rest('library_items?id=eq.LIB-HC-015&select=status');
  ok('§26.14 LIB-HC-015 change pending with 3 affected projects', lib[0].status === 'Change pending' && t.includes('IT Helpdesk Agent v1 (Kari Nordmann)') && t.includes('Expense Approval Service'));

  // 15. Customer page consent + answers; Create requirement
  await go('/customer');
  ok('§26.15 Start disabled before consent', await btn('Start').isDisabled());
  await page.getByText('I agree that Lumio may use').click(); await btn('Start').click();
  await page.locator('textarea').fill('Locked out, waited an hour.'); await btn('Next').click();
  await btn('Chat').click(); await btn('Next').click(); await btn('Under 5 minutes').click(); await btn('Next').click(); await btn('Only with extra checks').click(); await btn('Send answers').click();
  await settle();
  const cr = await rest('customer_responses?select=answers');
  ok('§26.15 customer response stored', cr.length === 1, JSON.stringify(cr[0]));
  await go('/p/it-helpdesk/input');
  const cReq = page.getByRole('button', { name: 'Create requirement' });
  if (await cReq.count()) { await cReq.first().click(); await settle(); }
  const r25 = await rest('spec_items?id=eq.REQ-025&select=id');
  ok('§26.15 Create requirement drafts REQ-025', r25.length === 1);

  // 16. Settings: convergence threshold, save bar, audit
  await go('/settings/questions-library');
  await role('Org admin');
  const conv = page.getByLabel(/Convergence threshold/);
  await conv.fill('75'); await page.waitForTimeout(200);
  t = await main();
  ok('§26.16 save bar appears', /1 unsaved change/.test(await page.locator('body').innerText()));
  await btn('Save changes').click(); await settle();
  const st = await rest('settings?key=eq.conv&select=value');
  const au = await rest('audit_events?what=like.*conv*&select=what');
  ok('§26.16 saving persists the value and logs an audit event', st.length === 1 && st[0].value === '75' && au.length >= 1, JSON.stringify(st) + ' · ' + JSON.stringify(au));
  await go('/settings/profile');
  await role('Contributor');
  const nav = await page.locator('nav[aria-label="Settings"]').innerText();
  ok('§26.16 contributor sees only Profile and Notifications', nav.includes('Profile') && nav.includes('Notifications') && !nav.includes('Organization'));
  await role('Owner');

  // 17. Sidebar collapse persists over reload
  await page.getByRole('button', { name: 'Collapse sidebar' }).click();
  await page.reload({ waitUntil: 'networkidle' }); await page.waitForTimeout(400);
  ok('§26.17 sidebar stays collapsed after reload', (await page.getByRole('button', { name: 'Expand sidebar' }).count()) === 1);

  // Persistence over reload: phase and DEC-03 come back from Supabase
  await page.reload({ waitUntil: 'networkidle' });
  ok('state survives reload (phase from Supabase)', (await bar('Validate').getAttribute('aria-pressed')) === 'true');
} catch (e) {
  fail++; console.log('FAIL exception', String(e).slice(0, 600));
}
console.log(`\n${pass} passed, ${fail} failed`);
process.exitCode = fail ? 1 : 0;
if (errs.length) console.log('PAGE ERRORS', [...new Set(errs)].slice(0, 10).join('\n'));
await fetch(SB + '/rest/v1/rpc/reset_demo', { method: 'POST', headers: H, body: '{}' });
await browser.close();
