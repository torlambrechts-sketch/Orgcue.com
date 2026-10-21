'use client';
// Sign-up, log-in and password screens. Orgpuls look: cream canvas, one hairline card, Playfair heading,
// 48px sign-in fields with a 1.5px ink border, one saffron primary action per screen.
import React, { useState } from 'react';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import type { AuthError } from '@supabase/supabase-js';
import { supabaseBrowser } from '@/lib/supabase/client';
import { safeNext } from '@/lib/auth-paths';
import { Button, Input } from '@/components/ds';
import { css } from '@/components/Blocks';

const MIN_PASSWORD = 8;

export function AuthFrame({ eyebrow, title, lead, children, foot }: { eyebrow?: string; title: string; lead?: React.ReactNode; children: React.ReactNode; foot?: React.ReactNode }) {
  return (
    <div style={css('min-height: 100vh; display: flex; flex-direction: column; background: var(--op-bg); color: var(--op-ink);')}>
      <header style={css('display: flex; align-items: center; padding: 16px 20px;')}>
        <Link href="/" aria-label="Orgcue home" style={css('display: flex; align-items: center; gap: 10px; color: var(--op-ink); text-decoration: none;')}>
          <span style={css('display: flex; width: 32px; height: 32px; align-items: center; justify-content: center; border-radius: 9px; background: var(--op-ink); color: var(--op-bg); font-family: var(--font-display); font-size: 17px; font-weight: 600;')}>O</span>
          <span style={css('font-family: var(--font-display); font-size: 20px; font-weight: 600;')}>Orgcue</span>
        </Link>
      </header>
      <main className="animate-entry" style={css('flex: 1; display: flex; flex-direction: column; align-items: center; padding: 24px 16px 48px;')}>
        <div style={css('width: 100%; max-width: 420px; display: flex; flex-direction: column; gap: 18px; border: 1px solid var(--op-line); border-radius: 20px; background: var(--op-sf); padding: 26px; box-sizing: border-box;')}>
          <span style={css('display: flex; flex-direction: column; gap: 6px;')}>
            {eyebrow && <span style={css('font-size: 11px; font-weight: 700; letter-spacing: .11em; text-transform: uppercase; color: var(--op-mut);')}>{eyebrow}</span>}
            <h1 style={css('margin: 0; font-family: var(--font-display); font-size: 26px; line-height: 1.2; font-weight: 600; text-wrap: balance;')}>{title}</h1>
            {lead && <p style={css('margin: 0; font-size: 14.5px; line-height: 1.55; color: var(--op-body); text-wrap: pretty;')}>{lead}</p>}
          </span>
          {children}
        </div>
        {foot && <div style={css('margin-top: 16px; font-size: 13.5px; color: var(--op-mut); text-align: center;')}>{foot}</div>}
        <p style={css('margin: 22px 0 0; max-width: 420px; font-size: 12px; line-height: 1.5; color: var(--op-mut); text-align: center;')}>Data region: US · Answers stay private until collection closes.</p>
      </main>
    </div>
  );
}

export function Field({ label, help, value, onChange, ...input }: { label: string; help?: string } & Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size' | 'style'>) {
  return (
    <label style={css('display: flex; flex-direction: column; gap: 6px; min-width: 0;')}>
      <span style={css('font-size: 13px; font-weight: 600;')}>{label}</span>
      <Input size="signin" value={value as string} onChange={onChange as never} {...input} />
      {help && <span style={css('font-size: 12px; color: var(--op-mut);')}>{help}</span>}
    </label>
  );
}

export function Notice({ tone = 'info', children }: { tone?: 'info' | 'error' | 'ok'; children: React.ReactNode }) {
  const c = { info: ['var(--op-track)', 'var(--op-ink)'], error: ['var(--op-peach)', 'var(--op-dangerdeep)'], ok: ['var(--op-mint)', 'var(--op-greendeep)'] }[tone];
  return <div role={tone === 'error' ? 'alert' : 'status'} style={{ borderRadius: 12, padding: '10px 13px', fontSize: 13.5, lineHeight: 1.5, background: c[0], color: c[1] }}>{children}</div>;
}

const form = css('display: flex; flex-direction: column; gap: 14px; margin: 0;');
const linkBtn = css('border: none; background: transparent; padding: 0; cursor: pointer; font-family: inherit; font-size: 13.5px; font-weight: 600; color: var(--op-link); text-align: left;');

