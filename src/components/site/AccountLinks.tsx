'use client';
// "Log in" + sign-up CTA, or "Open Orgcue" when this browser already has a session cookie.
// Reads the cookie only (no Supabase client on the public pages); the middleware still checks the session itself.
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { buttonStyle } from '@/components/ds';

export default function AccountLinks({ cta }: { cta: React.ReactNode }) {
  const [signedIn, setSignedIn] = useState(false);
  useEffect(() => { setSignedIn(/(^|;\s*)sb-[^=]+-auth-token(\.0)?=/.test(document.cookie)); }, []);
  if (signedIn) return <Link href="/home" style={buttonStyle('sm')}>Open Orgcue</Link>;
  return (<><Link href="/login" className="font-semibold text-op-ink">Log in</Link>{cta}</>);
}
