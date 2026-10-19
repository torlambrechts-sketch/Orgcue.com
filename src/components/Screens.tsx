/* eslint-disable @typescript-eslint/no-explicit-any */
// Mounts each ported screen class (src/screens) and renders its view model with the matching frame from the prototype.
'use client';
import React from 'react';
import Link from 'next/link';
import { useScreen } from '@/oc/dc';
import { BlockList, Overlays, Page, css } from './Blocks';
import { Button, Mark, Textarea } from './ds';
import OcPages from '@/screens/OcPages';
import OcProject from '@/screens/OcProject';
import OcSpecGen from '@/screens/OcSpecGen';
import OcWizard from '@/screens/OcWizard';
import OcSettings from '@/screens/OcSettings';
import OcPhone from '@/screens/OcPhone';

export function PagesScreen({ path }: { path: string }) {
  const v: any = useScreen(OcPages, { path });
  return <Page vals={v} />;
}

export function SpecGenScreen({ tab }: { tab: string }) {
  const v: any = useScreen(OcSpecGen, { tab });
  return <Page vals={v} />;
}

export function ProjectScreen({ path }: { path: string }) {
  const v: any = useScreen(OcProject, { path });
  return <Page vals={v}>{v.isSG && <SpecGenScreen tab={v.tab} />}</Page>;
}

export function WizardScreen() {
  const v: any = useScreen(OcWizard, {});
  return <Overlays modal={v.modal} />;
}