function message(e: AuthError | null, fallback = 'Something went wrong. Try again in a moment.') {
  if (!e) return '';
  const code = (e as AuthError & { code?: string }).code || '';
  if (code === 'invalid_credentials' || /invalid login credentials/i.test(e.message)) return 'That email and password don’t match an account.';
  if (code === 'user_already_exists' || /already registered/i.test(e.message)) return 'An account with this email already exists. Log in instead.';
  if (code === 'weak_password') return 'Choose a stronger password: at least ' + MIN_PASSWORD + ' characters, not a common one.';
  if (code.startsWith('over_') || e.status === 429) return 'Too many attempts. Wait a minute and try again.';
  if (code === 'signup_disabled') return 'Sign-up is turned off for this workspace. Ask Jordan Lee for an invite.';
  if (code === 'email_address_invalid') return 'That email address can’t receive mail. Check it and try again.';
  return e.message || fallback;
}
const origin = () => window.location.origin;

/** Sends the "confirm your email" link again. */
function ResendLink({ email }: { email: string }) {
  const [state, setState] = useState<'' | 'sending' | 'sent' | string>('');
  const resend = async () => {
    setState('sending');
    const { error } = await supabaseBrowser().auth.resend({ type: 'signup', email, options: { emailRedirectTo: origin() + '/auth/callback?next=/home' } });
    setState(error ? message(error) : 'sent');
  };
  if (state === 'sent') return <span style={css('font-size: 13.5px; color: var(--op-greendeep);')}>✓ Sent again. Check your inbox and spam folder.</span>;
  return <span style={css('display: flex; flex-direction: column; gap: 6px;')}>
    <button type="button" onClick={resend} disabled={state === 'sending'} style={linkBtn}>{state === 'sending' ? 'Sending …' : 'Send the link again'}</button>
    {state && state !== 'sending' && <span style={css('font-size: 12.5px; color: var(--op-dangerdeep);')}>{state}</span>}
  </span>;
}

export function LoginForm() {
  const params = useSearchParams();
  const next = safeNext(params.get('next'));
  const linkError = params.get('error');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [unconfirmed, setUnconfirmed] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setBusy(true); setError(''); setUnconfirmed(false);
    const { error: err } = await supabaseBrowser().auth.signInWithPassword({ email: email.trim(), password });
    if (err) {
      const code = (err as AuthError & { code?: string }).code;
      if (code === 'email_not_confirmed' || /email not confirmed/i.test(err.message)) setUnconfirmed(true); else setError(message(err));
      setBusy(false);
      return;
    }
    window.location.assign(next); // full load, so the middleware and the app start from the new session
  };

  return (
    <AuthFrame eyebrow="Orgcue" title="Log in" lead="Use the email and password you signed up with."
      foot={<>New to Orgcue? <Link href={'/signup' + (next !== '/home' ? '?next=' + encodeURIComponent(next) : '')} style={css('font-weight: 700;')}>Create an account</Link></>}>
      {linkError && <Notice>{linkError === 'expired' ? 'That link has expired or was already used. Log in, or ask for a new one.' : 'We couldn’t finish signing you in from that link. If you just confirmed your email, log in below.'}</Notice>}
      {error && <Notice tone="error">{error}</Notice>}
      {unconfirmed && <Notice tone="error"><span style={css('display: flex; flex-direction: column; gap: 6px;')}>Confirm your email first. We sent a link to {email.trim()}.<ResendLink email={email.trim()} /></span></Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="Email" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        <Field label="Password" type="password" name="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        <Link href="/forgot-password" style={css('align-self: flex-start; font-size: 13.5px; font-weight: 600;')}>Forgot your password?</Link>
        <Button type="submit" size="lg" block disabled={busy || !email.trim() || !password}>{busy ? 'Logging in …' : 'Log in'}</Button>
      </form>
    </AuthFrame>
  );
}

