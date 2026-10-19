/* eslint-disable */
// Supabase data layer for the prototype.
//
// load()    reads every table and builds `D` in exactly the shape of the prototype's window.OCD (oc-data.js), then
//           hydrates the shared store (K.S) with the user-made state that lives in the database.
// persist() receives every K.set patch and writes the matching rows. Screens never talk to Supabase directly.
//
// Prototype posture (docs/ASSESSMENT.md): no auth, RLS off, public anon key.
import { createClient } from '@supabase/supabase-js';
import { SEED } from './demo-data';
import { K } from './kit';

const URL_ = process.env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
export const sb = URL_ && KEY ? createClient(URL_, KEY, { auth: { persistSession: false } }) : null;
export const P = 'it-helpdesk';
export const status = { online: false, error: '' };

let D = null;
export const getD = () => D;

const TABLES = ['people', 'projects', 'project_members', 'templates', 'questions', 'adaptive_topics', 'input_items', 'item_versions', 'ideas', 'comments', 'votes', 'reviews', 'decisions', 'spec_versions', 'spec_items', 'actions', 'milestones', 'library_items', 'settings', 'audit_events', 'integrations', 'external_segments', 'customer_themes', 'seed_artifacts', 'project_state', 'answers'];
const byPos = (a, b) => (a.position ?? 0) - (b.position ?? 0);
const clone = (x) => JSON.parse(JSON.stringify(x));
const ini = (n) => n.split(' ').map((x) => x[0]).join('');
const STORY_DAY = 'Nov 12';
const when = (iso) => { const d = iso ? new Date(iso) : new Date(); return STORY_DAY + ' · ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0'); };
const CONTRIBUTOR = 'sam';
const REQ_EXTRA = {
  'REQ-024': { text: 'WHEN a conversation starts THE AGENT SHALL say it is an AI assistant and how to reach a person.', refs: 'EU AI Act Art. 50', provenance: 'Added after the AI Act check' },
  'REQ-025': { text: 'WHEN a question is about billing THE AGENT SHALL hand it to a person.', refs: 'customer theme · 19', provenance: 'Drafted from customer evidence · in Review' },
};
const STATE_KEYS = ['t01', 'gateFix', 'lint', 'gen', 'loopSent', 'nudged', 'skip', 'kept', 'adapt'];

