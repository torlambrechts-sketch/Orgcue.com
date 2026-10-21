'use client';
// Sign-up, log-in and password screens, in the public site's look (design/splash-handoff Splash pages): warm canvas
// with soft glows, the OrgCue mark, one white card, Instrument Serif heading, one gold primary action per screen.
// The fonts and .splash styles come from SplashShell, which every auth page wraps this in.
/* eslint-disable @next/next/no-img-element */
import React, { useState } from 'react';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import type { AuthError } from '@supabase/supabase-js';
import { supabaseBrowser } from '@/lib/supabase/client';
import { safeNext } from '@/lib/auth-paths';
import { css } from '@/components/Blocks';

const MIN_PASSWORD = 8;

export function AuthFrame({ eyebrow, title, lead, children, foot }: { eyebrow?: string; title: string; lead?: React.ReactNode; children: React.ReactNode; foot?: React.ReactNode }) {
  return (
    <div style={css('min-height: 100vh; display: flex; flex-direction: column; position: relative; overflow: clip; font-size: 15px; line-height: 1.5;')}>
      <span aria-hidden="true" style={css('position: absolute; left: 50%; top: -260px; width: 1000px; height: 820px; transform: translateX(-50%); background: radial-gradient(closest-side,rgba(196,170,214,.5),rgba(196,170,214,0)); pointer-events: none;')} />
      <span aria-hidden="true" style={css('position: absolute; right: -220px; bottom: -220px; width: 620px; height: 620px; background: radial-gradient(closest-side,rgba(251,214,170,.45),rgba(251,214,170,0)); pointer-events: none;')} />
      <header style={css('position: relative; padding: 14px clamp(16px,3vw,40px);')}>
        <div style={css('max-width: 1240px; margin: 0 auto; display: flex; align-items: center; gap: 16px;')}>
          <Link href="/" style={css('display: flex; align-items: center; gap: 10px; text-decoration: none; color: #1F1A17;')}>
            <img src="/orgcue-mark.svg" alt="" width={34} height={34} style={css('display: block; border-radius: 9px;')} />
            <span style={css('display: flex; flex-direction: column; line-height: 1;')}>
              <span style={css('font-size: 19px; font-weight: 700; letter-spacing: -0.015em;')}>Org<span style={css('color: #4A1F3D;')}>Cue</span></span>
              <span style={css('font-size: 10.5px; color: #6E665D; letter-spacing: .04em; margin-top: 2px;')}>orgcue.com</span>
            </span>
          </Link>
        </div>
      </header>
      <div className="sp-pin" style={css('position: relative; flex: 1; display: flex; flex-direction: column; align-items: center; padding: clamp(16px,5vw,48px) 16px 56px;')}>
        <div style={css('width: 100%; max-width: 440px; display: flex; flex-direction: column; gap: 18px; border: 1px solid #E7E1EA; border-radius: 24px; background: #fff; padding: clamp(22px,4vw,32px); box-sizing: border-box; box-shadow: 0 30px 70px rgba(74,31,61,.12);')}>
          <span style={css('display: flex; flex-direction: column; gap: 8px;')}>
            {eyebrow && <span style={css('font-size: 12px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; color: #4A1F3D;')}>{eyebrow}</span>}
            <h1 style={css('margin: 0; font-family: var(--font-instrument),serif; font-weight: 400; font-size: clamp(34px,6vw,42px); line-height: 1; letter-spacing: -0.01em; text-wrap: balance;')}>{title}</h1>
            {lead && <p style={css('margin: 0; font-size: 14.5px; line-height: 1.55; color: #3A332D; text-wrap: pretty;')}>{lead}</p>}
          </span>
          {children}
        </div>
        {foot && <div style={css('margin-top: 18px; font-size: 14px; color: #6E665D; text-align: center; display: flex; flex-direction: column; gap: 6px;')}>{foot}</div>}
        <p style={css('margin: 22px 0 0; max-width: 440px; font-size: 12.5px; line-height: 1.5; color: #6E665D; text-align: center;')}>OrgCue is in private beta · EU data · answers stay private until collection closes.</p>
      </div>
    </div>
  );
}

const fieldStyle = css('box-sizing: border-box; height: 48px; width: 100%; min-width: 0; border-radius: 10px; border: 1px solid #DCD3DE; background: #FBF9F7; padding: 0 14px; font-size: 15px; color: #1F1A17; font-family: inherit; outline: none; transition: border-color .2s ease-in-out, box-shadow .2s ease-in-out;');

export function Field({ label, help, value, onChange, ...input }: { label: string; help?: string } & Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size' | 'style'>) {
  return (
    <label style={css('display: flex; flex-direction: column; gap: 6px; min-width: 0;')}>
      <span style={css('font-size: 13px; font-weight: 600; color: #3A332D;')}>{label}</span>
      <input className="sp-field" style={fieldStyle} value={(value as string) ?? ''} onChange={onChange} {...input} />
      {help && <span style={css('font-size: 12.5px; color: #6E665D;')}>{help}</span>}
    </label>
  );
}

