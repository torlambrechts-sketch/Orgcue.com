'use client';
import dynamic from 'next/dynamic';

// The demo reads localStorage, the clock and Supabase in the browser, so the shell renders client-side only.
const Shell = dynamic(() => import('./Shell'), { ssr: false });

export default function ClientApp() {
  return <Shell />;
}
