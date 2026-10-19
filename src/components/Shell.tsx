/* eslint-disable @typescript-eslint/no-explicit-any */
// App shell, ported from design/design_handoff_orgcue/prototype/Orgcue.dc.html: demo control bar (dev flag),
// top bar, collapsible sidebar (localStorage['orgcue-navC']), fluid main panel, router and toast.
'use client';
import React, { useEffect, useState, useSyncExternalStore } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { K } from '@/oc/kit';
import { getD, load, resetDemo, status } from '@/oc/db';
import { Button, Input } from './ds';
import { css } from './Blocks';
import { PagesScreen, PhoneScreen, ProjectScreen, SettingsScreen, WizardScreen } from './Screens';

const DEMO_BAR = process.env.NEXT_PUBLIC_DEMO_BAR !== '0';

function useOc() { return useSyncExternalStore(K.store.subscribe, K.store.getState, K.store.getState) as any; }
const NARROW = '(max-width: 720px)';
const subNarrow = (cb: () => void) => { const m = window.matchMedia(NARROW); m.addEventListener('change', cb); return () => m.removeEventListener('change', cb); };
/** Phone-width screens always get the 72px rail, so the main panel keeps its room. */
function useNarrow() { return useSyncExternalStore(subNarrow, () => window.matchMedia(NARROW).matches, () => false); }