/** The one primary action per screen: the splash design's gold button. */
function Submit({ disabled, children }: { disabled?: boolean; children: React.ReactNode }) {
  return (
    <button type="submit" disabled={disabled} className="sp-lift"
      style={css('width: 100%; height: 48px; box-sizing: border-box; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; border: 0; background: #F2B33D; color: #1F1A17; font-size: 15px; font-weight: 700; font-family: inherit; box-shadow: 0 14px 30px rgba(242,179,61,.25); transition: transform .2s ease-in-out;' + (disabled ? ' opacity: .55; cursor: default; box-shadow: none;' : ' cursor: pointer;'))}>
      {children}
    </button>
  );
}

export function Notice({ tone = 'info', children }: { tone?: 'info' | 'error' | 'ok'; children: React.ReactNode }) {
  const c = { info: ['#F3EDF4', '#2A1224'], error: ['#FBE3DC', '#A23A22'], ok: ['#E3F2F0', '#1E5E55'] }[tone];
  return <div role={tone === 'error' ? 'alert' : 'status'} style={{ borderRadius: 12, padding: '11px 14px', fontSize: 13.5, lineHeight: 1.5, background: c[0], color: c[1] }}>{children}</div>;
}

const form = css('display: flex; flex-direction: column; gap: 14px; margin: 0;');
const linkBtn = css('border: none; background: transparent; padding: 0; cursor: pointer; font-family: inherit; font-size: 13.5px; font-weight: 600; color: #4A1F3D; text-align: left;');

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
  if (state === 'sent') return <span style={css('font-size: 13.5px; color: #1E5E55;')}>✓ Sent again. Check your inbox and spam folder.</span>;
  return <span style={css('display: flex; flex-direction: column; gap: 6px;')}>
    <button type="button" onClick={resend} disabled={state === 'sending'} style={linkBtn}>{state === 'sending' ? 'Sending …' : 'Send the link again'}</button>
    {state && state !== 'sending' && <span style={css('font-size: 12.5px; color: #A23A22;')}>{state}</span>}
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
    <AuthFrame eyebrow="Welcome back" title="Log in" lead="Use the email and password you signed up with."
      foot={<>
        <span>New to OrgCue? <Link href="/beta" style={css('font-weight: 700;')}>Become a beta user</Link></span>
        <span>Invited to the beta? <Link href={'/signup' + (next !== '/home' ? '?next=' + encodeURIComponent(next) : '')} style={css('font-weight: 700;')}>Create your account</Link></span>
      </>}>
      {linkError && <Notice>{linkError === 'expired' ? 'That link has expired or was already used. Log in, or ask for a new one.' : 'We couldn’t finish signing you in from that link. If you just confirmed your email, log in below.'}</Notice>}
      {error && <Notice tone="error">{error}</Notice>}
      {unconfirmed && <Notice tone="error"><span style={css('display: flex; flex-direction: column; gap: 6px;')}>Confirm your email first. We sent a link to {email.trim()}.<ResendLink email={email.trim()} /></span></Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="Email" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        <Field label="Password" type="password" name="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        <Link href="/forgot-password" style={css('align-self: flex-start; font-size: 13.5px; font-weight: 600;')}>Forgot your password?</Link>
        <Submit disabled={busy || !email.trim() || !password}>{busy ? 'Logging in …' : 'Log in'}</Submit>
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
      <Notice>The link works once and expires after 24 hours. Nothing in OrgCue is shared until you confirm.</Notice>
      <ResendLink email={sentTo} />
    </AuthFrame>
  );

  return (
    <AuthFrame eyebrow="Beta access" title="Create your account" lead="For people invited to the beta. You join the Lumio Inc. demo workspace as a member."
      foot={<>
        <span>Already have an account? <Link href="/login" style={css('font-weight: 700;')}>Log in</Link></span>
        <span>No invite yet? <Link href="/beta" style={css('font-weight: 700;')}>Join the beta list</Link></span>
      </>}>
      {error && <Notice tone="error">{error}</Notice>}
      <form onSubmit={submit} style={form} noValidate>
        <Field label="Full name" name="name" autoComplete="name" required value={name} onChange={(e) => setName(e.target.value)} />
        <Field label="Work email" type="email" name="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        <Field label="Password" type="password" name="new-password" autoComplete="new-password" required value={password} onChange={(e) => setPassword(e.target.value)}
          help={short ? (MIN_PASSWORD - password.length) + ' more characters' : 'At least ' + MIN_PASSWORD + ' characters'} />
        <Submit disabled={busy || !name.trim() || !email.trim() || !password}>{busy ? 'Creating account …' : 'Create account'}</Submit>
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
    <AuthFrame eyebrow="Password" title="Check your email" lead={<>If <b>{sentTo}</b> has an OrgCue account, a link to set a new password is on its way.</>}
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
        <Submit disabled={busy || !email.trim()}>{busy ? 'Sending …' : 'Send reset link'}</Submit>
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
        <Submit disabled={busy || !password || !again}>{busy ? 'Saving …' : 'Save password'}</Submit>
      </form>
    </AuthFrame>
  );
}
