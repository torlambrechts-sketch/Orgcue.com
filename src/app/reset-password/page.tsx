import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import SplashShell from '@/components/splash/SplashShell';
import { ResetForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Set a new password', description: 'Choose a new password for your OrgCue account.', index: false });

export default function Page() {
  return <SplashShell><Suspense><ResetForm /></Suspense></SplashShell>;
}
