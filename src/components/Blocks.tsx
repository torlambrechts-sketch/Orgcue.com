/* eslint-disable @typescript-eslint/no-explicit-any */
// Renders the block descriptors that the screen logic (src/screens, src/oc/kit.js) produces.
// Element for element this mirrors the shared <x-dc> template in design/design_handoff_orgcue/prototype/OcPages.dc.html:
// sections (toolbar, head, tabs, banner, kpis, stepper, panel, table, board, timeline, lines, notes, flow),
// panel items, cells, and the drawer / modal / bulk-bar overlays. Inline styles are copied from that template.
import React from 'react';
import { Button, Input, Mark, Select, Switch, Textarea } from './ds';

const cache = new Map<string, React.CSSProperties>();
/** Parses a CSS declaration string ("display: flex; gap: 8px") into a React style object. */
export function css(s: string): React.CSSProperties {
  let o = cache.get(s);
  if (!o) {
    const r: Record<string, string> = {};
    s.split(';').forEach((d) => { const i = d.indexOf(':'); if (i < 0) return; const k = d.slice(0, i).trim(); if (!k) return; r[k.startsWith('--') ? k : k.replace(/-([a-z])/g, (_, c) => c.toUpperCase())] = d.slice(i + 1).trim(); });
    o = r as React.CSSProperties; cache.set(s, o);
  }
  return o;
}
const nw = css('white-space: nowrap;');
const SUB = css('display: block; margin-top: 2px; font-size: 12px; font-weight: 400; color: var(--op-mut);');
const AV = css('display: flex; width: 28px; height: 28px; flex: none; align-items: center; justify-content: center; border-radius: 999px; background: var(--op-ink); color: var(--op-bg); font-size: 10.5px; font-weight: 700;');

function Btns({ list, size }: { list?: any[]; size: string }) {
  return <>{(list || []).map((b, i) => <Button key={i} size={size} tone={b.tone} onClick={b.on} disabled={b.dis}><span style={nw}>{b.t}</span></Button>)}</>;
}

export function Cell({ c }: { c: any }) {
  if (!c) return null;
  if (c.is_text) return <span style={c.st}><span style={css('display: block;')}>{c.t}</span>{c.hasSub && <span style={SUB}>{c.sub}</span>}</span>;
  if (c.is_status) return <button type="button" onClick={c.on} style={c.st}>{c.t}</button>;
  if (c.is_avatar) return <span style={css('display: flex; align-items: center; gap: 8px; min-width: 0;')}><span style={AV}>{c.ini}</span><span style={css('min-width: 0; font-size: 13px;')}><span style={css('display: block;')}>{c.t}</span>{c.hasSub && <span style={SUB}>{c.sub}</span>}</span></span>;
  if (c.is_btn) return <Button size="xxs" tone={c.tone} onClick={c.on} disabled={c.dis}><span style={nw}>{c.t}</span></Button>;
  if (c.is_chip) return <span style={c.st}>{c.t}</span>;
  if (c.is_chips) return <span style={css('display: flex; flex-wrap: wrap; gap: 4px;')}>{(c.list || []).map((x: any, i: number) => <span key={i} style={x.st}>{x.t}</span>)}</span>;
  if (c.is_check) return <button type="button" aria-label={c.label} aria-pressed={c.on} onClick={c.ch} style={css('display: flex; padding: 0; border: none; background: transparent; cursor: pointer;')}><Mark checked={c.on} size={18} /></button>;
  if (c.is_bar) return <span style={css('display: flex; flex: 1; align-items: center; gap: 8px; min-width: 0;')}><span style={css('flex: 1; height: 8px; border-radius: 999px; background: var(--op-ink-a08); overflow: hidden;')}><span style={c.fill} /></span><span style={css('font-size: 12px; font-variant-numeric: tabular-nums; white-space: nowrap;')}>{c.t}</span></span>;
  return null;
}
const CW = css('display: flex; align-items: center; min-width: 0;');

