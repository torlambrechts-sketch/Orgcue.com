// Header and closing band of the public site, from design/splash-handoff/.../Splash/SplashNav.dc.html and SplashFooter.dc.html.
// "Open the app" / "Open the CRM example" became the beta list: every page ends with the form (#beta).
/* eslint-disable @next/next/no-img-element */
import Link from 'next/link';
import BetaSignup from '@/components/site/BetaSignup';

export const SPLASH_LINKS = [
  { k: 'home', l: 'Home', href: '/' },
  { k: 'plan', l: 'Plan', href: '/plan' },
  { k: 'collect', l: 'Collect', href: '/collect' },
  { k: 'decide', l: 'Decide', href: '/decide' },
  { k: 'deliver', l: 'Deliver', href: '/deliver' },
  { k: 'platform', l: 'Platform', href: '/platform' },
] as const;

export type SplashKey = (typeof SPLASH_LINKS)[number]['k'];

const FONT = 'var(--font-figtree),system-ui,sans-serif';

export function SplashNav({ active = 'home', dark = false }: { active?: SplashKey; dark?: boolean }) {
  const dk = dark;
  const ink = dk ? '#fff' : '#1F1A17';
  const hov = dk ? 'rgba(255,255,255,.1)' : '#F3EDF4';
  return (
    <header style={{ position: 'sticky', top: 0, zIndex: 20, padding: '14px clamp(16px,3vw,40px)', background: dk ? 'transparent' : 'linear-gradient(180deg,rgba(247,245,242,.96),rgba(247,245,242,.6))', backdropFilter: dk ? 'none' : 'blur(10px)', fontFamily: FONT }}>
      <div style={{ maxWidth: 1240, margin: '0 auto', display: 'flex', alignItems: 'center', gap: 16, flexWrap: 'wrap' }}>
        <Link href="/" style={{ display: 'flex', alignItems: 'center', gap: 10, textDecoration: 'none', color: ink }}>
          <img src="/orgcue-mark.svg" alt="" width={34} height={34} style={{ display: 'block', borderRadius: 9, boxShadow: dk ? '0 0 0 1.5px rgba(255,255,255,.3)' : 'none' }} />
          <span style={{ display: 'flex', flexDirection: 'column', lineHeight: 1 }}>
            <span style={{ fontSize: 19, fontWeight: 700, letterSpacing: '-0.015em' }}>Org<span style={{ color: dk ? '#F2B33D' : '#4A1F3D' }}>Cue</span></span>
            <span style={{ fontSize: 10.5, color: dk ? 'rgba(255,255,255,.6)' : '#6E665D', letterSpacing: '.04em', marginTop: 2 }}>orgcue.com</span>
          </span>
        </Link>
        <span style={{ flex: 1 }} />
        <nav aria-label="Site" style={{ display: 'flex', gap: 2, padding: 4, borderRadius: 999, background: dk ? 'rgba(255,255,255,.06)' : '#fff', border: '1px solid ' + (dk ? 'rgba(255,255,255,.14)' : '#E7E1EA'), boxShadow: '0 6px 20px rgba(74,31,61,.06)', flexWrap: 'wrap' }}>
          {SPLASH_LINKS.map((l) => {
            const on = l.k === active;
            return (
              <Link key={l.k} href={l.href} aria-current={on ? 'page' : undefined} className={on ? undefined : 'sp-navlink'}
                style={{ whiteSpace: 'nowrap', padding: '8px 14px', borderRadius: 999, fontSize: 13.5, fontWeight: 600, textDecoration: 'none', background: on ? (dk ? '#fff' : '#1F1A17') : 'transparent', color: on ? (dk ? '#2A1224' : '#fff') : (dk ? 'rgba(255,255,255,.85)' : '#3A332D'), transition: 'background .2s ease-in-out', ['--sp-hov' as string]: hov }}>
                {l.l}
              </Link>
            );
          })}
        </nav>
        <span style={{ flex: 1 }} />
        <a href="#beta" className="sp-lift" style={{ whiteSpace: 'nowrap', height: 40, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 8, padding: '0 18px', borderRadius: 999, background: dk ? '#F2B33D' : '#1F1A17', color: dk ? '#1F1A17' : '#fff', fontSize: 14, fontWeight: 600, textDecoration: 'none', boxShadow: '0 10px 24px rgba(31,26,23,.18)', transition: 'transform .2s ease-in-out' }}>Become a beta user →</a>
      </div>
    </header>
  );
}