export function SignupForm() {
  const params = useSearchParams();
  const next = safeNext(params.get('next'));
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [sentTo, setSentTo] = useState('');
  const short = password.length > 0 && password.length < MIN_PASSWORD;
  const validEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validEmail) return setError('Enter a full email address, like name@company.com.');
    if (password.length < MIN_PASSWORD) return setError('Use at least ' + MIN_PASSWORD + ' characters for the password.');
    setBusy(true); setError('');
    const { data, error: err } = await supabaseBrowser().auth.signUp({
      email: email.trim(), password,
      options: { data: { full_name: name.trim() }, emailRedirectTo: origin() + '/auth/callback?next=' + encodeURIComponent(next) },
    });
    setBusy(false);
    if (err) return setError(message(err));
    if (data.session) { window.location.assign(next); return; }
    // With email confirmation on, an address that already has an account comes back with no identities.
    if (data.user && Array.isArray(data.user.identities) && data.user.identities.length === 0) return setError('An account with this email already exists. Log in instead.');
    setSentTo(email.trim());
  };

  if (sentTo) return (
    <AuthFrame eyebrow="Almost done" title="Check your email" lead={<>We sent a confirmation link to <b>{sentTo}</b>. Open it on this device to finish creating your account.</>}
      foot={<Link href="/login" style={css('font-weight: 700;')}>Back to log in</Link>}>
      <Notice>The link works once and expires after 24 hours. Nothing in Orgcue is shared until you confirm.</Notice>
      <ResendLink email={sentTo} />
    </AuthFrame>
  );

  return (
    <AuthFrame eyebrow="Orgcue" title="Create your account" lead="You join the Lumio Inc. workspace as a member."
      foot={<>Already have an account? <Link href="/login" style={css('font-weight: 700;')}>Log in</Link></>}>
      {error && <Notice tone="error">{error}</Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="Full name" name="name" autoComplete="name" required value={name} onChange={(e) => setName(e.target.value)} />
        <Field label="Work email" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        <Field label="Password" type="password" name="new-password" autoComplete="new-password" required value={password} onChange={(e) => setPassword(e.target.value)}
          help={short ? (MIN_PASSWORD - password.length) + ' more characters' : 'At least ' + MIN_PASSWORD + ' characters'} />
        <Button type="submit" size="lg" block disabled={busy || !name.trim() || !email.trim() || !password}>{busy ? 'Creating account …' : 'Create account'}</Button>
      </form>
    </AuthFrame>
  );
}

export function ForgotForm() {
  const [email, setEmail] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [sentTo, setSentTo] = useState('');
  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setBusy(true); setError('');
    const { error: err } = await supabaseBrowser().auth.resetPasswordForEmail(email.trim(), { redirectTo: origin() + '/auth/callback?next=/reset-password' });
    setBusy(false);
    // Say the same thing whether or not the account exists, so the form can't be used to look up members.
    if (err && (err.status === 429 || ((err as AuthError & { code?: string }).code || '').startsWith('over_'))) return setError(message(err));
    setSentTo(email.trim());
  };
  if (sentTo) return (
    <AuthFrame eyebrow="Password" title="Check your email" lead={<>If <b>{sentTo}</b> has an Orgcue account, a link to set a new password is on its way.</>}
      foot={<Link href="/login" style={css('font-weight: 700;')}>Back to log in</Link>}>
      <Notice>Open the link on this device. It works once.</Notice>
    </AuthFrame>
  );
  return (
    <AuthFrame eyebrow="Password" title="Reset your password" lead="We’ll email you a link to set a new one."
      foot={<Link href="/login" style={css('font-weight: 700;')}>Back to log in</Link>}>
      {error && <Notice tone="error">{error}</Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="Email" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        <Button type="submit" size="lg" block disabled={busy || !email.trim()}>{busy ? 'Sending …' : 'Send reset link'}</Button>
      </form>
    </AuthFrame>
  );
}

export function ResetForm() {
  const [password, setPassword] = useState('');
  const [again, setAgain] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (password.length < MIN_PASSWORD) return setError('Use at least ' + MIN_PASSWORD + ' characters.');
    if (password !== again) return setError('The two passwords don’t match.');
    setBusy(true); setError('');
    const { error: err } = await supabaseBrowser().auth.updateUser({ password });
    setBusy(false);
    if (err) return setError(message(err));
    window.location.assign('/home');
  };
  return (
    <AuthFrame eyebrow="Password" title="Set a new password" lead="You’ll stay logged in on this device.">
      {error && <Notice tone="error">{error}</Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="New password" type="password" name="new-password" autoComplete="new-password" value={password} onChange={(e) => setPassword(e.target.value)} help={'At least ' + MIN_PASSWORD + ' characters'} />
        <Field label="Repeat it" type="password" name="confirm-password" autoComplete="new-password" value={again} onChange={(e) => setAgain(e.target.value)} />
        <Button type="submit" size="lg" block disabled={busy || !password || !again}>{busy ? 'Saving …' : 'Save password'}</Button>
      </form>
    </AuthFrame>
  );
}