export function Item({ i }: { i: any }) {
  if (i.is_t) return <span style={css('display: flex; flex-direction: column; gap: 2px;')}><span style={i.st}>{i.text}</span>{i.hasSub && <span style={SUB}>{i.sub}</span>}</span>;
  if (i.is_p) return <p style={i.st}>{i.text}</p>;
  if (i.is_q) return <span style={css('display: block; border-radius: 12px; background: var(--op-bg); padding: 9px 12px; font-family: var(--font-display); font-size: 14px; line-height: 1.45;')}>«{i.text}»{i.hasBy && <span style={css('display: block; margin-top: 4px; font-family: var(--font-sans); font-size: 12px; color: var(--op-mut);')}>{i.by}</span>}</span>;
  if (i.is_pills) return <span style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 6px;')}>{(i.list || []).map((p: any, k: number) => <span key={k} style={p.st}>{p.t}</span>)}</span>;
  if (i.is_btns) return <span style={css('display: flex; flex-wrap: wrap; gap: 8px;')}><Btns list={i.list} size="xs" /></span>;
  if (i.is_kv) return <span style={css('display: grid; grid-template-columns: minmax(90px, 140px) minmax(0, 1fr); gap: 10px; align-items: center; font-size: 13px;')}><span style={css('color: var(--op-mut);')}>{i.label}</span><span style={CW}><Cell c={i.v} /></span></span>;
  if (i.is_field) return (
    <label style={css('display: flex; flex-direction: column; gap: 5px; min-width: 0;')}>
      {i.hasLabel && <span style={css('font-size: 13px; font-weight: 600;')}>{i.label}</span>}
      {i.isIn && <Input size="field" type={i.type} value={i.value} onChange={i.ch} placeholder={i.ph} aria-label={i.label} style={i.fst} />}
      {i.isTa && <Textarea value={i.value} onChange={i.ch} placeholder={i.ph} aria-label={i.label} />}
      {i.isSel && <Select size="field" options={i.opts} value={i.value} onChange={i.ch} aria-label={i.label} style={i.fst} />}
      {i.hasHelp && <span style={css('font-size: 12px; color: var(--op-mut);')}>{i.help}</span>}
    </label>
  );
  if (i.is_chips) return (
    <span style={css('display: flex; flex-direction: column; gap: 6px;')}>
      {i.hasLabel && <span style={css('font-size: 13px; font-weight: 600;')}>{i.label}</span>}
      <span style={css('display: flex; flex-wrap: wrap; gap: 6px;')}>{(i.list || []).map((c: any, k: number) => <button key={k} type="button" onClick={c.on} aria-pressed={c.sel} style={c.st}>{c.t}</button>)}</span>
    </span>
  );
  if (i.is_row) return (
    <div onClick={i.on} style={i.st}>
      {i.hasStripe && <span style={i.stripe} />}
      <span style={css('flex: 1 1 220px; min-width: 0;')}>
        <span style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 6px;')}>{(i.chips || []).map((c: any, k: number) => <span key={k} style={c.st}>{c.t}</span>)}<span style={i.titleSt}>{i.title}</span></span>
        {i.hasSub && <span style={css('display: block; margin-top: 3px; font-size: 12.5px; line-height: 1.45; color: var(--op-mut); text-wrap: pretty;')}>{i.sub}</span>}
      </span>
      <span style={css('display: flex; flex-wrap: wrap; gap: 6px;')}><Btns list={i.btns} size="xxs" /></span>
    </div>
  );
  if (i.is_bar) return (
    <span style={css('display: flex; flex-direction: column; gap: 4px;')}>
      <span style={css('display: flex; justify-content: space-between; gap: 8px; font-size: 13px;')}><span>{i.label}{i.hasSub && <span style={css('color: var(--op-mut); font-size: 12px;')}> · {i.sub}</span>}</span><span style={css('font-weight: 700; font-variant-numeric: tabular-nums;')}>{i.value}</span></span>
      <span style={css('display: block; height: 8px; border-radius: 999px; background: var(--op-ink-a08); overflow: hidden;')}><span style={i.fill} /></span>
    </span>
  );
  if (i.is_sep) return <span style={css('display: block; height: 1px; background: var(--op-line);')} />;
  if (i.is_toggle) return (
    <span style={css('display: flex; align-items: center; justify-content: space-between; gap: 12px;')}>
      <span style={css('min-width: 0;')}><span style={css('display: block; font-size: 13.5px; font-weight: 600;')}>{i.label}</span>{i.hasHelp && <span style={css('display: block; font-size: 12px; color: var(--op-mut);')}>{i.help}</span>}</span>
      <Switch on={i.on} onChange={i.ch} label={i.label} />
    </span>
  );
  if (i.is_check) return (
    <button type="button" onClick={i.ch} aria-pressed={i.on} style={css('display: flex; align-items: flex-start; gap: 10px; padding: 4px 0; border: none; background: transparent; cursor: pointer; font-family: inherit; color: var(--op-ink); text-align: left;')}>
      <Mark checked={i.on} size={18} />
      <span><span style={css('display: block; font-size: 13.5px; font-weight: 600;')}>{i.label}</span>{i.hasHelp && <span style={css('display: block; font-size: 12px; color: var(--op-mut);')}>{i.help}</span>}</span>
    </button>
  );
  if (i.is_diff) return <span style={css('font-size: 14px; line-height: 1.7;')}>{(i.parts || []).map((p: any, k: number) => <span key={k} style={p.st}>{p.t}</span>)}</span>;
  if (i.is_grid) return <div style={i.gst}>{(i.cells || []).map((c: any, k: number) => <span key={k} style={CW}><Cell c={c} /></span>)}</div>;
  if (i.is_cards) return (
    <div style={i.gst}>
      {(i.list || []).map((c: any, k: number) => (
        <div key={k} onClick={c.on} role="button" style={c.st}>
          <span style={css('display: flex; flex-wrap: wrap; gap: 5px;')}>{(c.tags || []).map((t: any, j: number) => <span key={j} style={t.st}>{t.t}</span>)}</span>
          <span style={css('font-size: 14.5px; font-weight: 700; line-height: 1.35;')}>{c.title}</span>
          {c.hasSub && <span style={css('font-size: 12.5px; line-height: 1.45; color: var(--op-mut);')}>{c.sub}</span>}
          {c.hasFoot && <span style={css('margin-top: auto; font-size: 12px; color: var(--op-body);')}>{c.foot}</span>}
          {c.hasBtns && <span style={css('display: flex; flex-wrap: wrap; gap: 6px;')}><Btns list={c.btns} size="tiny" /></span>}
        </div>
      ))}
    </div>
  );
  return null;
}