export function SettingsScreen({ path }: { path: string }) {
  const v: any = useScreen(OcSettings, { path });
  return (
    <div style={css('min-width: 0; color: var(--op-ink); display: flex; flex-direction: column; gap: 16px;')}>
      <div style={css('display: flex; flex-wrap: wrap; align-items: flex-start; gap: 20px;')}>
        <nav aria-label="Settings" style={css('flex: 0 0 210px; position: sticky; top: 12px; display: flex; flex-direction: column; gap: 2px; border: 1px solid var(--op-line); border-radius: 18px; background: var(--op-sf); padding: 10px;')}>
          <span style={css('padding: 4px 10px 8px; font-size: 10.5px; font-weight: 700; letter-spacing: .09em; text-transform: uppercase; color: var(--op-mut);')}>Settings</span>
          {(v.subnav || []).map((n: any, k: number) => <Link key={k} href={String(n.href || '').replace(/^#/, '')} style={n.st}>{n.t}</Link>)}
        </nav>
        <div style={css('flex: 1 1 480px; min-width: 0;')}><BlockList blocks={v.blocks} /></div>
      </div>
      <Overlays drawer={v.drawer} modal={v.modal} bulk={v.bulk} />
    </div>
  );
}

export function PhoneScreen({ path }: { path: string }) {
  const v: any = { ...useScreen(OcPhone, { path }), path };
  const s = v.s || {};
  if (!v.jumps) return null;
  return (
    <div style={css('display: flex; flex-wrap: wrap; justify-content: center; align-items: flex-start; gap: 28px; padding: 8px 0 24px;')}>
      <aside style={css('flex: 1 1 260px; max-width: 340px; display: flex; flex-direction: column; gap: 12px;')}>
        <span style={css('font-size: 11px; font-weight: 700; letter-spacing: .11em; text-transform: uppercase; color: var(--op-mut);')}>{v.eyebrow}</span>
        <h1 style={css('margin: 0; font-family: var(--font-display); font-size: 26px; line-height: 1.2; font-weight: 600;')}>{v.heading}</h1>
        <p style={css('margin: 0; font-size: 14px; line-height: 1.55; color: var(--op-body);')}>{v.note}</p>
        <div style={css('display: flex; flex-wrap: wrap; gap: 6px;')}>{v.jumps.map((j: any, k: number) => <button key={k} type="button" onClick={j.on} style={j.st}>{j.t}</button>)}</div>
        <Link href={(v.path || '').startsWith('/customer') ? '/p/it-helpdesk/members' : '/p/it-helpdesk/overview'} style={css('font-weight: 700;')}>← Back to the project</Link>
      </aside>
      <div style={css('flex: none; width: 390px; max-width: 100%; height: 844px; box-sizing: border-box; border: 7px solid var(--op-ink); border-radius: 48px; background: var(--op-bg); overflow: hidden; box-shadow: 0 18px 40px -28px rgba(25,21,16,.35);')}>
        <div style={css('height: 100%; overflow-y: auto; box-sizing: border-box; padding: 14px 20px 20px; display: flex; flex-direction: column; gap: 14px;')}>
          <div style={css('display: flex; justify-content: space-between; font-size: 12px; font-weight: 700;')}><span>9:41</span><span>{v.host}</span></div>
          {s.brand && <div style={css('display: flex; align-items: center; gap: 10px; border-bottom: 1px solid var(--op-line); padding-bottom: 10px;')}><span style={css('display: flex; width: 34px; height: 34px; align-items: center; justify-content: center; border-radius: 10px; background: var(--op-ink); color: var(--op-bg); font-family: var(--font-display); font-weight: 600;')}>L</span><span style={css('font-size: 15px; font-weight: 700;')}>Lumio</span></div>}
          {s.hasProg && <div style={css('display: flex; flex-direction: column; gap: 6px;')}><span style={css('display: flex; justify-content: space-between; font-size: 12.5px; color: var(--op-mut);')}><span>{s.progLabel}</span><span>{s.progRight}</span></span><span style={css('display: block; height: 6px; border-radius: 999px; background: var(--op-ink-a08); overflow: hidden;')}><span style={s.progFill} /></span></div>}
          {s.hasEyebrow && <span style={css('font-size: 12px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: var(--op-mut);')}>{s.eyebrow}</span>}
          <span style={css('font-family: var(--font-display); font-size: 25px; line-height: 1.25; font-weight: 600; text-wrap: balance;')}>{s.title}</span>
          {(s.lines || []).map((l: any, k: number) => <p key={k} style={l.st}>{l.t}</p>)}
          {(s.facts || []).map((f: any, k: number) => (
            <div key={k} style={css('border: 1px solid var(--op-line); border-radius: 16px; background: var(--op-sf); padding: 12px; display: flex; flex-direction: column; gap: 8px;')}>
              <span style={css('font-size: 15px; font-weight: 600; line-height: 1.45;')}>{f.t}</span>
              <div style={css('display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px;')}>{f.ch.map((c: any, j: number) => <button key={j} type="button" onClick={c.on} aria-pressed={c.sel} style={c.st}>{c.t}</button>)}</div>
            </div>
          ))}
          {s.hasTa && <Textarea size="open" value={s.ta} onChange={s.onTa} placeholder={s.taPh} aria-label="Your answer" />}
          {s.hasChips && <div style={css('display: flex; flex-wrap: wrap; gap: 8px;')}>{s.chips.map((c: any, k: number) => <button key={k} type="button" onClick={c.on} aria-pressed={c.sel} style={c.st}>{c.t}</button>)}</div>}
          {s.hasOpts && <div style={css('display: flex; flex-direction: column; gap: 8px;')}>{s.opts.map((c: any, k: number) => <button key={k} type="button" onClick={c.on} aria-pressed={c.sel} style={c.st}>{c.t}</button>)}</div>}
          {s.hasNotes && <div style={css('display: flex; flex-direction: column; gap: 10px;')}>{s.notes.map((n: any, k: number) => <div key={k} style={n.st}>{n.t}</div>)}</div>}
          {s.hasConsent && (
            <button type="button" onClick={s.onConsent} aria-pressed={s.consent} style={css('display: flex; align-items: flex-start; gap: 12px; min-height: 50px; border: 1px solid var(--op-line); border-radius: 14px; background: var(--op-sf); padding: 12px; cursor: pointer; font-family: inherit; text-align: left; color: var(--op-ink);')}>
              <Mark checked={s.consent} size={22} /><span style={css('font-size: 14px; line-height: 1.45;')}>{s.consentText}</span>
            </button>
          )}
          <div style={css('margin-top: auto; display: flex; flex-direction: column; gap: 8px; padding-top: 8px;')}>
            <Button size="lg" block onClick={s.primary.on} disabled={s.primary.dis}>{s.primary.t}</Button>
            {s.hasSecondary && <Button size="lg" tone="ghost" block onClick={s.secondary.on}>{s.secondary.t}</Button>}
            {s.hasFoot && <span style={css('text-align: center; font-size: 12px; color: var(--op-mut);')}>{s.foot}</span>}
          </div>
        </div>
      </div>
    </div>
  );
}