// ---------- load ----------
export async function load() {
  if (!sb) { D = clone(SEED); status.error = 'Supabase is not configured · showing the built-in demo data'; return {}; }
  const res = await Promise.all(TABLES.map((t) => sb.from(t).select('*')));
  const bad = res.find((r) => r.error);
  if (bad) { D = clone(SEED); status.error = 'Supabase unreachable · showing the built-in demo data (' + bad.error.message + ')'; return {}; }
  status.online = true;
  const R = Object.fromEntries(TABLES.map((t, i) => [t, res[i].data || []]));
  const mine = (rows) => rows.filter((r) => r.project_id === P);

  const people = {};
  R.people.forEach((p) => { people[p.id] = { id: p.id, name: p.name, first: p.name.split(' ')[0], title: p.title, orgRole: p.org_role, role: p.project_role, group: p.function_group, areas: p.authority_areas, channel: p.channel, ini: ini(p.name) }; });
  const seedOrder = SEED.projects.map((p) => p.id);
  const projects = R.projects.slice().sort((a, b) => { const ia = seedOrder.indexOf(a.id), ib = seedOrder.indexOf(b.id); if (ia >= 0 && ib >= 0) return ia - ib; if (ia >= 0) return -1; if (ib >= 0) return 1; return a.created_at < b.created_at ? -1 : 1; })
    .map((p) => ({ id: p.id, name: p.name, type: p.type, phase: p.id === P ? null : p.phase, owner: p.owner_name, answered: p.answered, conflicts: p.conflicts, actions: p.actions_count, next: p.next_step, target: p.target, color: p.color, start: p.start_date, end: p.end_date, template: p.template || undefined, deadline: p.deadline || undefined }));
  const art = Object.fromEntries(mine(R.seed_artifacts).map((a) => [a.key, a.data]));
  const versions = {};
  R.item_versions.slice().sort((a, b) => (a.version < b.version ? -1 : 1)).forEach((v) => { (versions[v.item_id] = versions[v.item_id] || []).push([v.version, v.text, v.note]); });
  const seedDec = Object.fromEntries(SEED.decisions.map((d) => [d.id, d]));
  const decisions = mine(R.decisions).sort(byPos).map((d) => { const o = { id: d.id, title: d.title }; const s = seedDec[d.id] || {};
    if (d.pinned) o.pins = d.pinned; if (Array.isArray(d.options) && d.options.length) o.opts = d.options; if ('chosen' in s && d.chosen != null) o.chosen = d.chosen;
    if (d.rationale) o.rationale = d.rationale; if (d.follow_up) o.follow = d.follow_up; if (d.note) o.note = d.note; if (d.warn) o.warn = d.warn; if (d.done) o.done = d.done; return o; });
  const spec = mine(R.spec_items).sort(byPos);
  const actionsRows = mine(R.actions).sort(byPos);
  const checklists = {}; actionsRows.forEach((a) => { if (Array.isArray(a.checklist) && a.checklist.length) checklists[a.id] = a.checklist; });
  const lib = R.library_items.slice().sort(byPos);
  const libPending = lib.some((x) => x.id === 'LIB-HC-015' && x.status === 'Change pending');

  D = {
    ...clone({ sectionLib: SEED.sectionLib, restricted: SEED.restricted, presets: SEED.presets, outputs: SEED.outputs, frameworks: SEED.frameworks, fwDefaults: SEED.fwDefaults, groups: SEED.groups }),
    people,
    members: mine(R.project_members).sort(byPos).map((m) => m.person_id),
    projects,
    templates: R.templates.slice().sort((a, b) => +a.id.replace(/\D/g, '') - +b.id.replace(/\D/g, '')).map((t) => ({ id: t.id, cat: t.category, name: t.name, type: t.type, fw: t.frameworks, output: t.output, status: t.status, owner: t.owner, used: t.used, desc: t.description, isNew: t.is_new, updated: t.updated })),
    questions: mine(R.questions).sort(byPos).map((q) => ({ id: q.id, section: q.section, group: q.target_group, q: q.text })),
    smartSkips: art.smartSkips || SEED.smartSkips,
    adaptive: mine(R.adaptive_topics).sort(byPos).map((x) => ({ id: x.id, topic: x.topic, state: x.state, ev: x.evidence, did: x.did, saved: x.saved })),
    items: mine(R.input_items).sort(byPos).map((x) => ({ id: x.id, v: x.version, section: x.section, type: x.type, strength: x.strength, group: x.group_name, by: x.author_id, text: x.text, orig: x.original, rel: x.relation, dec: x.decision_id, votes: x.votes_seed, comments: x.comments_seed })),
    versions,
    ideas: mine(R.ideas).filter((x) => !x.private).sort(byPos).map((x) => ({ id: x.id, text: x.text, outcome: x.outcome, section: x.section })),
    hcs: spec.filter((x) => x.kind === 'HC').map((h) => ({ id: h.id, text: h.text, owner: h.owner_id, review: h.review_date })),
    reqs: spec.filter((x) => x.kind === 'REQ' && !REQ_EXTRA[x.id]).map((r) => ({ id: r.id, text: r.text, refs: r.refs, prov: r.provenance })),
    decisions,
    actions: actionsRows.map((a) => ({ id: a.id, title: a.title, source: a.source, owner: a.owner_id, accept: a.acceptance, status: a.status, due: a.due, prio: a.priority, milestone: a.milestone, tracked: a.tracked_in, blockedBy: a.blocked_by })),
    checklists,
    milestones: mine(R.milestones).sort(byPos).map((m) => ({ name: m.name, date: m.date, owner: m.owner_name })),
    library: lib.map((x) => ({ id: x.id, kind: x.kind, text: x.text, owner: x.owner, source: x.source, status: x.id === 'LIB-HC-015' && libPending ? 'Confirmed' : x.status, used: x.used, from: x.confirmed_at, to: x.next_review })),
    segments: mine(R.external_segments).sort(byPos).map((s) => ({ seg: s.segment, ch: s.channel, inv: s.invited, ans: s.answered, st: s.status })),
    themes: mine(R.customer_themes).sort(byPos).map((t) => ({ theme: t.theme, segs: t.segments, n: t.n, quote: t.quote, feeds: t.feeds, st: t.status })),
    scenarios: art.scenarios || SEED.scenarios,
    lint: art.lint || SEED.lint,
    files: art.files || SEED.files,
    today: SEED.today,
  };

  // ---- store hydration (user-made state) ----
  const S = {};
  const pr = R.projects.find((p) => p.id === P); if (pr) S.phase = pr.phase;
  const ans = {}; mine(R.answers).filter((a) => a.person_id === CONTRIBUTOR).forEach((a) => { ans[a.question_id] = a.skipped ? false : { text: a.text, str: a.strength }; }); if (Object.keys(ans).length) S.ans = ans;
  const priv = mine(R.ideas).filter((x) => x.private && x.author_id === CONTRIBUTOR).sort(byPos); if (priv.length) S.myIdeas = priv.map((x) => x.text);
  if (R.votes.length) S.votes = Object.fromEntries(R.votes.map((v) => [v.item_id, true]));
  if (R.comments.length) { S.coms = {}; R.comments.slice().sort((a, b) => (a.created_at < b.created_at ? -1 : 1)).forEach((c) => { (S.coms[c.item_id] = S.coms[c.item_id] || []).push({ type: c.type, text: c.text }); }); }
  const appr = {}; mine(R.input_items).forEach((x) => { if (x.approval_status && x.approval_status !== 'Pending review') appr[x.id] = x.reject_reason ? { st: x.approval_status, reason: x.reject_reason } : { st: x.approval_status }; }); if (Object.keys(appr).length) S.appr = appr;
  if (R.reviews.length) S.agree = Object.fromEntries(R.reviews.map((r) => [r.item_id, r.verdict]));
  const d3 = R.decisions.find((d) => d.id === 'DEC-03'); if (d3 && d3.status === 'Decided') { S.dec03 = true; S.dec03r = d3.rationale; }
  const d7 = R.decisions.find((d) => d.id === 'DEC-07'); if (d7 && d7.status === 'Decided') S.dec07 = d7.chosen === 1 ? 'grace' : 'sam';
  const v14 = R.spec_versions.find((v) => v.project_id === P && v.version === 'v1.4.0'); if (v14 && v14.locked) S.locked = true;
  if (spec.some((x) => x.id === 'REQ-024')) S.req024 = true;
  if (spec.some((x) => x.id === 'REQ-025')) S.req025 = true;
  if (libPending) S.libPending = true;
  if (R.settings.length) S.saved = Object.fromEntries(R.settings.map((s) => [s.key, s.value]));
  if (R.audit_events.length) S.audit = R.audit_events.slice().sort((a, b) => b.id - a.id).map((e) => [when(e.at), e.who, e.what, e.object]);
  if (R.integrations.length) S.conn = Object.fromEntries(R.integrations.map((i) => [i.name, i.connected]));
  mine(R.project_state).forEach((s) => { S[s.key] = s.value; });
  return S;
}

