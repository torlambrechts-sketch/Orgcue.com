import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import SplashShell from '@/components/splash/SplashShell';
import { LoginForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Log in', description: 'Log in to OrgCue with your email and password.', index: false });

export default function Page() {
  return <SplashShell><Suspense><LoginForm /></Suspense></SplashShell>;
}
