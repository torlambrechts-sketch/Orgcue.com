'use client';
// "Become a beta user": adds the visitor to the beta list (public.beta_signups, insert-only for the anon role).
// Plain fetch to PostgREST keeps supabase-js out of the marketing bundle.
import { useState } from 'react';
import { fieldStyle } from '@/components/ds';

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';
const EMAIL = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
type State = { kind: 'idle' | 'sending' } | { kind: 'error'; msg: string } | { kind: 'done'; email: string; already: boolean };

export default function BetaSignup({ source }: { source: string }) {
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [company, setCompany] = useState('');
  const [consent, setConsent] = useState(false);
  const [trap, setTrap] = useState('');
  const [state, setState] = useState<State>({ kind: 'idle' });

  if (state.kind === 'done') {
    return (
      <div role="status" className="flex flex-col gap-1.5 rounded-[16px] border border-op-line bg-op-sf p-5">
        <strong className="font-display text-[20px] font-semibold">{state.already ? 'You’re already on the list.' : 'You’re on the beta list.'}</strong>
        <p className="m-0 text-[14.5px] leading-[1.55] text-op-body">We’ll write to <strong>{state.email}</strong> when your beta place opens, and with product updates until you unsubscribe.</p>
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

  const label = 'flex min-w-0 flex-col gap-1.5 text-[13px] font-semibold';
  const sending = state.kind === 'sending';
  return (
    <form onSubmit={submit} noValidate className="flex flex-col gap-3" aria-label="Join the beta list">
      <div className="grid gap-3 [grid-template-columns:repeat(auto-fit,minmax(200px,1fr))]">
        <label className={label}>Work email<input type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} style={fieldStyle('md')} /></label>
        <label className={label}><span>Name <span className="font-normal text-op-mut">(optional)</span></span><input name="name" autoComplete="name" maxLength={120} value={name} onChange={(e) => setName(e.target.value)} style={fieldStyle('md')} /></label>
        <label className={label}><span>Company <span className="font-normal text-op-mut">(optional)</span></span><input name="company" autoComplete="organization" maxLength={120} value={company} onChange={(e) => setCompany(e.target.value)} style={fieldStyle('md')} /></label>
      </div>
      <label aria-hidden="true" className="absolute left-[-10000px] h-px w-px overflow-hidden">Website<input tabIndex={-1} autoComplete="off" value={trap} onChange={(e) => setTrap(e.target.value)} /></label>
      <label className="flex items-start gap-2.5 text-[13.5px] leading-[1.5] text-op-body">
        <input type="checkbox" checked={consent} onChange={(e) => setConsent(e.target.checked)} className="mt-[3px] h-4 w-4 flex-none accent-[var(--op-ink)]" />
        <span>Add me to the Orgcue beta list. Email me about beta access and product updates. I can unsubscribe at any time.</span>
      </label>
      {state.kind === 'error' && <p role="alert" className="m-0 text-[13.5px] font-semibold text-[#8A3A16]">{state.msg}</p>}
      <span><button type="submit" disabled={sending} className="inline-flex h-11 cursor-pointer items-center justify-center whitespace-nowrap rounded-[12px] border border-op-ink bg-op-ac px-5 text-[14.5px] font-bold text-op-ink disabled:cursor-default disabled:opacity-55">{sending ? 'Adding you…' : 'Become a beta user'}</button></span>
    </form>
  );
}