export default function Shell() {
  const router = useRouter();
  const pathname = usePathname() || '/home';
  const path = pathname === '/' ? '/home' : pathname;
  const S = useOc();
  const narrow = useNarrow();
  const [ready, setReady] = useState(false);

  useEffect(() => { K.router = router; }, [router]);
  useEffect(() => {
    K.initLS();
    load().then((hyd: any) => { K._hydrating = true; K.store.setState(hyd || {}); K._hydrating = false; setReady(true); })
      .catch((e: any) => { console.error(e); status.error = String(e && e.message || e); setReady(true); });
  }, []);
  useEffect(() => { if (pathname === '/') router.replace('/home'); }, [pathname, router]);

  const D: any = getD();
  if (!ready || !D) return <div style={css('min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--op-bg); color: var(--op-mut); font-size: 13.5px;')}>Loading Lumio Inc. …</div>;

  const c = S.navC || narrow, role = S.role;
  const seg = (sel: boolean): React.CSSProperties => ({ cursor: 'pointer', border: 'none', borderRadius: 7, padding: '4px 9px', fontFamily: 'inherit', fontSize: 12, fontWeight: sel ? 700 : 500, background: sel ? 'var(--op-ac)' : 'transparent', color: sel ? 'var(--op-ink)' : 'var(--op-bg)' });
  const me = D.people[K.who()];
  const top = path.split('/')[1] || 'home';
  const items = [['home', 'Home', '⌂', '/home'], ['projects', 'Projects', '▦', '/projects'], ['templates', 'Templates', '❐', '/templates'], ['library', 'Library', '▤', '/library'], ['portfolio', 'Portfolio', '▥', '/portfolio'], ['settings', 'Settings', '≡', '/settings']].filter((n) => !(n[0] === 'portfolio' && role === 'contributor'));
  const cur = top === 'p' ? 'projects' : top;
  const pid = top === 'p' ? path.split('/')[2] : '';
  const isPages = ['home', 'projects', 'templates', 'library', 'portfolio'].includes(top) && path.split('/').length <= 2;
  const isProject = top === 'p', isSettings = top === 'settings', isPhone = top === 'phone' || top === 'customer';
  const isMissing = !isPages && !isProject && !isSettings && !isPhone;
  const toggleNav = () => { try { localStorage.setItem('orgcue-navC', JSON.stringify(!c)); } catch { /* storage blocked */ } K.set({ navC: !c }); };
  const sideSt: React.CSSProperties = { width: c ? 72 : 240, flex: 'none', boxSizing: 'border-box', display: 'flex', flexDirection: 'column', alignItems: c ? 'center' : 'stretch', gap: 8, padding: '6px 10px 14px', overflowX: 'hidden', overflowY: 'auto', transition: 'width 180ms ease-in-out', position: 'sticky', top: 0, maxHeight: '100vh' };
  const allTrack: React.CSSProperties = { position: 'relative', width: 30, height: 17, borderRadius: 999, background: S.all ? 'var(--op-ac)' : 'rgba(252,246,233,.3)' };
  const allKnob: React.CSSProperties = { position: 'absolute', top: 2, left: S.all ? 15 : 2, width: 13, height: 13, borderRadius: 999, background: 'var(--op-sf)', transition: 'left 150ms' };

  return (
    <div style={css('min-height: 100vh; display: flex; flex-direction: column; background: var(--op-bg);')}>
      {DEMO_BAR && (
        <div style={css('display: flex; flex-wrap: wrap; align-items: center; gap: 8px 18px; background: var(--op-ink); color: var(--op-bg); padding: 7px 16px; font-size: 12.5px;')}>
          <span style={css('font-weight: 700; letter-spacing: .08em; text-transform: uppercase; font-size: 10.5px; opacity: .8;')}>Demo controls · dev only</span>
          <span style={css('display: flex; align-items: center; gap: 6px;')}>View as
            <span style={css('display: flex; gap: 2px; border-radius: 9px; background: rgba(252,246,233,.12); padding: 2px;')}>
              {[['owner', 'Owner'], ['decider', 'Decider'], ['contributor', 'Contributor'], ['admin', 'Org admin']].map(([k, t]) => <button key={k} type="button" onClick={() => K.set({ role: k })} aria-pressed={role === k} style={seg(role === k)}>{t}</button>)}
            </span>
          </span>
          <span style={css('display: flex; align-items: center; gap: 6px;')}>Phase
            <span style={css('display: flex; gap: 2px; border-radius: 9px; background: rgba(252,246,233,.12); padding: 2px;')}>
              {K.PH.map((p: string) => <button key={p} type="button" onClick={() => K.set({ phase: p })} aria-pressed={S.phase === p} style={seg(S.phase === p)}>{p}</button>)}
            </span>
          </span>
          <button type="button" onClick={() => K.set({ all: !S.all })} aria-pressed={S.all} style={css('display: flex; align-items: center; gap: 8px; border: none; background: transparent; color: var(--op-bg); cursor: pointer; font-family: inherit; font-size: 12.5px;')}><span style={allTrack}><span style={allKnob} /></span>Show all features</button>
          <span style={css('margin-left: auto; display: flex; gap: 14px;')}>
            <Link href="/phone" style={css('color: var(--op-ac); font-weight: 700;')}>Phone flow</Link>
            <Link href="/customer" style={css('color: var(--op-ac); font-weight: 700;')}>Customer page</Link>
            {status.online && <button type="button" onClick={() => { if (window.confirm('Reset the demo? Every change in Supabase goes back to the Lumio Inc. seed.')) resetDemo(); }} style={css('border: none; background: transparent; padding: 0; cursor: pointer; font-family: inherit; font-size: 12.5px; color: var(--op-bg); font-weight: 600; opacity: .8;')}>Reset demo</button>}
          </span>
        </div>
      )}
      {status.error && <div role="status" style={css('background: var(--op-band); color: var(--op-cautiondeep); padding: 6px 16px; font-size: 12.5px;')}>{status.error}</div>}
      <header style={css('display: flex; align-items: center; gap: 14px; padding: 10px 16px; background: var(--op-bg);')}>
        <Link href="/home" style={css('display: flex; align-items: center; gap: 10px; color: var(--op-ink); text-decoration: none; flex: none;')}>
          <span style={css('display: flex; width: 32px; height: 32px; align-items: center; justify-content: center; border-radius: 9px; background: var(--op-ink); color: var(--op-bg); font-family: var(--font-display); font-size: 17px; font-weight: 600;')}>O</span>
          <span style={css('font-family: var(--font-display); font-size: 20px; font-weight: 600;')}>Orgcue</span>
          <span className="oc-hide-sm" style={css('font-size: 13px; color: var(--op-mut);')}>Lumio Inc.</span>
        </Link>
        <span className="oc-search" style={css('flex: 1; display: flex; justify-content: center; min-width: 0;')}><Input size="field" placeholder="Search everything" aria-label="Search everything" style={{ width: '100%', maxWidth: 420 }} onChange={() => {}} /></span>
        <button type="button" aria-label="Help and notifications" onClick={() => K.toast('2 new: Daniel asked about DEC-06 · A-016 waiting for Sam')} style={css('width: 36px; height: 36px; flex: none; cursor: pointer; border-radius: 999px; border: 1px solid var(--op-line); background: var(--op-sf); font-family: inherit; font-size: 14px; font-weight: 700; color: var(--op-ink);')}>?</button>
        {(role === 'owner' || role === 'admin') && <Button size="sm" onClick={() => K.set({ wiz: { step: 0 } })}><span style={css('white-space: nowrap;')}>＋ New project</span></Button>}
        <span title={me.name} style={css('display: flex; width: 34px; height: 34px; flex: none; align-items: center; justify-content: center; border-radius: 999px; background: var(--op-ink); color: var(--op-bg); font-size: 12px; font-weight: 700;')}>{me.ini}</span>
      </header>
      <div style={css('flex: 1; display: flex; min-height: 0;')}>
        <aside style={sideSt}>
          {!narrow && <button type="button" onClick={toggleNav} aria-label={c ? 'Expand sidebar' : 'Collapse sidebar'} style={css('align-self: flex-start; height: 30px; min-width: 30px; cursor: pointer; border: 1px solid var(--op-line); border-radius: 8px; background: var(--op-sf); font-family: inherit; font-size: 14px; color: var(--op-ink);')}>{c ? '»' : '«'}</button>}
          <nav aria-label="Main" style={css('display: flex; flex-direction: column; gap: 3px;')}>
            {items.map(([k, t, icon, p]) => { const sel = k === cur; return (
              <Link key={k} href={p} aria-current={sel ? 'page' : undefined} title={t}
                style={c ? { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3, width: 52, padding: '6px 0', borderRadius: 10, textDecoration: 'none', color: sel ? 'var(--op-ink)' : 'var(--op-body)', background: sel ? 'var(--op-sbg)' : 'transparent' } : { display: 'flex', alignItems: 'center', gap: 10, padding: '7px 10px', borderRadius: 10, textDecoration: 'none', color: 'var(--op-ink)', background: sel ? 'var(--op-sbg)' : 'transparent', fontWeight: sel ? 700 : 500, fontSize: 14 }}>
                <span aria-hidden="true" style={{ display: 'flex', width: 26, height: 26, flex: 'none', alignItems: 'center', justifyContent: 'center', borderRadius: 8, fontSize: 14, background: sel ? 'var(--op-ac)' : 'var(--op-track)' }}>{icon}</span>
                <span style={c ? { fontSize: 10, fontWeight: sel ? 700 : 500 } : { flex: 1 }}>{t}</span>
              </Link>); })}
          </nav>
          <span style={css('display: block; height: 1px; background: var(--op-line); margin: 4px 0;')} />
          {!c && <span style={css('padding: 0 10px; font-size: 10.5px; font-weight: 700; letter-spacing: .09em; text-transform: uppercase; color: var(--op-mut);')}>Projects</span>}
          <div style={css('display: flex; flex-direction: column; gap: 2px;')}>
            {D.projects.map((p: any) => (
              <Link key={p.id} href={'/p/' + p.id + '/overview'} title={p.name}
                style={{ display: 'flex', alignItems: 'center', gap: 9, padding: c ? '6px 0' : '6px 10px', justifyContent: c ? 'center' : 'flex-start', borderRadius: 10, textDecoration: 'none', color: 'var(--op-ink)', background: p.id === pid ? 'var(--op-sbg)' : 'transparent' }}>
                <span style={{ width: 14, height: 14, flex: 'none', borderRadius: 4, background: p.color, border: '1px solid var(--op-rule)', boxSizing: 'border-box' }} />
                {!c && <span style={css('min-width: 0; flex: 1;')}><span style={css('display: block; font-size: 13px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;')}>{p.name}</span><span style={css('display: block; font-size: 11.5px; color: var(--op-mut);')}>{p.id === 'it-helpdesk' ? S.phase : p.phase}</span></span>}
              </Link>
            ))}
          </div>
          <span style={css('margin-top: auto; display: flex; align-items: center; gap: 8px; border-top: 1px solid var(--op-line); padding: 12px 6px 0;')}>
            <span style={css('display: flex; width: 30px; height: 30px; flex: none; align-items: center; justify-content: center; border-radius: 999px; background: var(--op-ink); color: var(--op-bg); font-size: 11px; font-weight: 700;')}>{me.ini}</span>
            {!c && <span style={css('min-width: 0; font-size: 12px; line-height: 1.4;')}><span style={css('display: block; font-weight: 700; color: var(--op-ink);')}>{me.name}</span><span style={css('display: block; color: var(--op-mut);')}>Data region: US</span></span>}
          </span>
        </aside>
        <main className="oc-main" style={css('flex: 1; min-width: 0; margin: 0 8px 8px 0; border: 1px solid var(--op-line); border-radius: 14px; background: var(--op-sf); padding: 22px 28px; box-sizing: border-box;')}>
          <div key={path} className="animate-entry">
            {isPages && <PagesScreen path={path} />}
            {isProject && <ProjectScreen path={path} />}
            {isSettings && <SettingsScreen path={path} />}
            {isPhone && <PhoneScreen path={path} />}
            {isMissing && (
              <div style={css('max-width: 560px; padding: 40px 0; display: flex; flex-direction: column; gap: 10px;')}>
                <span style={css('font-family: var(--font-display); font-size: 26px; font-weight: 600;')}>This page doesn’t exist.</span>
                <span style={css('color: var(--op-mut);')}>{path}</span>
                <Link href="/home">Go to Home →</Link>
              </div>
            )}
          </div>
        </main>
      </div>
      <WizardScreen />
      {S.toast && <div role="status" style={css('position: fixed; z-index: 90; left: 50%; bottom: 24px; transform: translateX(-50%); border-radius: 12px; background: var(--op-ink); color: var(--op-bg); padding: 11px 18px; font-size: 13.5px; box-shadow: 0 18px 40px -24px rgba(25,21,16,.45);')}>{S.toast}</div>}
    </div>
  );
}
