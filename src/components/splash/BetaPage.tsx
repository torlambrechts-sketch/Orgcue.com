// /beta: the private beta on a page of its own, in the splash design's language (hero type, glows, white card).
// Every "Become a beta user" button in the header lands here; the closing band of each page carries the same form.
import Link from 'next/link';
import { BetaCard, SplashFootLinks, SplashNav } from '@/components/splash/SplashChrome';

const GETS = [
  { t: 'An invite as places open', d: 'We start with teams that have a first AI project in mind: an assistant, an agent, a feature or a process.' },
  { t: 'Your own workspace', d: 'Brief, interviews, conflicts, a signed specification and the full handoff package, on your project.' },
  { t: 'A direct line to the team', d: 'Tell us what works and what doesn’t. Beta feedback decides what we build next.' },
];
const STEPS = [
  { n: '1', t: 'Join the list', d: 'Your work email, and a name and company if you like. No account, no card.' },
  { n: '2', t: 'Get your invite', d: 'We email you when your place opens, with a link to create your account.' },
  { n: '3', t: 'Create your account', d: 'Name, work email and a password. You’re in the workspace straight after.' },
];

export default function BetaPage() {
  return (
    <div style={{ minHeight: '100vh', fontSize: 15, lineHeight: 1.5, position: 'relative', overflow: 'clip' }}>
      <span aria-hidden="true" style={{ position: 'absolute', left: -180, top: -200, width: 760, height: 760, background: 'radial-gradient(closest-side,rgba(196,170,214,.5),rgba(196,170,214,0))', pointerEvents: 'none' }} />
      <span aria-hidden="true" style={{ position: 'absolute', right: -200, top: 360, width: 620, height: 620, background: 'radial-gradient(closest-side,rgba(251,214,170,.5),rgba(251,214,170,0))', pointerEvents: 'none' }} />
      <SplashNav active="beta" />

      <section style={{ position: 'relative', maxWidth: 1240, margin: '0 auto', padding: 'clamp(40px,6vw,80px) clamp(16px,3vw,40px) 24px', display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(min(100%,460px),1fr))', gap: 40, alignItems: 'center' }}>
        <div className="sp-pin" style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
          <span style={{ fontSize: 12, fontWeight: 700, letterSpacing: '.12em', color: '#4A1F3D' }}>PRIVATE BETA</span>
          <h1 style={{ margin: 0, fontFamily: 'var(--font-instrument),serif', fontWeight: 400, fontSize: 'clamp(42px,6vw,76px)', lineHeight: 0.98, letterSpacing: '-0.02em', textWrap: 'balance' }}>Get your organisation <i style={{ color: '#4A1F3D' }}>agreeing first.</i></h1>
          <p style={{ margin: 0, fontSize: 'clamp(16px,1.5vw,18px)', color: '#3A332D', maxWidth: 560, textWrap: 'pretty' }}>OrgCue is in private beta. Join the list and we’ll invite you to run a real project: interview the right people, decide where they disagree, and hand a traceable spec to your coding agent or chat assistant.</p>
          <ul style={{ margin: '6px 0 0', padding: 0, listStyle: 'none', display: 'flex', flexDirection: 'column', gap: 12 }}>
            {GETS.map((g) => (
              <li key={g.t} style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
                <span aria-hidden="true" style={{ flex: 'none', width: 24, height: 24, marginTop: 1, borderRadius: 999, background: '#4A1F3D', color: '#fff', fontSize: 12, fontWeight: 700, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>✓</span>
                <span style={{ display: 'flex', flexDirection: 'column' }}><b style={{ fontSize: 15 }}>{g.t}</b><span style={{ fontSize: 14, color: '#3A332D' }}>{g.d}</span></span>
              </li>
            ))}
          </ul>
        </div>
        <div id="beta" style={{ scrollMarginTop: 80 }}>
          <BetaCard source="beta" style={{ boxShadow: '0 30px 70px rgba(74,31,61,.16)', border: '1px solid #E7E1EA' }} />
        </div>
      </section>

      <section aria-labelledby="steps-h" style={{ position: 'relative', maxWidth: 1240, margin: '0 auto', padding: 'clamp(48px,7vw,88px) clamp(16px,3vw,40px) 24px', display: 'flex', flexDirection: 'column', gap: 28 }}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', gap: 10 }}>
          <span style={{ fontSize: 12, fontWeight: 700, letterSpacing: '.12em', color: '#4A1F3D' }}>FROM THE LIST TO YOUR FIRST PROJECT</span>
          <h2 id="steps-h" style={{ margin: 0, fontFamily: 'var(--font-instrument),serif', fontWeight: 400, fontSize: 'clamp(32px,4.2vw,52px)', lineHeight: 1, maxWidth: 760, textWrap: 'balance' }}>Three steps, then you’re building.</h2>
        </div>
        <ol style={{ margin: 0, padding: 0, listStyle: 'none', display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(min(100%,260px),1fr))', gap: 16 }}>
          {STEPS.map((s) => (
            <li key={s.n} style={{ background: '#fff', border: '1px solid #E7E1EA', borderRadius: 24, padding: 22, display: 'flex', flexDirection: 'column', gap: 10, boxShadow: '0 2px 6px rgba(31,26,23,.04)' }}>
              <span aria-hidden="true" style={{ width: 44, height: 44, borderRadius: 999, background: s.n === '3' ? '#F2B33D' : '#4A1F3D', color: s.n === '3' ? '#1F1A17' : '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--font-instrument),serif', fontSize: 22 }}>{s.n}</span>
              <span style={{ fontFamily: 'var(--font-instrument),serif', fontSize: 26, lineHeight: 1.05 }}>{s.t}</span>
              <span style={{ fontSize: 14, color: '#3A332D' }}>{s.d}</span>
            </li>
          ))}
        </ol>
        <p style={{ margin: 0, textAlign: 'center', fontSize: 15, color: '#3A332D' }}>
          Already invited? <Link href="/signup" style={{ fontWeight: 700 }}>Create your account →</Link> · Have one? <Link href="/login" style={{ fontWeight: 700 }}>Log in</Link>
        </p>
      </section>

      <div style={{ height: 56 }} />
      <SplashFootLinks />
    </div>
  );
}
