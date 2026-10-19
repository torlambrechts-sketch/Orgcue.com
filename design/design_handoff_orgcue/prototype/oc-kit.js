// Orgcue prototype runtime: shared store, status colours, block builders.
(function () {
  const K = window.OCK = {};
  const LS = (k, d) => { try { const v = localStorage.getItem(k); return v == null ? d : JSON.parse(v); } catch (e) { return d; } };
  K.S = { role: 'owner', phase: 'Decide', all: true, navC: LS('orgcue-navC', false), toast: null, wiz: null };
  K.set = (p) => { Object.assign(K.S, typeof p === 'function' ? p(K.S) : p); window.dispatchEvent(new Event('oc')); };
  K.sub = (c) => { const f = () => c.forceUpdate(); window.addEventListener('oc', f); return () => window.removeEventListener('oc', f); };
  K.toast = (m) => { clearTimeout(K._t); K.set({ toast: m }); K._t = setTimeout(() => K.set({ toast: null }), 2600); };
  K.go = (p) => { if (location.hash !== '#' + p) location.hash = p; };
  K.nav = (p) => (e) => { if (e && e.preventDefault) e.preventDefault(); K.go(p); };
  K.PH = ['Frame', 'Collect', 'Review', 'Decide', 'Validate', 'Live'];
  K.pi = (ph) => K.PH.indexOf(ph || K.S.phase);
  K.at = (ph) => K.pi() >= K.pi(ph);
  K.esc = (fn) => (e) => { if (e && e.stopPropagation) e.stopPropagation(); fn(e); };
  // status colours mapped onto Orgpuls tokens (full-colour cells always carry text)
  const G = ['var(--op-link)', 'var(--op-sf)'], Y = ['var(--op-ac)', 'var(--op-ink)'], R = ['var(--op-dangerdeep)', 'var(--op-sf)'], N = ['var(--op-track)', 'var(--op-ink)'], P = ['var(--op-viz5)', 'var(--op-ink)'], B = ['var(--op-mint)', 'var(--op-greendeep)'], T = ['var(--op-sage)', 'var(--op-ink)'], I = ['var(--op-ink)', 'var(--op-bg)'];
  const M = { done: G, pass: G, published: G, confirmed: G, covered: G, sent: G, connected: G, approved: G, used: G, live: G, supports: G, accepted: G, fixed: G, adopted: G, closed: G, finished: G, answered: G, locked: G, 'still true': G, current: G, merged: G,
    'working on it': Y, 'in progress': Y, collecting: Y, collect: Y, partial: Y, fresh: Y, 'in review': Y, medium: Y, thin: Y, opened: Y, 'check due': Y, unclear: Y, new: Y, started: Y, normal: Y, 'changed by': Y,
    blocked: R, overdue: R, fail: R, conflict: R, gap: R, high: R, rejected: R, 'change pending': R, missing: R, declined: R, 'not used': N,
    'owner pending': P, decide: P, requested: P, 'sent to a decision': P, deferred: P, decision: P,
    review: B, 'pending review': B, validate: T, low: N, frame: N, sample: N, planned: N, 'n/a': N, parked: N };
  K.stc = (l) => { const k = String(l || '').toLowerCase(); if (M[k]) return M[k]; const f = Object.keys(M).sort((a, b) => b.length - a.length).find((x) => k.startsWith(x)); return f ? M[f] : N; };
  K.cellSt = (l) => { const [bg, fg] = K.stc(l); return { display: 'flex', alignItems: 'center', justifyContent: 'center', alignSelf: 'stretch', minHeight: 40, width: '100%', border: 'none', cursor: 'pointer', fontFamily: 'inherit', background: bg, color: fg, fontSize: 12.5, fontWeight: 700, padding: '0 8px', textAlign: 'center', boxSizing: 'border-box' }; };
  K.pill = (l) => { const [bg, fg] = K.stc(l); return { flex: 'none', display: 'inline-flex', alignItems: 'center', gap: 5, borderRadius: 999, background: bg, color: fg, padding: '2px 9px', fontSize: 11.5, fontWeight: 700, whiteSpace: 'nowrap' }; };
  const TONE = { mut: ['var(--op-track)', 'var(--op-mut)'], ink: I, dec: P, con: ['var(--op-peach)', 'var(--op-dangerdeep)', 'var(--op-rustbar)'], warn: ['var(--op-band)', 'var(--op-cautiondeep)'], ok: B, acc: ['var(--op-sbg)', 'var(--op-ink)', 'var(--op-ink)'], idea: ['var(--op-ac)', 'var(--op-ink)'], line: ['var(--op-sf)', 'var(--op-ink)', 'var(--op-rule)'] };
  K.tone = (t) => { const c = TONE[t] || TONE.mut; return { flex: 'none', display: 'inline-flex', alignItems: 'center', gap: 5, borderRadius: 999, background: c[0], color: c[1], border: c[2] ? '1px solid ' + c[2] : 'none', padding: '2px 9px', fontSize: 11.5, fontWeight: 700, whiteSpace: 'nowrap' }; };
  K.chip = (t, tone) => ({ t, st: tone ? K.tone(tone) : K.pill(t) });
  K.idc = (t) => ({ t, st: { flex: 'none', borderRadius: 6, border: '1px solid var(--op-ink)', background: 'var(--op-sf)', padding: '1px 6px', fontSize: 11.5, fontWeight: 700, fontFamily: 'ui-monospace, Menlo, monospace', whiteSpace: 'nowrap' } });
  K.b = (t, on, tone, dis) => (Array.isArray(t) ? K.b(...t) : { t, on: on || (() => K.toast(t)), tone: tone || 'secondary', dis: !!dis });
  K.bs = (l) => (l || []).filter(Boolean).map((x) => (x.t != null && x.on ? { tone: 'secondary', dis: false, ...x } : K.b(x)));
  K.choice = (sel) => ({ minHeight: 34, cursor: 'pointer', borderRadius: 999, padding: '6px 12px', fontFamily: 'inherit', fontSize: 13, fontWeight: sel ? 700 : 500, border: '1px solid ' + (sel ? 'var(--op-ink)' : 'var(--op-rule)'), background: sel ? 'var(--op-sbg)' : 'var(--op-sf)', color: 'var(--op-ink)', whiteSpace: 'nowrap' });
  K.ini = (n) => String(n || '?').split(/\s+/).map((x) => x[0]).slice(0, 2).join('').toUpperCase();
  // cells
  const CK = ['text', 'status', 'avatar', 'btn', 'chip', 'check', 'bar', 'chips'];
  K.cell = (x) => {
    if (x == null || typeof x !== 'object') x = { k: 'text', t: x == null ? '' : String(x) };
    const k = x.k || 'text', o = {}; CK.forEach((n) => { o['is_' + n] = n === k; });
    o.t = x.t == null ? '' : String(x.t); o.sub = x.sub || ''; o.hasSub = !!x.sub;
    if (k === 'text') o.st = { minWidth: 0, fontSize: 13.5, fontWeight: x.b ? 700 : 400, fontFamily: x.mono ? 'ui-monospace, Menlo, monospace' : 'inherit', color: x.warn ? 'var(--op-dangerdeep)' : x.mut ? 'var(--op-mut)' : 'var(--op-ink)', textDecoration: x.strike ? 'line-through' : 'none', fontVariantNumeric: 'tabular-nums' };
    if (k === 'status') { o.st = K.cellSt(x.t); o.on = x.on || (() => {}); }
    if (k === 'avatar') o.ini = x.ini || K.ini(x.t);
    if (k === 'btn') { o.on = x.on || (() => K.toast(x.t)); o.tone = x.tone || 'secondary'; o.dis = !!x.dis; }
    if (k === 'chip') o.st = x.st || (x.c ? K.tone(x.c) : K.pill(x.t));
    if (k === 'chips') o.list = x.list;
    if (k === 'check') { o.on = !!x.on; o.ch = x.ch; o.label = x.label || 'Select'; }
    if (k === 'bar') o.fill = { display: 'block', height: '100%', width: Math.max(0, Math.min(100, x.pct || 0)) + '%', background: x.color || 'var(--op-link)', borderRadius: 999 };
    o.wst = { display: 'flex', alignItems: 'center', minWidth: 0, padding: k === 'status' ? 0 : '6px 10px', borderLeft: '1px solid var(--op-line)', boxSizing: 'border-box' };
    return o;
  };
  // panel items
  const IK = ['t', 'p', 'q', 'pills', 'btns', 'kv', 'field', 'chips', 'row', 'bar', 'sep', 'toggle', 'diff', 'cards', 'check', 'grid'];
  K.item = (x) => {
    const o = { ...x }; IK.forEach((n) => { o['is_' + n] = n === x.k; });
    o.hasSub = !!x.sub; o.sub = x.sub || ''; o.hasHelp = !!x.help; o.help = x.help || ''; o.hasLabel = !!x.label; o.label = x.label || '';
    if (x.k === 't') o.st = { fontFamily: 'var(--font-display)', fontSize: x.size || 17, lineHeight: 1.25, fontWeight: 600, color: x.color || 'var(--op-ink)', textWrap: 'balance' };
    if (x.k === 'p') o.st = { margin: 0, fontSize: x.small ? 12.5 : 14, lineHeight: 1.55, color: x.warn ? 'var(--op-dangerdeep)' : x.ok ? 'var(--op-greendeep)' : x.mut ? 'var(--op-mut)' : 'var(--op-body)', fontWeight: x.b ? 700 : 400, fontStyle: x.i ? 'italic' : 'normal', textWrap: 'pretty' };
    if (x.k === 'q') o.hasBy = !!x.by;
    if (x.k === 'btns') o.list = K.bs(x.list);
    if (x.k === 'kv') o.v = K.cell(x.v);
    if (x.k === 'field') { o.isIn = !x.kind || x.kind === 'input' || x.kind === 'date'; o.isTa = x.kind === 'ta'; o.isSel = x.kind === 'select'; o.type = x.kind === 'date' ? 'date' : 'text'; o.opts = (x.opts || []).map((v) => (typeof v === 'string' ? { value: v, label: v } : v)); o.ph = x.ph || ''; o.value = x.value == null ? '' : x.value; o.fst = { width: '100%' }; }
    if (x.k === 'chips') o.list = (x.list || []).map((c) => ({ t: c.t, on: c.on, sel: !!c.sel, st: K.choice(c.sel) }));
    if (x.k === 'row') { o.chips = x.chips || []; o.btns = K.bs(x.btns); o.on = x.on; o.hasStripe = !!x.stripe; o.stripe = { width: 6, alignSelf: 'stretch', minHeight: 30, flex: 'none', borderRadius: 999, background: x.stripe };
      o.st = { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '8px 12px', border: '1px solid ' + (x.sel ? 'var(--op-ink)' : x.dashed ? 'var(--op-amberbar)' : 'var(--op-line)'), borderStyle: x.dashed ? 'dashed' : 'solid', borderRadius: 13, background: x.sel ? 'var(--op-sbg)' : x.fill || 'var(--op-sf)', padding: '10px 12px', cursor: x.on ? 'pointer' : 'default' };
      o.titleSt = { fontSize: 13.5, fontWeight: 600, lineHeight: 1.4, textDecoration: x.strike ? 'line-through' : 'none', color: x.strike ? 'var(--op-mut)' : 'var(--op-ink)' }; }
    if (x.k === 'bar') { o.fill = { display: 'block', height: '100%', width: Math.max(0, Math.min(100, x.pct || 0)) + '%', background: x.color || 'var(--op-link)', borderRadius: 999 }; o.value = x.value == null ? '' : String(x.value); }
    if (x.k === 'toggle') o.on = !!x.on;
    if (x.k === 'diff') o.parts = (x.parts || []).map(([t, kind]) => ({ t, st: kind === '-' ? { textDecoration: 'line-through', color: 'var(--op-dangerdeep)', background: 'var(--op-peach)', borderRadius: 4, padding: '0 3px' } : kind === '+' ? { background: 'var(--op-mint)', color: 'var(--op-greendeep)', borderRadius: 4, padding: '0 3px' } : {} }));
    if (x.k === 'cards') { o.gst = { display: 'grid', gap: 10, gridTemplateColumns: 'repeat(auto-fill, minmax(' + (x.min || 200) + 'px, 1fr))' };
      o.list = (x.list || []).map((c) => ({ ...c, tags: c.tags || [], hasSub: !!c.sub, hasFoot: !!c.foot, hasBtns: !!(c.btns && c.btns.length), btns: K.bs(c.btns), st: { display: 'flex', flexDirection: 'column', alignItems: 'flex-start', gap: 6, textAlign: 'left', fontFamily: 'inherit', color: 'var(--op-ink)', cursor: c.on ? 'pointer' : 'default', borderRadius: 16, padding: 14, border: (c.sel ? '2px solid var(--op-ink)' : '1px solid var(--op-line)'), background: c.sel ? 'var(--op-sbg)' : c.fill || 'var(--op-sf)', boxSizing: 'border-box', minWidth: 0 } })); }
    if (x.k === 'check') o.on = !!x.on;
    if (x.k === 'grid') { o.gst = { display: 'grid', gridTemplateColumns: x.cols, gap: '6px 12px', alignItems: 'center', fontSize: 13 }; o.cells = (x.cells || []).map(K.cell); }
    return o;
  };
  K.i = {
    t: (text, o) => ({ k: 't', text, ...o }), p: (text, o) => ({ k: 'p', text, ...o }), q: (text, by) => ({ k: 'q', text, by }),
    pills: (list) => ({ k: 'pills', list }), btns: (list) => ({ k: 'btns', list }), kv: (label, v) => ({ k: 'kv', label, v }),
    field: (o) => ({ k: 'field', ...o }), chips: (list, label) => ({ k: 'chips', list, label }), row: (o) => ({ k: 'row', ...o }),
    bar: (label, pct, value, color, sub) => ({ k: 'bar', label, pct, value, color, sub }), sep: () => ({ k: 'sep' }),
    toggle: (label, on, ch, help) => ({ k: 'toggle', label, on, ch, help }), diff: (parts) => ({ k: 'diff', parts }),
    cards: (list, min) => ({ k: 'cards', list, min }), check: (label, on, ch, help) => ({ k: 'check', label, on, ch, help }), grid: (cols, cells) => ({ k: 'grid', cols, cells }),
  };
  // blocks
  const BK = ['toolbar', 'head', 'panel', 'table', 'board', 'timeline', 'lines', 'flow', 'notes', 'kpis', 'stepper', 'banner', 'tabs'];
  K.W = (w) => (w == null || w === 'full' ? '1 1 100%' : typeof w === 'number' ? '1 1 ' + w + 'px' : w);
  K.mk = (kind, o) => { const b = { ...o, kind }; BK.forEach((k) => { b['is_' + k] = k === kind; }); b.wrap = { flex: K.W(o.w), minWidth: 0, position: o.sticky ? 'sticky' : 'relative', top: o.sticky ? 12 : 'auto', alignSelf: 'flex-start', zIndex: o.sticky ? 2 : 'auto' }; return b; };
  K.head = (o) => K.mk('head', { ...o, hasEyebrow: !!o.eyebrow, hasSub: !!o.sub, actions: K.bs(o.actions), seg: (o.seg || []).map((s) => ({ t: s.t, on: s.on, st: { cursor: 'pointer', border: 'none', borderRadius: 9, padding: '7px 13px', fontFamily: 'inherit', fontSize: 13, fontWeight: s.sel ? 700 : 500, background: s.sel ? 'var(--op-ink)' : 'transparent', color: s.sel ? 'var(--op-bg)' : 'var(--op-ink)' } })), hasSeg: !!(o.seg && o.seg.length) });
  K.panel = (o, items) => K.mk('panel', { title: '', note: '', ...o, hasHead: !!(o.title || (o.actions && o.actions.length) || o.chip), hasTitle: !!o.title, hasNote: !!o.note, hasChip: !!o.chip, chipSt: o.chipSt || K.tone(o.chipTone || 'mut'), actions: K.bs(o.actions), items: (items || []).filter(Boolean).map(K.item),
    st: o.plain ? { display: 'flex', flexDirection: 'column', gap: 10 } : { display: 'flex', flexDirection: 'column', gap: 10, border: (o.dashed ? '1px dashed var(--op-amberbar)' : o.strong ? '1.5px solid var(--op-ink)' : '1px solid var(--op-line)'), borderRadius: 18, background: o.fill || 'var(--op-sf)', padding: '18px 20px', boxSizing: 'border-box' } });
  K.banner = (text, tone, actions, w) => { const c = { warn: ['var(--op-sbg)', 'var(--op-amberbar)', 'var(--op-ink)'], con: ['var(--op-peach)', 'var(--op-rustbar)', 'var(--op-ink)'], ok: ['var(--op-mint)', 'transparent', 'var(--op-greendeep)'], info: ['var(--op-track)', 'transparent', 'var(--op-ink)'], dec: ['var(--op-viz5)', 'transparent', 'var(--op-ink)'] }[tone || 'info'];
    return K.mk('banner', { text, w, actions: K.bs(actions), st: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '8px 14px', borderRadius: 15, padding: '12px 16px', background: c[0], border: '1px solid ' + c[1], color: c[2], fontSize: 13.5, lineHeight: 1.5 } }); };
  K.kpis = (tiles, w) => K.mk('kpis', { w, tiles: tiles.map((t) => ({ ...t, note: t.note || '', nst: { fontSize: 12.5, fontWeight: t.warn ? 700 : 400, color: t.warn ? 'var(--op-dangerdeep)' : t.good ? 'var(--op-greendeep)' : 'var(--op-mut)' } })) });
  K.tabs = (list, w) => K.mk('tabs', { w, list: list.map((t) => ({ ...t, st: { cursor: 'pointer', border: 'none', borderBottom: '2px solid ' + (t.sel ? 'var(--op-ink)' : 'transparent'), background: 'transparent', padding: '10px 2px', fontFamily: 'inherit', fontSize: 14, fontWeight: t.sel ? 700 : 500, color: t.sel ? 'var(--op-ink)' : 'var(--op-mut)', whiteSpace: 'nowrap' } })) });
  K.stepper = (steps, w) => K.mk('stepper', { w, steps: steps.map((s, i) => { const done = s.state === 'done', now = s.state === 'now';
    return { ...s, sub: s.sub || (done ? 'Done' : now ? 'Now' : ''), glyph: done ? '✓' : String(i + 1), on: s.on || (() => {}),
      dot: { display: 'flex', width: 28, height: 28, flex: 'none', alignItems: 'center', justifyContent: 'center', borderRadius: 999, boxSizing: 'border-box', fontSize: 12, fontWeight: 700, background: done ? 'var(--op-link)' : now ? 'var(--op-ac)' : 'var(--op-sf)', color: done ? 'var(--op-sf)' : now ? 'var(--op-ink)' : 'var(--op-mut)', border: done ? 'none' : now ? '2px solid var(--op-ink)' : '1.5px solid var(--op-rule)' },
      line: { flex: 1, height: 2, minWidth: 12, background: done ? 'var(--op-link)' : 'var(--op-line)', display: i === steps.length - 1 ? 'none' : 'block' },
      lst: { fontSize: 12.5, fontWeight: now ? 700 : 600, color: done || now ? 'var(--op-ink)' : 'var(--op-mut)', whiteSpace: 'nowrap' } }; }) });
  K.table = (o) => { const grid = o.grid; const groups = o.groups || [{ rows: o.rows, color: o.color || 'var(--op-ink)' }];
    return K.mk('table', { ...o, hasTitle: !!o.title, title: o.title || '', note: o.note || '', actions: K.bs(o.actions), minW: { minWidth: o.minW || 720 },
      groups: groups.map((g) => { const rows = (g.rows || []); const dist = g.dist || [];
        return { title: g.title || '', hasHead: !!g.title, titleSt: { fontSize: 17, fontWeight: 600, color: g.color || 'var(--op-ink)', whiteSpace: 'nowrap' }, count: rows.length + ' ' + (o.noun || 'items'),
          cols: o.cols, headSt: { display: 'grid', gridTemplateColumns: '6px ' + grid, gap: 0, alignItems: 'stretch', borderBottom: '1px solid var(--op-line)', fontSize: 13, color: 'var(--op-mut)' },
          bar: { background: g.color || 'var(--op-ink)', borderTopLeftRadius: 8 }, hasAdd: !!o.add, add: o.add ? '＋ Add ' + o.add : '', onAdd: g.onAdd || (() => K.toast('New ' + o.add + ' added')),
          hasDist: dist.length > 0, dist: dist.map((d) => ({ st: { display: 'block', height: '100%', width: d.pct + '%', background: K.stc(d.l)[0] }, l: d.l })),
          addBar: { width: 6, alignSelf: 'stretch', background: g.color || 'var(--op-ink)', opacity: 0.5, borderBottomLeftRadius: 8 },
          empty: rows.length ? '' : (o.empty || 'Nothing here yet.'), hasEmpty: !rows.length,
          rows: rows.map((r) => { const cells = (r.cells || r).map(K.cell); return { cells, on: r.on || undefined, bar: { background: g.color || 'var(--op-ink)' }, st: { display: 'grid', gridTemplateColumns: '6px ' + grid, alignItems: 'stretch', minHeight: 42, borderBottom: '1px solid var(--op-line)', background: r.sel ? 'var(--op-sbg)' : r.warn ? 'var(--op-sbg)' : 'var(--op-sf)', cursor: r.on ? 'pointer' : 'default' } }; }) }; }) }); };
  K.cellWrap = (last) => ({ display: 'flex', alignItems: 'center', minWidth: 0, padding: '6px 10px', borderLeft: '1px solid var(--op-line)', boxSizing: 'border-box' });
  K.board = (o) => K.mk('board', { ...o, gst: { display: 'grid', gridAutoFlow: 'column', gridAutoColumns: 'minmax(260px, 1fr)', gap: 14, overflowX: 'auto', paddingBottom: 6 },
    cols: o.cols.map((c) => ({ ...c, count: c.cards.length, dot: { width: 10, height: 10, borderRadius: 999, background: c.color || 'var(--op-ink)', flex: 'none' },
      cards: c.cards.map((k) => ({ tag: '', id: '', desc: '', person: '', role: '', warn: '', left: '', right: '', ...k, tagSt: k.tagSt || K.tone('mut'), hasDesc: !!k.desc, hasWarn: !!k.warn, hasPerson: !!k.person, ini: K.ini(k.person), on: k.on || (() => {}) })) })) });
  K.date = (s) => new Date(s + 'T12:00:00');
  K.timeline = (o) => { const a = K.date(o.start), z = K.date(o.end), span = z - a; const x = (d) => Math.max(0, Math.min(100, (K.date(d) - a) / span * 100));
    const months = []; const m = new Date(a); m.setDate(1); while (m <= z) { const iso = m.toISOString().slice(0, 10); months.push({ l: m.toLocaleDateString('en-US', { month: 'short' }) + (m.getMonth() === 0 ? ' ' + m.getFullYear() : ''), st: { position: 'absolute', left: x(iso) + '%', top: 0, bottom: 0, borderLeft: '1px solid var(--op-line)', paddingLeft: 6, fontSize: 11.5, fontWeight: 700, color: 'var(--op-mut)', whiteSpace: 'nowrap' } }); m.setMonth(m.getMonth() + 1); }
    const today = { position: 'absolute', top: 0, bottom: 0, left: x(o.today || '2026-11-12') + '%', width: 2, background: 'var(--op-dangerdeep)', zIndex: 3 };
    return K.mk('timeline', { ...o, foot: o.foot || '', months, today, rows: o.rows.map((r) => ({ label: r.label, sub: r.sub || '', on: r.on || (() => {}), dot: { width: 10, height: 10, borderRadius: 999, flex: 'none', background: r.color || 'var(--op-ink)' },
      marks: [].concat(r.from ? [{ l: r.barLabel || '', tip: r.tip || r.label, st: { position: 'absolute', top: 11, height: 22, left: x(r.from) + '%', width: 'max(' + (x(r.to) - x(r.from)) + '%, 8px)', borderRadius: 999, background: K.stc(r.status)[0], color: K.stc(r.status)[1], fontSize: 11, fontWeight: 700, display: 'flex', alignItems: 'center', padding: '0 8px', boxSizing: 'border-box', whiteSpace: 'nowrap', overflow: 'hidden' } }] : [],
        (r.dots || []).map((d) => ({ l: '', tip: d.tip, st: { position: 'absolute', top: 15, left: 'calc(' + x(d.date) + '% - 7px)', width: 14, height: 14, borderRadius: 999, background: K.stc(d.status)[0], border: '2px solid var(--op-sf)', boxSizing: 'border-box', zIndex: 2 } })),
        (r.dias || []).map((d) => ({ l: '', tip: d.tip, st: { position: 'absolute', top: 15, left: 'calc(' + x(d.date) + '% - 7px)', width: 14, height: 14, transform: 'rotate(45deg)', borderRadius: 3, background: d.risk ? 'var(--op-band)' : 'var(--op-sf)', border: '2px solid ' + (d.risk ? 'var(--op-amberbar)' : 'var(--op-ink)'), boxSizing: 'border-box', zIndex: 2 } }))) })) }); };
  K.lines = (o) => K.mk('lines', { ...o, hasLegend: !!(o.legend && o.legend.length), legend: (o.legend || []).map(([l, c]) => ({ l, st: { width: 10, height: 10, borderRadius: 3, background: c } })), foot: o.foot || '', hasFoot: !!o.foot,
    lines: o.lines.map((l) => ({ no: l.no == null ? '' : String(l.no), text: l.text, tag: l.tag || '', hasTag: !!l.tag, on: l.on || (() => {}), bar: { width: 4, alignSelf: 'stretch', background: l.color || 'transparent', borderRadius: 2, flex: 'none' },
      st: { display: 'flex', alignItems: 'stretch', gap: 10, padding: '3px 8px', cursor: l.on ? 'pointer' : 'default', borderRadius: 6, background: l.sel ? 'var(--op-sbg)' : l.kind === '+' ? 'var(--op-mint)' : l.kind === '-' ? 'var(--op-peach)' : 'transparent', outline: l.sel ? '1px solid var(--op-ink)' : 'none' },
      tst: { flex: 1, minWidth: 0, fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace', fontSize: 12.5, lineHeight: 1.6, whiteSpace: 'pre-wrap', textDecoration: l.kind === '-' ? 'line-through' : 'none', color: l.mut ? 'var(--op-mut)' : 'var(--op-ink)' }, tagSt: l.tagSt || K.idc(l.tag).st })) });
  K.notes = (o) => K.mk('notes', { ...o, notes: o.notes.map((n, i) => ({ ...n, hasOutcome: !!n.outcome, outSt: K.pill(n.outcome || ''), btns: K.bs(n.btns), st: { display: 'flex', flexDirection: 'column', gap: 8, background: n.fill || 'var(--op-ac)', borderRadius: 6, padding: 14, boxShadow: '0 18px 40px -28px rgba(25,21,16,.35)', transform: 'rotate(' + (((i * 37) % 5) - 2) * 0.6 + 'deg)', minHeight: 140, boxSizing: 'border-box' } })),
    gst: { display: 'grid', gap: 16, gridTemplateColumns: 'repeat(auto-fill, minmax(' + (o.min || 210) + 'px, 1fr))' } });
  K.flow = (o) => { const R = window.React; const H = o.h || 420;
    const svg = R.createElement('svg', { viewBox: '0 0 1000 ' + H, preserveAspectRatio: 'none', style: { position: 'absolute', inset: 0, width: '100%', height: '100%' } }, o.links.map((l, i) => R.createElement('path', { key: i, d: l.d, fill: 'none', stroke: l.color || 'var(--op-sage)', strokeWidth: l.w, strokeOpacity: l.op, vectorEffect: 'non-scaling-stroke' })));
    return K.mk('flow', { ...o, svg, box: { position: 'relative', minWidth: 900, height: H }, heads: o.heads.map((h) => ({ t: h.t, st: { position: 'absolute', top: -26, left: h.x + '%', fontSize: 10.5, fontWeight: 700, letterSpacing: '.09em', textTransform: 'uppercase', color: 'var(--op-mut)', whiteSpace: 'nowrap' } })), chips: (o.chips || []).map((c) => ({ ...c, st: K.choice(c.sel) })), info: o.info || '', btns: K.bs(o.btns) }); };
  K.page = (out) => { const d = { blocks: [], drawer: { open: false, blocks: [], btns: [] }, modal: { open: false, blocks: [], btns: [] }, bulk: { open: false, btns: [] } }; Object.keys(out).forEach((k) => { if (out[k] !== undefined) d[k] = out[k]; }); return d; };
  K.drawer = (o) => ({ open: true, title: '', sub: '', ...o, hasSub: !!o.sub, btns: K.bs(o.btns), blocks: o.blocks || [], st: { position: 'relative', width: 'min(' + (o.w || 520) + 'px, 100%)', height: '100%', overflowY: 'auto', boxSizing: 'border-box', background: 'var(--op-bg)', borderLeft: '1px solid var(--op-line)', padding: '20px 22px 28px', boxShadow: '0 34px 80px rgba(25,21,16,.3)', display: 'flex', flexDirection: 'column', gap: 14 } });
  K.modal = (o) => ({ open: true, title: '', sub: '', ...o, hasSub: !!o.sub, hasFoot: !!o.foot, foot: o.foot || '', btns: K.bs(o.btns), blocks: o.blocks || [], st: { position: 'relative', width: 'min(' + (o.w || 900) + 'px, 100%)', maxHeight: 'min(780px, 92vh)', display: 'flex', flexDirection: 'column', boxSizing: 'border-box', background: 'var(--op-bg)', borderRadius: 22, boxShadow: '0 34px 80px rgba(25,21,16,.3)', overflow: 'hidden' } });
  K.bulk = (text, btns, onX) => ({ open: true, text, btns: K.bs(btns), onX });
  // Shared Board / List / Timeline template (spec §7) — Projects, Templates, Library, Actions
  K.views = (cfg, cmp) => {
    const key = 'orgcue-view-' + cfg.key; const st = cmp.state || {};
    const view = st['v_' + cfg.key] || LS(key, cfg.def || 'List');
    const setView = (v) => { try { localStorage.setItem(key, JSON.stringify(v)); } catch (e) {} cmp.setState({ ['v_' + cfg.key]: v }); };
    const q = (st['q_' + cfg.key] || '').toLowerCase();
    const match = (r) => !q || String(r.search || '').toLowerCase().includes(q);
    const out = cfg.noHead ? [] : [K.head({ eyebrow: cfg.eyebrow, title: cfg.title, sub: cfg.sub, seg: ['Board', 'List', 'Timeline'].map((v) => ({ t: v, sel: view === v, on: () => setView(v) })), actions: [K.b('CSV', () => K.toast(cfg.title + '.csv · ' + cfg.groups.reduce((n, g) => n + g.rows.length, 0) + ' rows · downloading'))].concat(cfg.headActions || []) })];
    if (cfg.kpis) out.push(K.kpis(cfg.kpis));
    if (cfg.banner) out.push(cfg.banner);
    (cfg.extra || []).forEach((b) => out.push(b));
    out.push(K.mk('toolbar', { primary: K.bs(cfg.primary), q: st['q_' + cfg.key] || '', onQ: (e) => cmp.setState({ ['q_' + cfg.key]: e.target.value }), qst: { width: 200 },
      tools: ['◐ Person', '⊽ Filter', '⇅ Sort', '▤ Group by: ' + (view === 'Board' ? cfg.boardBy : cfg.groupBy)].map((t) => ({ t, on: () => K.toast(t + ' · options open here'), st: { cursor: 'pointer', border: 'none', borderRadius: 8, background: 'transparent', padding: '7px 9px', fontFamily: 'inherit', fontSize: 13, color: 'var(--op-body)', whiteSpace: 'nowrap' } })) }));
    if (view === 'List') out.push(K.table({ cols: cfg.cols, grid: cfg.grid, minW: cfg.minW, noun: cfg.noun, add: cfg.add, groups: cfg.groups.map((g) => { const rows = g.rows.filter(match); const n = rows.length || 1; const cnt = {}; rows.forEach((r) => { if (r.status) cnt[r.status] = (cnt[r.status] || 0) + 1; }); return { ...g, rows, dist: Object.entries(cnt).map(([l, c]) => ({ l, pct: c / n * 100 })) }; }) }));
    if (view === 'Board') { if (cfg.boardBlocks) cfg.boardBlocks.forEach((b) => out.push(b)); else out.push(K.board({ cols: cfg.board.map((c) => ({ ...c, cards: c.cards.filter(match) })) })); }
    if (view === 'Timeline') out.push(K.timeline({ ...cfg.timeline, rows: cfg.timeline.rows.filter(match) }));
    return out;
  };
  // next-step matrix (spec §25.3)
  K.next = () => { const r = K.S.role, ph = K.S.phase, P = '/p/it-helpdesk/';
    if (r === 'admin') return { t: 'Connect ServiceNow to sync actions', why: 'Two actions are already tracked as ServiceNow change requests. Connecting keeps their status in sync here.', cta: ['Open integrations', '/settings/integrations'] };
    const M = {
      owner: { Frame: ['Send questions to 8 members', 'The question set is ready. Each member answers privately, in about 12 minutes.', ['Open members', P + 'members'], ['Review questions', P + 'input']], Collect: ['4 of 8 haven’t answered', 'Collection closes Nov 14. Tom Becker and Mei Lin are authority members for two sections.', ['Nudge now', null, 'Nudged 4 members · second reminder, worded differently'], ['Close and reveal', P + 'input']], Review: ['3 ideas ready to promote', 'N-03, N-07 and N-11 have support from three groups. Promoting creates a suggestion in the spec.', ['Open brainstorm', P + 'brainstorm']], Decide: ['2 decisions waiting on Daniel', 'DEC-03 and DEC-07 are open. When they’re recorded, the spec is ready to lock.', ['Open spec', P + 'spec'], ['Nudge Daniel', null, 'Daniel Reyes was reminded about DEC-03 and DEC-07']], Validate: ['Send the close-the-loop note', 'Every member gets what happened to their input, including when they lost.', ['Open overview', P + 'overview'], ['Track actions', P + 'actions']], Live: ['3 constraints due for review', 'HC-007, HC-012 and HC-019 are due Mar 1. Each owner confirms or proposes a change.', ['Run review', P + 'generate']] },
      decider: { Frame: ['Nothing waiting yet', 'You’ll get your 3 questions when Kari sends the set.', null], Collect: ['Answer your 3 questions', 'About 6 minutes. Your answers stay private until collection closes.', ['Answer now', '/phone']], Review: ['Decisions arrive when Review closes', 'Four conflicts are forming. You’ll see both sides, with quotes and advisory points.', ['Preview the spec', P + 'spec']], Decide: ['Settle DEC-03 and DEC-07, then lock', 'Both are blocking v1.4.0. Each needs a choice and a written rationale.', ['Open decisions', P + 'spec']], Validate: ['Approve the generation diff', 'All gates pass after HC-019 was fixed. Validation came back with 2 violations, under the threshold of 4.', ['Open generate', P + 'generate']], Live: ['Approve go-live Jan 12', 'The pilot ran 30 days with 2 violations. Go-live needs your approval.', ['Open actions', P + 'actions']] },
      contributor: { Frame: ['Nothing to do yet', 'Kari will send your questions soon. It takes about 12 minutes.', null], Collect: ['Answer 6 questions · 12 min', 'Your answers stay private until everyone has answered.', ['Answer now', P + 'my-input'], ['Answer on phone', '/phone']], Review: ['Agree or Object on 3 items', 'Give your own view first. Comments appear after you’ve answered.', ['Open spec', P + 'spec']], Decide: ['Your input is with the decider', 'Daniel Reyes is settling 2 conflicts. You’ll hear what was decided and why.', ['See your input', P + 'my-input']], Validate: ['Read what happened to your input', 'Two of your points made the spec; one went to a decision.', ['Open my input', P + 'my-input']], Live: ['Accept your action A-016', 'Write on-call escalation runbook for the agent · due Nov 21.', ['Open actions', P + 'actions']] },
    };
    const x = M[r][ph]; return { t: x[0], why: x[1], cta: x[2], cta2: x[3] }; };
  K.nextBtns = (n) => [n.cta, n.cta2].filter(Boolean).map((c, i) => K.b(c[0], c[1] ? K.nav(c[1]) : () => K.toast(c[2] || c[0]), i ? 'secondary' : 'primary'));
  K.who = () => ({ owner: 'kari', decider: 'daniel', contributor: 'sam', admin: 'jordan' }[K.S.role]);
  K.seesNames = () => K.S.role !== 'contributor';
})();
