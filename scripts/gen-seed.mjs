// Generates supabase/seed.sql from the prototype's demo data (design/.../prototype/oc-data.js, spec §25).
// The seed is wrapped in a reset_demo() function so the app's "Reset demo" link can restore it.
// Usage: node scripts/gen-seed.mjs          (writes supabase/seed.sql)
//        node scripts/gen-seed.mjs --push   (also loads the rows into demo_seed over REST and runs reset_demo())
import { readFileSync, writeFileSync } from 'node:fs';
import vm from 'node:vm';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const src = readFileSync(path.join(root, 'design/design_handoff_orgcue/prototype/oc-data.js'), 'utf8');
const ctx = { window: {} };
vm.runInNewContext(src, ctx);
const D = ctx.window.OCD;

const TEXT_ARRAYS = new Set(['frameworks', 'groups']);
const q = (v, col) => {
  if (v === null || v === undefined) return 'null';
  if (typeof v === 'boolean') return v ? 'true' : 'false';
  if (typeof v === 'number') return String(v);
  if (TEXT_ARRAYS.has(col) && Array.isArray(v)) return 'array[' + v.map((x) => q(x)).join(',') + ']::text[]';
  if (typeof v === 'object') return q(JSON.stringify(v)) + '::jsonb';
  return "'" + String(v).replace(/'/g, "''") + "'";
};
const ins = (table, rows) => {
  if (!rows.length) return '';
  const cols = Object.keys(rows[0]);
  return `insert into ${table} (${cols.join(', ')}) values\n` + rows.map((r) => '  (' + cols.map((c) => q(r[c], c)).join(', ') + ')').join(',\n') + ';\n';
};
const P = 'it-helpdesk';
const byName = Object.fromEntries(Object.values(D.people).map((p) => [p.name, p.id]));
const out = [];
const T = [];
const add = (table, rows) => { T.push([table, rows]); return ins(table, rows); };

out.push(add('orgs', [{ id: 'lumio', name: 'Lumio Inc.', region: 'US' }]));
out.push(add('people', Object.values(D.people).map((p) => ({ id: p.id, name: p.name, title: p.title, org_role: p.orgRole, project_role: p.role, function_group: p.group, authority_areas: p.areas, channel: p.channel }))));
out.push(add('projects', D.projects.map((p) => ({
  id: p.id, name: p.name, type: p.type, phase: p.phase || 'Decide', owner_id: byName[p.owner] || null, owner_name: p.owner,
  decider_id: p.id === P ? 'daniel' : null, template: p.template || '', target: p.target, deadline: p.deadline || '',
  start_date: p.start, end_date: p.end, color: p.color, answered: p.answered, conflicts: p.conflicts, actions_count: p.actions, next_step: p.next,
  goal: p.id === P ? 'Take password resets, access, hardware and VPN requests off the service desk, within security and spending limits.' : '',
  frameworks: p.id === P ? ['nist', 'aiact', 'ears'] : [], groups: p.id === P ? ['Service desk', 'Security and risk', 'Finance', 'Legal and risk', 'People'] : [],
}))));
out.push(add('project_members', D.members.map((id, i) => ({ project_id: P, person_id: id, project_role: D.people[id].role, status: ['Done', 'Done', 'In progress', 'Done', 'Opened', 'Not started', 'Done', 'Done'][i] || 'Done', position: i }))));
out.push(add('templates', D.templates.map((t) => ({ id: t.id, category: t.cat, name: t.name, type: t.type, frameworks: t.fw, output: t.output, status: t.status, owner: t.owner, used: t.used, description: t.desc, is_new: t.isNew, updated: t.updated }))));
const secs = D.presets['AI agent'].concat(['Risk and impact', 'Roles and accountability', 'Monitoring after launch', 'Risk classification', 'Transparency to users']);
out.push(add('sections', secs.map((s, i) => ({ project_id: P, name: s, hint: D.sectionLib[s] || '', authority: ['Hard constraints', 'Data the AI may use', 'Escalation rules'].includes(s), restricted: D.restricted.includes(s), position: i }))));
out.push(add('questions', D.questions.map((x, i) => ({ id: x.id, project_id: P, section: x.section, target_group: x.group, text: x.q, position: i }))));
out.push(add('adaptive_topics', D.adaptive.map((x, i) => ({ id: x.id, project_id: P, topic: x.topic, state: x.state, evidence: x.ev, did: x.did, saved: x.saved, position: i }))));
out.push(add('input_items', D.items.map((x, i) => ({ id: x.id, project_id: P, version: x.v, section: x.section, type: x.type, strength: x.strength, group_name: x.group, author_id: x.by, text: x.text, original: x.orig, relation: x.rel, decision_id: x.dec, votes_seed: x.votes, comments_seed: x.comments, position: i }))));
out.push(add('item_versions', Object.entries(D.versions).flatMap(([item, vs]) => vs.map(([version, text, note]) => ({ item_id: item, version, text, note })))));
out.push(add('ideas', D.ideas.map((x, i) => ({ id: x.id, project_id: P, section: x.section, text: x.text, outcome: x.outcome, author_id: null, private: false, position: i }))));
out.push(add('decisions', D.decisions.map((d, i) => ({ id: d.id, project_id: P, title: d.title, note: d.note || '', warn: d.warn || '', done: d.done || '', options: d.opts || [], chosen: d.chosen ?? null, rationale: d.rationale || '', pinned: d.pins || '', follow_up: d.follow || '', status: d.done ? (d.done === 'Deferred' ? 'Deferred' : 'Decided') : 'Open', position: i }))));
out.push(add('spec_versions', [{ id: P + '-v1.3', project_id: P, version: 'v1.3', locked: true, locked_by: 'Daniel Reyes', locked_at: '2026-10-28T16:02:00Z', hash: 'sha256:7c41e09a' }, { id: P + '-v1.4.0', project_id: P, version: 'v1.4.0', locked: false, locked_by: '', locked_at: null, hash: '' }]));
out.push(add('spec_items', D.hcs.map((h, i) => ({ id: h.id, project_id: P, kind: 'HC', text: h.text, refs: '', provenance: '', owner_id: h.owner, review_date: h.review, position: i }))
  .concat(D.reqs.map((r, i) => ({ id: r.id, project_id: P, kind: 'REQ', text: r.text, refs: r.refs, provenance: r.prov, owner_id: null, review_date: '', position: 10 + i })))));
out.push(add('actions', D.actions.map((a, i) => ({ id: a.id, project_id: P, title: a.title, source: a.source, owner_id: a.owner, acceptance: a.accept, status: a.status, priority: a.prio, due: a.due, milestone: a.milestone, tracked_in: a.tracked, checklist: D.checklists[a.id] || [], blocked_by: a.blockedBy, position: i }))));
out.push(add('milestones', D.milestones.map((m, i) => ({ project_id: P, name: m.name, date: m.date, owner_name: m.owner, status: m.date < D.today ? 'Done' : 'Planned', position: i }))));
out.push(add('library_items', D.library.map((x, i) => ({ id: x.id, kind: x.kind, text: x.text, owner: x.owner, source: x.source, status: x.status, used: x.used, confirmed_at: x.from, next_review: x.to, position: i }))));
const I = [['Channels', 'Slack', 'Questions, digests and nudges with action buttons', 1], ['Channels', 'Microsoft Teams', 'Questions, digests and nudges with action buttons', 1], ['Channels', 'Email', 'Questions, digests and nudges with action buttons', 1], ['Trackers', 'ServiceNow', 'Actions as change requests · read-only sync', 0], ['Trackers', 'Jira', 'Actions as issues', 0], ['Trackers', 'PagerDuty', 'On-call data for escalation rules', 1], ['AI targets', 'GitHub', 'Pull requests with generated files', 1], ['AI targets', 'Copilot Studio', 'Instruction pack export', 1], ['AI targets', 'Agentforce', 'Instruction pack export', 0], ['Documents', 'SharePoint', 'Documents for prefill', 1], ['Documents', 'Google Drive', 'Documents for prefill', 0], ['CRM', 'Salesforce', 'Customer segments · ask after a ticket closes', 1], ['CRM', 'HubSpot', 'Customer segments · ask after a ticket closes', 0], ['CRM', 'Zendesk', 'Customer segments · ask after a ticket closes', 0]];
out.push(add('integrations', I.map(([category, name, purpose, on], i) => ({ id: name.toLowerCase().replace(/\s+/g, '-'), name, category, purpose, connected: !!on, position: i }))));
out.push(add('external_segments', D.segments.map((s, i) => ({ project_id: P, segment: s.seg, channel: s.ch, invited: s.inv, answered: s.ans, status: s.st, position: i }))));
out.push(add('customer_themes', D.themes.map((t, i) => ({ project_id: P, theme: t.theme, segments: t.segs, n: t.n, quote: t.quote, feeds: t.feeds, status: t.st, position: i }))));
out.push(add('seed_artifacts', [['smartSkips', D.smartSkips], ['scenarios', D.scenarios], ['lint', D.lint], ['files', D.files]].map(([key, data]) => ({ project_id: P, key, data }))));

const body = out.filter(Boolean).join('\n');
const tables = ['project_state', 'seed_artifacts', 'customer_responses', 'customer_themes', 'external_segments', 'integrations', 'audit_events', 'settings', 'library_items', 'milestones', 'actions', 'spec_items', 'spec_versions', 'decisions', 'reviews', 'votes', 'comments', 'ideas', 'item_versions', 'input_items', 'adaptive_topics', 'answers', 'questions', 'sections', 'templates', 'project_members', 'projects', 'people', 'orgs'];
const sql = `-- GENERATED by scripts/gen-seed.mjs from design/design_handoff_orgcue/prototype/oc-data.js. Do not edit by hand.
-- Standalone alternative to 'node scripts/gen-seed.mjs --push': paste into the SQL editor. Redefines reset_demo() with the rows inline and runs it.
create or replace function public.reset_demo() returns void
language plpgsql security definer set search_path = public as $seed$
begin
truncate table ${tables.join(', ')} restart identity cascade;
${body}
end;
$seed$;
grant execute on function public.reset_demo() to anon, authenticated;
select public.reset_demo();
`;
writeFileSync(path.join(root, 'supabase/seed.sql'), sql);
console.log('wrote supabase/seed.sql', sql.length, 'bytes');

if (process.argv.includes('--push')) {
  const env = Object.fromEntries(readFileSync(path.join(root, '.env.local'), 'utf8').split('\n').filter((l) => l.includes('=')).map((l) => [l.slice(0, l.indexOf('=')), l.slice(l.indexOf('=') + 1).trim()]));
  const url = env.NEXT_PUBLIC_SUPABASE_URL, key = env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  // With row-level security on (supabase/migrations/20261019164424_auth_rls_policies.sql), only signed-in users may write: use the test account when one is set.
  let bearer = key;
  if (env.ORGCUE_TEST_EMAIL && env.ORGCUE_TEST_PASSWORD) {
    const t = await (await fetch(url + '/auth/v1/token?grant_type=password', { method: 'POST', headers: { apikey: key, 'Content-Type': 'application/json' }, body: JSON.stringify({ email: env.ORGCUE_TEST_EMAIL, password: env.ORGCUE_TEST_PASSWORD }) })).json();
    if (!t.access_token) throw new Error('Test account log-in failed: ' + (t.msg || t.error_description || JSON.stringify(t)));
    bearer = t.access_token;
  }
  const h = { apikey: key, Authorization: 'Bearer ' + bearer, 'Content-Type': 'application/json' };
  const call = async (method, p, body) => { const r = await fetch(url + p, { method, headers: { ...h, Prefer: 'return=minimal' }, body: body && JSON.stringify(body) }); if (!r.ok) throw new Error(method + ' ' + p + ' ' + r.status + ' ' + (await r.text())); };
  await call('DELETE', '/rest/v1/demo_seed?pos=gte.0');
  await call('POST', '/rest/v1/demo_seed', T.filter(([, rows]) => rows.length).map(([tbl, rows], pos) => ({ pos, tbl, rows })));
  await call('POST', '/rest/v1/rpc/reset_demo', {});
  console.log('pushed', T.length, 'tables to demo_seed and ran reset_demo()');
}