// ---------- writes ----------
const who = () => (D && D.people[K.who()] ? D.people[K.who()].name : 'Someone');
const fail = (e) => { if (e) { console.error(e); K.toast('Couldn’t save · ' + (e.message || e)); } };
const run = (q) => q.then(({ error }) => fail(error), fail);
const upd = (t, v, match) => run(sb.from(t).update(v).match(match));
const ups = (t, v, onConflict) => run(sb.from(t).upsert(v, onConflict ? { onConflict } : undefined));
export const audit = (what, object) => {
  K.store.setState((s) => ({ audit: [[when(), who(), what, object || 'IT Helpdesk Agent v1']].concat(s.audit || []) }));
  if (sb && status.online) run(sb.from('audit_events').insert({ who: who(), what, object: object || 'IT Helpdesk Agent v1' }));
};
const changed = (v, o) => Object.keys(v || {}).filter((k) => JSON.stringify((v || {})[k]) !== JSON.stringify((o || {})[k]));
const state = (key, value) => ups('project_state', { project_id: P, key, value, updated_at: new Date().toISOString() }, 'project_id,key');
const today = () => '2026-11-12';
async function sha(text) { const b = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(text)); return 'sha256:' + Array.from(new Uint8Array(b)).map((x) => x.toString(16).padStart(2, '0')).join('').slice(0, 16); }

