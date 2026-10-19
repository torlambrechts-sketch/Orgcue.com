// Landing point for the links Supabase Auth emails (sign-up confirmation and password reset).
// Handles both the PKCE `?code=` redirect and the `?token_hash=&type=` form used by custom email templates.
import { NextResponse, type NextRequest } from 'next/server';
import type { EmailOtpType } from '@supabase/supabase-js';
import { supabaseServer } from '@/lib/supabase/server';
import { safeNext } from '@/lib/auth-paths';

export async function GET(request: NextRequest) {
  const url = new URL(request.url);
  const code = url.searchParams.get('code');
  const tokenHash = url.searchParams.get('token_hash');
  const type = url.searchParams.get('type') as EmailOtpType | null;
  const next = safeNext(url.searchParams.get('next'));
  const supabase = await supabaseServer();

  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(new URL(next, url.origin));
  } else if (tokenHash && type) {
    const { error } = await supabase.auth.verifyOtp({ type, token_hash: tokenHash });
    if (!error) return NextResponse.redirect(new URL(type === 'recovery' ? '/reset-password' : next, url.origin));
  }
  // The link expired, was used already, or was opened in another browser than the one that asked for it.
  // A confirmation link still confirms the address in that last case, so logging in works.
  const reason = url.searchParams.get('error_description') ? 'expired' : 'link';
  return NextResponse.redirect(new URL('/login?error=' + reason, url.origin));
}
