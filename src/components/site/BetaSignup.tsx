'use client';
// "Become a beta user": adds the visitor to the beta list (public.beta_signups, insert-only for the anon role).
// Plain fetch to PostgREST keeps supabase-js out of the public pages' bundle. Styled for the splash design.
import { useState } from 'react';

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';
const EMAIL = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
type State = { kind: 'idle' | 'sending' } | { kind: 'error'; msg: string } | { kind: 'done'; email: string; already: boolean };

const field: React.CSSProperties = { boxSizing: 'border-box', height: 44, width: '100%', minWidth: 0, borderRadius: 10, border: '1px solid #DCD3DE', background: '#FBF9F7', padding: '0 13px', fontSize: 15, color: '#1F1A17', fontFamily: 'inherit', outline: 'none', transition: 'border-color .2s ease-in-out, box-shadow .2s ease-in-out' };
const label: React.CSSProperties = { display: 'flex', flexDirection: 'column', gap: 6, minWidth: 0, fontSize: 13, fontWeight: 600, color: '#3A332D' };
const optional = <span style={{ fontWeight: 400, color: '#6E665D' }}>(optional)</span>;

export default function BetaSignup({ source }: { source: string }) {
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [company, setCompany] = useState('');
  const [consent, setConsent] = useState(false);
  const [trap, setTrap] = useState('');
  const [state, setState] = useState<State>({ kind: 'idle' });

  if (state.kind === 'done') {
    return (
      <div role="status" style={{ display: 'flex', flexDirection: 'column', gap: 6, padding: '16px 18px', borderRadius: 14, background: '#E3F2F0', color: '#1F1A17' }}>
        <strong style={{ fontFamily: 'var(--font-instrument),serif', fontWeight: 400, fontSize: 24, lineHeight: 1.1 }}>{state.already ? 'You’re already on the list.' : 'You’re on the beta list.'}</strong>
        <span style={{ fontSize: 14, lineHeight: 1.5, color: '#3A332D' }}>We’ll write to <b>{state.email}</b> when your beta place opens, and with product updates until you unsubscribe.</span>
      </div>
    );
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    const addr = email.trim();
    if (!EMAIL.test(addr)) return setState({ kind: 'error', msg: 'Enter your full email address, like name@company.com.' });
    if (!consent) return setState({ kind: 'error', msg: 'Tick the box so we may email you about the beta.' });
    if (trap) return setState({ kind: 'done', email: addr, already: false });
    setState({ kind: 'sending' });
    try {
      const res = await fetch(SUPABASE_URL + '/rest/v1/beta_signups', {
        method: 'POST',
        headers: { apikey: SUPABASE_ANON_KEY, Authorization: 'Bearer ' + SUPABASE_ANON_KEY, 'Content-Type': 'application/json', Prefer: 'return=minimal' },
        body: JSON.stringify({ email: addr, name: name.trim() || null, company: company.trim() || null, consent: true, source }),
      });
      if (res.ok) return setState({ kind: 'done', email: addr, already: false });
      const body = await res.json().catch(() => ({}));
      if (body && body.code === '23505') return setState({ kind: 'done', email: addr, already: true });
      setState({ kind: 'error', msg: 'That didn’t go through. Check the address and try again.' });
    } catch {
      setState({ kind: 'error', msg: 'We couldn’t reach the server. Check your connection and try again.' });
    }
  }

  const sending = state.kind === 'sending';
  return (
    <form onSubmit={submit} noValidate aria-label="Join the beta list" style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <label style={label}>Work email<input className="sp-field" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} style={field} /></label>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(min(100%,160px),1fr))', gap: 12 }}>
        <label style={label}><span>Name {optional}</span><input className="sp-field" name="name" autoComplete="name" maxLength={120} value={name} onChange={(e) => setName(e.target.value)} style={field} /></label>
        <label style={label}><span>Company {optional}</span><input className="sp-field" name="company" autoComplete="organization" maxLength={120} value={company} onChange={(e) => setCompany(e.target.value)} style={field} /></label>
      </div>
      <label aria-hidden="true" style={{ position: 'absolute', left: -10000, width: 1, height: 1, overflow: 'hidden' }}>Website<input tabIndex={-1} autoComplete="off" value={trap} onChange={(e) => setTrap(e.target.value)} /></label>
      <label style={{ display: 'flex', alignItems: 'flex-start', gap: 10, fontSize: 13.5, lineHeight: 1.5, color: '#3A332D', cursor: 'pointer' }}>
        <input type="checkbox" checked={consent} onChange={(e) => setConsent(e.target.checked)} style={{ marginTop: 3, width: 16, height: 16, flex: 'none', accentColor: '#4A1F3D' }} />
        <span>Add me to the OrgCue beta list. Email me about beta access and product updates. I can unsubscribe at any time.</span>
      </label>
      {state.kind === 'error' && <p role="alert" style={{ margin: 0, fontSize: 13.5, fontWeight: 600, color: '#A23A22' }}>{state.msg}</p>}
      <button type="submit" disabled={sending} className="sp-lift" style={{ alignSelf: 'flex-start', whiteSpace: 'nowrap', height: 48, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', padding: '0 22px', borderRadius: 10, border: 0, background: '#F2B33D', color: '#1F1A17', fontSize: 15, fontWeight: 700, fontFamily: 'inherit', cursor: sending ? 'default' : 'pointer', opacity: sending ? 0.6 : 1, boxShadow: '0 14px 30px rgba(242,179,61,.25)', transition: 'transform .2s ease-in-out' }}>
        {sending ? 'Adding you…' : 'Become a beta user'}
      </button>
    </form>
  );
}