const W = {
  phase: (v, o) => { upd('projects', { phase: v }, { id: P }); audit(o === 'Frame' && v === 'Collect' ? 'Sent questions to 8 members' : o === 'Collect' && v === 'Review' ? 'Closed collection and revealed' : 'Moved the project to ' + v); },
  act: (v, o) => changed(v, o).forEach((id) => { const a = v[id], row = {}; if ('status' in a) row.status = a.status; if ('accept' in a) row.acceptance = a.accept; if ('reason' in a) row.decline_reason = a.reason || ''; upd('actions', row, { id });
    const was = (o || {})[id] || {}; if (a.accept && a.accept !== was.accept) audit(a.accept + ' ' + id, id); else if (a.status && a.status !== was.status) audit(id + ' → ' + a.status, id); }),
  cl: (v, o) => changed(v, o).forEach((id) => upd('actions', { checklist: v[id] }, { id })),
  // S.ans and S.myIdeas are the demo contributor's (Sam's) answers and private ideas, whatever the View as role.
  ans: (v, o) => changed(v, o).forEach((qid) => { const a = v[qid]; if (a === undefined) return run(sb.from('answers').delete().match({ project_id: P, question_id: qid, person_id: CONTRIBUTOR }));
    ups('answers', { project_id: P, question_id: qid, person_id: CONTRIBUTOR, text: a ? a.text || '' : '', strength: a ? a.str || 'Must-have' : 'Must-have', skipped: a === false }, 'project_id,question_id,person_id'); }),
  myIdeas: async (v) => { const me = CONTRIBUTOR; // My input and the phone flow are Sam's (the demo contributor) await sb.from('ideas').delete().match({ project_id: P, author_id: me, private: true });
    if (v && v.length) run(sb.from('ideas').insert(v.map((text, i) => ({ id: 'P-' + me + '-' + (i + 1), project_id: P, text, author_id: me, private: true, position: i })))); },
  votes: (v, o) => changed(v, o).forEach((id) => (v[id] ? ups('votes', { item_id: id, person_id: K.who() }, 'item_id,person_id') : run(sb.from('votes').delete().eq('item_id', id)))),
  coms: (v, o) => Object.keys(v || {}).forEach((id) => { const add = (v[id] || []).slice(((o || {})[id] || []).length); if (add.length) { run(sb.from('comments').insert(add.map((c) => ({ project_id: P, item_id: id, type: c.type || 'Clarification', text: c.text, author_id: K.who() })))); audit('Commented on ' + id, id); } }),
  appr: (v, o) => changed(v, o).forEach((id) => { const a = v[id] || { st: 'Pending review' }; upd('input_items', { approval_status: a.st, reject_reason: a.reason || '' }, { id }); audit((a.st === 'Rejected' ? 'Rejected ' + id + ' · ' + a.reason : a.st + ' ' + id), id); }),
  agree: (v, o) => changed(v, o).forEach((id) => { ups('reviews', { item_id: id, person_id: K.who(), verdict: v[id] }, 'item_id,person_id'); audit((v[id] === 'object' ? 'Objected to ' : 'Agreed with ') + id, id); }),
  dec03: (v) => { if (!v) return upd('decisions', { status: 'Open', decided_by: '', decided_at: null }, { id: 'DEC-03' });
    upd('decisions', { status: 'Decided', chosen: 1, rationale: K.S.dec03r || '', decided_by: who(), decided_at: new Date().toISOString() }, { id: 'DEC-03' }); audit('Recorded DEC-03 · MFA push before any change', 'DEC-03'); },
  dec03r: (v) => { if (K.S.dec03) upd('decisions', { rationale: v || '' }, { id: 'DEC-03' }); },
  dec07: (v) => { upd('decisions', { status: v ? 'Decided' : 'Open', chosen: v === 'grace' ? 1 : v === 'sam' ? 0 : null, decided_by: v ? who() : '', decided_at: v ? new Date().toISOString() : null }, { id: 'DEC-07' }); if (v) audit('Recorded DEC-07 · ' + (v === 'sam' ? 'Sam’s wording' : 'Grace’s wording'), 'DEC-07'); },
  locked: async (v) => { if (!v) return upd('spec_versions', { locked: false, locked_by: '', locked_at: null, hash: '' }, { id: P + '-v1.4.0' });
    const hash = await sha(JSON.stringify([D.hcs, D.reqs, K.S.dec03r, K.S.dec07]));
    upd('spec_versions', { locked: true, locked_by: who(), locked_at: new Date().toISOString(), hash }, { id: P + '-v1.4.0' }); audit('Locked Spec v1.4.0 · ' + hash, 'Spec v1.4.0'); },
  req024: (v) => reqToggle('REQ-024', v),
  req025: (v) => reqToggle('REQ-025', v),
  libPending: (v) => { upd('library_items', v ? { status: 'Change pending', proposed_text: 'MUST NOT order hardware above $400 without manager approval.' } : { status: 'Confirmed', proposed_text: '' }, { id: 'LIB-HC-015' }); audit(v ? 'Proposed a change to LIB-HC-015 · $250 → $400' : 'Withdrew the change to LIB-HC-015', 'LIB-HC-015'); },
  libAsked: (v, o) => changed(v, o).forEach((id) => { if (v[id]) audit('Asked whether ' + id + ' is still true', id); }),
  saved: (v, o) => { const keys = changed(v, o); if (keys.length) ups('settings', keys.map((key) => ({ org_id: 'lumio', key, value: v[key], updated_at: new Date().toISOString() })), 'org_id,key'); },
  audit: (v, o) => { const n = (v || []).length - (o || []).length; if (n > 0) run(sb.from('audit_events').insert(v.slice(0, n).reverse().map(([, w, what, object]) => ({ who: w, what, object })))); },
  conn: (v, o) => changed(v, o).forEach((name) => { upd('integrations', { connected: !!v[name] }, { name }); audit((v[name] ? 'Connected ' : 'Disconnected ') + name, 'Integrations'); }),
  promoted: (v, o) => changed(v, o).forEach((id) => { upd('ideas', { outcome: v[id] }, { id }); audit(id + ' · ' + v[id], id); }),
};
STATE_KEYS.forEach((k) => { W[k] = (v, o) => { state(k, v);
  if (k === 'gen' && v) audit('Approved the diff and generated · Pull request #42', 'Spec v1.4.0');
  if (k === 'loopSent' && v) audit('Sent the close-the-loop note to 8 members');
  if (k === 'gateFix' && v) audit('Fixed gate · HC-019 mapped to a check', 'HC-019');
  if (k === 'nudged') changed(v, o).forEach((id) => audit('Nudged ' + ((D.people[id] || {}).name || id), 'Members'));
  if (k === 'lint') { const n = changed(v, o); if (n.length) audit('Instruction check · fixed ' + n.join(', '), 'Spec v1.4.1 draft'); }
  if (k === 't01' && v) audit('T-01 suggestion · ' + v, 'T-01'); }; });

