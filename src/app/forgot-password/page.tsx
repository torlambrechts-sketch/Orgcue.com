import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import SplashShell from '@/components/splash/SplashShell';
import { ForgotForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Reset your password', description: 'Get a link to set a new OrgCue password.', index: false });

export default function Page() {
  return <SplashShell><Suspense><ForgotForm /></Suspense></SplashShell>;
}