function Table({ b }: { b: any }) {
  return (
    <div style={css('display: flex; flex-direction: column; gap: 30px;')}>
      {b.hasTitle && (
        <span style={css('display: flex; flex-wrap: wrap; align-items: baseline; justify-content: space-between; gap: 8px; margin-bottom: -18px;')}>
          <span style={css('display: flex; align-items: baseline; gap: 8px;')}><h2 style={css('margin: 0; font-family: var(--font-display); font-size: 19px; font-weight: 600;')}>{b.title}</h2><span style={css('font-size: 12.5px; color: var(--op-mut);')}>{b.note}</span></span>
          <span style={css('display: flex; gap: 6px;')}><Btns list={b.actions} size="xxs" /></span>
        </span>
      )}
      {(b.groups || []).map((g: any, gi: number) => (
        <div key={gi} style={css('display: flex; flex-direction: column; gap: 8px;')}>
          {g.hasHead && <span style={css('display: flex; align-items: baseline; gap: 10px;')}><span aria-hidden="true" style={css('font-size: 13px; color: var(--op-mut);')}>⌄</span><span style={g.titleSt}>{g.title}</span><span style={css('font-size: 12.5px; color: var(--op-mut);')}>{g.count}</span></span>}
          <div style={css('overflow-x: auto; border: 1px solid var(--op-line); border-radius: 8px; background: var(--op-sf);')}>
            <div style={b.minW}>
              <div style={g.headSt}><span style={g.bar} />{(g.cols || []).map((c: any, k: number) => <span key={k} style={css('display: flex; align-items: center; padding: 9px 10px; border-left: 1px solid var(--op-line); min-width: 0;')}>{c}</span>)}</div>
              {(g.rows || []).map((r: any, ri: number) => (
                <div key={ri} onClick={r.on} style={r.st}><span style={r.bar} />{r.cells.map((c: any, k: number) => <span key={k} style={c.wst}><Cell c={c} /></span>)}</div>
              ))}
              {g.hasEmpty && <div style={css('padding: 16px 18px; font-size: 13.5px; color: var(--op-mut);')}>{g.empty}</div>}
              {g.hasAdd && (
                <div style={css('display: flex; align-items: stretch; min-height: 38px;')}>
                  <span style={g.addBar} />
                  <button type="button" onClick={g.onAdd} style={css('flex: 1; display: flex; align-items: center; border: none; background: transparent; cursor: pointer; padding: 0 12px; font-family: inherit; font-size: 13px; color: var(--op-mut); text-align: left;')}>{g.add}</button>
                  {g.hasDist && <span style={css('display: flex; align-self: center; width: 180px; height: 20px; margin-right: 12px; border-radius: 4px; overflow: hidden; background: var(--op-track);')}>{g.dist.map((d: any, k: number) => <span key={k} title={d.l} style={d.st} />)}</span>}
                </div>
              )}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}

function Board({ b }: { b: any }) {
  return (
    <div style={b.gst}>
      {(b.cols || []).map((col: any, ci: number) => (
        <div key={ci} style={css('display: flex; flex-direction: column; gap: 10px; border-radius: 16px; background: var(--op-ink-a05); padding: 12px; min-height: 160px;')}>
          <span style={css('display: flex; align-items: center; gap: 8px; padding: 2px 4px;')}><span style={col.dot} /><span style={css('font-size: 14.5px; font-weight: 700;')}>{col.title}</span><span style={css('border-radius: 999px; background: var(--op-sf); padding: 1px 8px; font-size: 12px; font-weight: 700;')}>{col.count}</span></span>
          {col.cards.map((k: any, i: number) => (
            <div key={i} onClick={k.on} role="button" style={css('display: flex; flex-direction: column; gap: 8px; border: 1px solid var(--op-line); border-radius: 12px; background: var(--op-sf); padding: 13px; cursor: pointer;')}>
              <span style={css('display: flex; justify-content: space-between; gap: 8px;')}><span style={k.tagSt}>{k.tag}</span><span style={css('font-family: ui-monospace, Menlo, monospace; font-size: 11.5px; color: var(--op-mut);')}>{k.id}</span></span>
              <span style={css('font-size: 16px; font-weight: 600; line-height: 1.3;')}>{k.title}</span>
              {k.hasDesc && <span style={css('font-size: 12.5px; line-height: 1.45; color: var(--op-mut);')}>{k.desc}</span>}
              {k.hasPerson && <span style={css('display: flex; align-items: center; gap: 8px;')}><span style={css('display: flex; width: 26px; height: 26px; align-items: center; justify-content: center; border-radius: 999px; background: var(--op-ink); color: var(--op-bg); font-size: 10px; font-weight: 700;')}>{k.ini}</span><span style={css('font-size: 12.5px;')}>{k.person} <span style={css('color: var(--op-mut);')}>{k.role}</span></span></span>}
              {k.hasWarn && <span style={css('align-self: flex-start; border-radius: 999px; background: var(--op-dangerdeep); color: var(--op-sf); padding: 2px 9px; font-size: 11.5px; font-weight: 700;')}>! {k.warn}</span>}
              <span style={css('display: flex; justify-content: space-between; gap: 8px; border-top: 1px solid var(--op-line); padding-top: 8px; font-size: 12px; color: var(--op-mut);')}><span>{k.left}</span><span>{k.right}</span></span>
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}

function Timeline({ b }: { b: any }) {
  return (
    <div style={css('overflow-x: auto; border: 1px solid var(--op-line); border-radius: 8px; background: var(--op-sf);')}>
      <div style={css('min-width: 900px; display: grid; grid-template-columns: 280px minmax(0, 1fr);')}>
        <span style={css('padding: 10px 14px; border-bottom: 1px solid var(--op-line); font-size: 10.5px; font-weight: 700; letter-spacing: .09em; text-transform: uppercase; color: var(--op-mut);')}>Item</span>
        <span style={css('position: relative; height: 36px; border-bottom: 1px solid var(--op-line);')}>{b.months.map((m: any, k: number) => <span key={k} style={m.st}><span style={css('display: block; padding-top: 10px;')}>{m.l}</span></span>)}</span>
        {b.rows.map((r: any, k: number) => (
          <React.Fragment key={k}>
            <button type="button" onClick={r.on} style={css('display: flex; align-items: center; gap: 9px; padding: 8px 14px; border: none; border-bottom: 1px solid var(--op-line); background: transparent; cursor: pointer; font-family: inherit; color: var(--op-ink); text-align: left; min-height: 44px;')}>
              <span style={r.dot} /><span style={css('min-width: 0;')}><span style={css('display: block; font-size: 13px; font-weight: 600;')}>{r.label}</span><span style={css('display: block; font-size: 11.5px; color: var(--op-mut);')}>{r.sub}</span></span>
            </button>
            <span style={css('position: relative; min-height: 44px; border-bottom: 1px solid var(--op-line);')}><span style={b.today} />{r.marks.map((m: any, j: number) => <span key={j} title={m.tip} style={m.st}>{m.l}</span>)}</span>
          </React.Fragment>
        ))}
      </div>
      <div style={css('padding: 9px 14px; font-size: 12px; color: var(--op-mut);')}>{b.foot}</div>
    </div>
  );
}

function Lines({ b }: { b: any }) {
  return (
    <div style={css('display: flex; flex-direction: column; gap: 6px;')}>
      {b.hasLegend && <span style={css('display: flex; flex-wrap: wrap; gap: 6px 14px; font-size: 12px; color: var(--op-mut);')}>{b.legend.map((l: any, k: number) => <span key={k} style={css('display: inline-flex; align-items: center; gap: 6px;')}><span style={l.st} />{l.l}</span>)}</span>}
      <div style={css('border: 1px solid var(--op-line); border-radius: 12px; background: var(--op-sf); padding: 8px 4px; overflow-x: auto;')}>
        {b.lines.map((l: any, k: number) => (
          <div key={k} onClick={l.on} style={l.st}>
            <span style={css('width: 26px; flex: none; text-align: right; font-family: ui-monospace, Menlo, monospace; font-size: 11.5px; line-height: 1.75; color: var(--op-mut);')}>{l.no}</span>
            <span style={l.bar} /><span style={l.tst}>{l.text}</span>
            {l.hasTag && <span style={css('align-self: center;')}><span style={l.tagSt}>{l.tag}</span></span>}
          </div>
        ))}
      </div>
      {b.hasFoot && <span style={css('font-size: 12px; color: var(--op-mut);')}>{b.foot}</span>}
    </div>
  );
}

function Notes({ b }: { b: any }) {
  return (
    <div style={b.gst}>
      {b.notes.map((n: any, k: number) => (
        <div key={k} style={n.st}>
          <span style={css('display: flex; justify-content: space-between; gap: 8px; font-size: 11.5px; font-weight: 700;')}><span style={css('font-family: ui-monospace, Menlo, monospace;')}>{n.id}</span><span>{n.author}</span></span>
          <span style={css('font-family: var(--font-display); font-size: 15.5px; line-height: 1.4;')}>{n.text}</span>
          {n.hasOutcome && <span style={n.outSt}>{n.outcome}</span>}
          <span style={css('margin-top: auto; display: flex; flex-wrap: wrap; gap: 4px;')}><Btns list={n.btns} size="tiny" /></span>
        </div>
      ))}
    </div>
  );
}

function Flow({ b }: { b: any }) {
  return (
    <div style={css('display: flex; flex-direction: column; gap: 10px;')}>
      <span style={css('display: flex; flex-wrap: wrap; gap: 6px;')}>{b.chips.map((c: any, k: number) => <button key={k} type="button" onClick={c.on} style={c.st}>{c.t}</button>)}</span>
      <div style={css('display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 8px; border-radius: 12px; background: var(--op-track); padding: 9px 12px; font-size: 13px;')}><span>{b.info}</span><span style={css('display: flex; gap: 6px;')}><Btns list={b.btns} size="tiny" /></span></div>
      <div style={css('overflow-x: auto; padding-top: 30px;')}>
        <div style={b.box}>
          {b.svg}
          {b.heads.map((h: any, k: number) => <span key={k} style={h.st}>{h.t}</span>)}
          {(b.nodes || []).map((n: any, k: number) => (
            <button key={k} type="button" onClick={n.on} title={n.tip} style={n.st}>
              <span style={css('display: block; font-size: 12px; font-weight: 600; line-height: 1.3; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')}>{n.label}</span>
              <span style={css('display: block; font-size: 11px; color: var(--op-mut); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;')}>{n.sub}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

export function Block({ b }: { b: any }) {
  let inner: React.ReactNode = null;
  if (b.is_toolbar) inner = (
    <div style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 8px; border-top: 1px solid var(--op-line); border-bottom: 1px solid var(--op-line); padding: 8px 0;')}>
      <Btns list={b.primary} size="xs" />
      <span style={css('display: flex; align-items: center; gap: 6px; margin-left: 6px;')}><span aria-hidden="true" style={css('color: var(--op-mut);')}>◯</span><Input size="field" placeholder="Search" value={b.q} onChange={b.onQ} aria-label="Search" style={b.qst} /></span>
      {b.tools.map((t: any, k: number) => <button key={k} type="button" onClick={t.on} style={t.st}>{t.t}</button>)}
    </div>
  );
  else if (b.is_head) inner = (
    <div style={css('display: flex; flex-wrap: wrap; align-items: flex-end; justify-content: space-between; gap: 12px;')}>
      <span style={css('min-width: 0; max-width: 780px;')}>
        {b.hasEyebrow && <span style={css('display: block; font-size: 11px; font-weight: 700; letter-spacing: .11em; text-transform: uppercase; color: var(--op-mut);')}>{b.eyebrow}</span>}
        <h1 style={css('margin: 4px 0 0; font-family: var(--font-display); font-size: 28px; line-height: 1.2; font-weight: 600; text-wrap: balance;')}>{b.title}</h1>
        {b.hasSub && <p style={css('margin: 6px 0 0; font-size: 14.5px; line-height: 1.55; color: var(--op-body); text-wrap: pretty;')}>{b.sub}</p>}
      </span>
      <span style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 8px;')}>
        {b.hasSeg && <span style={css('display: flex; gap: 2px; border-radius: 11px; background: var(--op-track); padding: 3px;')}>{b.seg.map((s: any, k: number) => <button key={k} type="button" onClick={s.on} style={s.st}>{s.t}</button>)}</span>}
        <Btns list={b.actions} size="sm" />
      </span>
    </div>
  );
  else if (b.is_tabs) inner = <div style={css('display: flex; gap: 22px; overflow-x: auto; border-bottom: 1px solid var(--op-line);')}>{b.list.map((t: any, k: number) => <button key={k} type="button" onClick={t.on} style={t.st}>{t.t}</button>)}</div>;
  else if (b.is_banner) inner = <div style={b.st}><span style={css('flex: 1 1 300px; min-width: 0;')}>{b.text}</span><Btns list={b.actions} size="xxs" /></div>;
  else if (b.is_kpis) inner = (
    <div style={css('display: grid; gap: 13px; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));')}>
      {b.tiles.map((t: any, k: number) => (
        <div key={k} style={css('border: 1px solid var(--op-line); border-radius: 18px; background: var(--op-sf); padding: 16px 18px; display: flex; flex-direction: column; gap: 4px;')}>
          <span style={css('font-size: 10.5px; font-weight: 700; letter-spacing: .09em; text-transform: uppercase; color: var(--op-mut);')}>{t.label}</span>
          <span style={css('font-family: var(--font-display); font-size: 32px; line-height: 1.1; font-weight: 600; font-variant-numeric: tabular-nums;')}>{t.value}</span>
          <span style={t.nst}>{t.note}</span>
        </div>
      ))}
    </div>
  );
  else if (b.is_stepper) inner = (
    <ol style={css('margin: 0; padding: 0; list-style: none; display: flex; align-items: flex-start; overflow-x: auto;')}>
      {b.steps.map((s: any, k: number) => (
        <li key={k} style={css('display: flex; align-items: center; flex: 1; min-width: 96px;')}>
          <button type="button" onClick={s.on} style={css('display: flex; flex-direction: column; align-items: center; gap: 4px; border: none; background: transparent; cursor: pointer; font-family: inherit; padding: 0 4px;')}>
            <span style={s.dot}>{s.glyph}</span><span style={s.lst}>{s.label}</span><span style={css('font-size: 11px; color: var(--op-mut);')}>{s.sub}</span>
          </button>
          <span style={s.line} />
        </li>
      ))}
    </ol>
  );
  else if (b.is_panel) inner = (
    <div style={b.st}>
      {b.hasHead && (
        <div style={css('display: flex; flex-wrap: wrap; align-items: baseline; justify-content: space-between; gap: 8px;')}>
          <span style={css('display: flex; flex-wrap: wrap; align-items: baseline; gap: 8px; min-width: 0;')}>
            {b.hasTitle && <h2 style={css('margin: 0; font-family: var(--font-display); font-size: 19px; line-height: 1.3; font-weight: 600;')}>{b.title}</h2>}
            {b.hasChip && <span style={b.chipSt}>{b.chip}</span>}
            {b.hasNote && <span style={css('font-size: 12.5px; color: var(--op-mut);')}>{b.note}</span>}
          </span>
          <span style={css('display: flex; flex-wrap: wrap; gap: 6px;')}><Btns list={b.actions} size="xxs" /></span>
        </div>
      )}
      {b.items.map((it: any, k: number) => <Item key={k} i={it} />)}
    </div>
  );
  else if (b.is_table) inner = <Table b={b} />;
  else if (b.is_board) inner = <Board b={b} />;
  else if (b.is_timeline) inner = <Timeline b={b} />;
  else if (b.is_lines) inner = <Lines b={b} />;
  else if (b.is_notes) inner = <Notes b={b} />;
  else if (b.is_flow) inner = <Flow b={b} />;
  return <section style={b.wrap}>{inner}</section>;
}

export function BlockList({ blocks }: { blocks?: any[] }) {
  return <div style={css('display: flex; flex-wrap: wrap; gap: 16px; align-items: flex-start;')}>{(blocks || []).map((b, k) => <Block key={k} b={b} />)}</div>;
}

const CLOSE = css('width: 34px; height: 34px; flex: none; cursor: pointer; border-radius: 999px; border: 1px solid var(--op-ink); background: transparent; font-size: 16px; color: var(--op-ink);');
const SCRIM = css('position: absolute; inset: 0; background: rgba(25,21,16,.42);');

export function Overlays({ drawer, modal, bulk }: { drawer?: any; modal?: any; bulk?: any }) {
  return (
    <>
      {drawer && drawer.open && (
        <div style={css('position: fixed; inset: 0; z-index: 70; display: flex; justify-content: flex-end;')}>
          <div onClick={drawer.onClose} style={SCRIM} />
          <aside role="dialog" aria-label={drawer.title} style={drawer.st}>
            <div style={css('display: flex; align-items: flex-start; justify-content: space-between; gap: 10px;')}>
              <span style={css('min-width: 0;')}><span style={css('display: block; font-family: var(--font-display); font-size: 21px; font-weight: 600; line-height: 1.25;')}>{drawer.title}</span>{drawer.hasSub && <span style={css('display: block; margin-top: 4px; font-size: 12.5px; color: var(--op-mut);')}>{drawer.sub}</span>}</span>
              <button type="button" aria-label="Close" onClick={drawer.onClose} style={CLOSE}>×</button>
            </div>
            <BlockList blocks={drawer.blocks} />
            <span style={css('display: flex; flex-wrap: wrap; gap: 8px; margin-top: auto; border-top: 1px solid var(--op-line); padding-top: 12px;')}><Btns list={drawer.btns} size="sm" /></span>
          </aside>
        </div>
      )}
      {modal && modal.open && (
        <div style={css('position: fixed; inset: 0; z-index: 75; display: flex; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box;')}>
          <div onClick={modal.onClose} style={SCRIM} />
          <div role="dialog" aria-label={modal.title} style={modal.st}>
            <div style={css('display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; padding: 20px 24px 12px;')}>
              <span style={css('min-width: 0;')}><span style={css('display: block; font-family: var(--font-display); font-size: 22px; font-weight: 600;')}>{modal.title}</span>{modal.hasSub && <span style={css('display: block; margin-top: 3px; font-size: 13px; color: var(--op-mut);')}>{modal.sub}</span>}</span>
              <button type="button" aria-label="Close" onClick={modal.onClose} style={CLOSE}>×</button>
            </div>
            <div style={css('flex: 1; overflow-y: auto; padding: 4px 24px 18px;')}><BlockList blocks={modal.blocks} /></div>
            <div style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 10px; border-top: 1px solid var(--op-line); padding: 14px 24px; background: var(--op-sf);')}>
              <span style={css('flex: 1 1 200px; font-size: 12.5px; color: var(--op-mut);')}>{modal.foot}</span>
              <Btns list={modal.btns} size="sm" />
            </div>
          </div>
        </div>
      )}
      {bulk && bulk.open && (
        <div style={css('position: fixed; z-index: 65; left: 50%; bottom: 24px; transform: translateX(-50%); display: flex; flex-wrap: wrap; align-items: center; gap: 8px; border-radius: 14px; background: var(--op-ink); color: var(--op-bg); padding: 8px 10px 8px 16px; box-shadow: 0 18px 40px -24px rgba(25,21,16,.45);')}>
          <span style={css('font-size: 13.5px; font-weight: 700; margin-right: 6px;')}>{bulk.text}</span>
          <Btns list={bulk.btns} size="xxs" />
          <button type="button" aria-label="Clear selection" onClick={bulk.onX} style={css('width: 30px; height: 30px; cursor: pointer; border: none; border-radius: 999px; background: transparent; color: var(--op-bg); font-size: 15px;')}>×</button>
        </div>
      )}
    </>
  );
}

/** The standard screen frame: blocks, then whatever the screen adds (e.g. the embedded Spec/Generate tab), then overlays. */
export function Page({ vals, children }: { vals: any; children?: React.ReactNode }) {
  return (
    <div style={css('min-width: 0; color: var(--op-ink); display: flex; flex-direction: column; gap: 16px;')}>
      <BlockList blocks={vals.blocks} />
      {children}
      <Overlays drawer={vals.drawer} modal={vals.modal} bulk={vals.bulk} />
    </div>
  );
}