function reqToggle(id, on) {
  if (!on) return run(sb.from('spec_items').delete().eq('id', id));
  const r = REQ_EXTRA[id]; ups('spec_items', { id, project_id: P, kind: 'REQ', text: r.text, refs: r.refs, provenance: r.provenance, position: 20 + +id.slice(-2) }, 'id');
  audit('Drafted ' + id, id);
}

export function persist(prev, patch) {
  if (!sb || !status.online || !D) return;
  Object.keys(patch || {}).forEach((k) => { if (W[k] && JSON.stringify(patch[k]) !== JSON.stringify(prev[k])) { try { const p = W[k](patch[k], prev[k]); if (p && p.catch) p.catch(fail); } catch (e) { fail(e); } } });
}

// ---------- explicit operations ----------
export async function createProject(p, f, secs, questions) {
  D.projects.push(p);
  if (!sb || !status.online) return;
  const owner = Object.values(D.people).find((x) => x.name === p.owner), decider = Object.values(D.people).find((x) => x.name === f.decider);
  const { error } = await sb.from('projects').insert({ id: p.id, name: p.name, type: p.type, phase: 'Frame', owner_id: owner ? owner.id : null, owner_name: p.owner, decider_id: decider ? decider.id : null, template: p.template, target: p.target, deadline: p.deadline, start_date: p.start, end_date: p.end, color: p.color, answered: p.answered, conflicts: 0, actions_count: 0, next_step: p.next, goal: f.goal || '', frameworks: f.fw, groups: f.groups, external: f.ext ? { segments: f.segs, channels: f.chans } : null });
  if (error) return fail(error);
  await Promise.all([
    sb.from('sections').insert(secs.map((name, i) => ({ project_id: p.id, name, hint: D.sectionLib[name] || 'Custom section', authority: !!f.auth[name], restricted: D.restricted.includes(name), position: i }))),
    sb.from('questions').insert(questions.map((q, i) => ({ id: 'Q' + (i + 1), project_id: p.id, section: q.section, target_group: q.g, text: q.q, position: i }))),
    sb.from('project_members').insert([owner && { project_id: p.id, person_id: owner.id, project_role: 'Owner', status: 'Not sent', position: 0 }, decider && decider !== owner && { project_id: p.id, person_id: decider.id, project_role: 'Decider', status: 'Not sent', position: 1 }].filter(Boolean)),
  ]).then((rs) => rs.forEach((r) => fail(r.error)));
  audit('Created project · ' + secs.length + ' sections, ' + questions.length + ' questions', p.name);
}