export function SplashFooter({ eyebrow = 'SEE IT WORK', title, sub, nextHref, nextL, source }: { eyebrow?: string; title: string; sub?: string; nextHref: string; nextL: string; source: string }) {
  return (
    <div style={{ fontFamily: FONT }}>
      <section id="beta" aria-labelledby="beta-h" style={{ maxWidth: 1240, margin: '0 auto', padding: '24px clamp(16px,3vw,40px) 56px', scrollMarginTop: 80 }}>
        <div style={{ position: 'relative', overflow: 'hidden', borderRadius: 28, background: '#2A1224', color: '#fff', padding: 'clamp(28px,5vw,56px)', display: 'flex', gap: 28, alignItems: 'center', flexWrap: 'wrap', boxShadow: '0 40px 90px rgba(42,18,36,.28)' }}>
          <span aria-hidden="true" style={{ position: 'absolute', right: -120, top: -120, width: 420, height: 420, borderRadius: 999, background: 'radial-gradient(circle,rgba(242,179,61,.35),transparent 65%)' }} />
          <span aria-hidden="true" style={{ position: 'absolute', left: -80, bottom: -160, width: 380, height: 380, borderRadius: 999, background: 'radial-gradient(circle,rgba(156,107,142,.45),transparent 65%)' }} />
          <span style={{ position: 'relative', flex: '1 1 420px', display: 'flex', flexDirection: 'column', gap: 10 }}>
            <span style={{ fontSize: 12, fontWeight: 700, letterSpacing: '.12em', color: '#F2B33D' }}>{eyebrow}</span>
            <h2 id="beta-h" style={{ margin: 0, fontWeight: 400, fontFamily: 'var(--font-instrument),serif', fontSize: 'clamp(32px,4vw,52px)', lineHeight: 1.02, letterSpacing: '-0.01em', textWrap: 'balance' }}>{title}</h2>
            {sub && <span style={{ fontSize: 15.5, opacity: 0.8, maxWidth: 560, textWrap: 'pretty' }}>{sub}</span>}
            <span style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginTop: 8 }}>
              <Link href={nextHref} className="sp-ghost" style={{ whiteSpace: 'nowrap', height: 48, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', padding: '0 22px', borderRadius: 999, border: '1px solid rgba(255,255,255,.3)', color: '#fff', fontSize: 15, fontWeight: 600, textDecoration: 'none', transition: 'background .2s ease-in-out' }}>{nextL}</Link>
            </span>
          </span>
          <div style={{ position: 'relative', flex: '1 1 380px', minWidth: 0, background: '#fff', color: '#1F1A17', borderRadius: 20, padding: 'clamp(18px,2.4vw,26px)', boxShadow: '0 30px 60px rgba(0,0,0,.25)', display: 'flex', flexDirection: 'column', gap: 12 }}>
            <span style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
              <span style={{ fontSize: 11, fontWeight: 700, letterSpacing: '.1em', color: '#4A1F3D' }}>PRIVATE BETA</span>
              <span style={{ fontFamily: 'var(--font-instrument),serif', fontSize: 28, lineHeight: 1.05 }}>Become a beta user.</span>
              <span style={{ fontSize: 13.5, color: '#3A332D' }}>Join the list and we’ll invite you as places open. No account needed.</span>
            </span>
            <BetaSignup source={source} />
          </div>
        </div>
      </section>
      <footer style={{ borderTop: '1px solid #E7E1EA' }}>
        <div style={{ maxWidth: 1240, margin: '0 auto', padding: '24px clamp(16px,3vw,40px)', display: 'flex', gap: 18, flexWrap: 'wrap', fontSize: 13, color: '#6E665D', alignItems: 'center' }}>
          <img src="/orgcue-mark.svg" alt="" width={22} height={22} style={{ display: 'block', borderRadius: 6 }} />
          <span style={{ fontWeight: 700, color: '#1F1A17' }}>OrgCue</span>
          <span>orgcue.com · private beta</span>
          <span style={{ flex: 1 }} />
          <nav aria-label="Footer" style={{ display: 'flex', gap: 18, flexWrap: 'wrap' }}>
            {SPLASH_LINKS.map((l) => <Link key={l.k} href={l.href} style={{ color: '#4A1F3D', textDecoration: 'none' }}>{l.l}</Link>)}
            <Link href="/login" style={{ color: '#4A1F3D', textDecoration: 'none' }}>Log in</Link>
          </nav>
        </div>
      </footer>
    </div>
  );
}