export async function saveCustomerResponse(answers) {
  if (sb && status.online) run(sb.from('customer_responses').insert({ project_id: P, answers }));
}

export async function exportEvidence(kind) {
  const pack = { generated_at: new Date().toISOString(), project: P, spec_version: 'v1.4.0', format: 'Orgcue evidence pack (prototype)', store: { dec03: K.S.dec03, dec07: K.S.dec07, locked: K.S.locked, gen: K.S.gen } };
  if (sb && status.online) {
    const t = ['projects', 'project_members', 'sections', 'questions', 'answers', 'input_items', 'item_versions', 'ideas', 'comments', 'votes', 'reviews', 'decisions', 'spec_versions', 'spec_items', 'actions', 'milestones', 'customer_themes', 'project_state'];
    const res = await Promise.all(t.map((x) => (x === 'projects' ? sb.from(x).select('*').eq('id', P) : ['item_versions', 'votes', 'reviews'].includes(x) ? sb.from(x).select('*') : sb.from(x).select('*').eq('project_id', P))));
    t.forEach((x, i) => { pack[x] = res[i].data || []; });
    pack.audit_events = (await sb.from('audit_events').select('*').order('id')).data || [];
  } else Object.assign(pack, { items: D.items, decisions: D.decisions, hcs: D.hcs, reqs: D.reqs, actions: D.actions });
  const a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([JSON.stringify(pack, null, 2)], { type: 'application/json' })); a.download = 'evidence-pack-' + P + '-v1.4.0.json'; a.click();
  K.toast('Evidence pack v1.4.0 · JSON downloaded' + (kind === 'PDF' ? ' · PDF is simulated in this prototype' : ''));
  audit('Exported the evidence pack', 'Spec v1.4.0');
}

export async function resetDemo() {
  if (!sb) return;
  const { error } = await sb.rpc('reset_demo');
  if (error) return fail(error);
  try { Object.keys(localStorage).filter((k) => k.startsWith('orgcue-view-')).forEach((k) => localStorage.removeItem(k)); } catch (e) {}
  window.location.href = '/home';
}
