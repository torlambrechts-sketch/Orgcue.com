import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import SplashShell from '@/components/splash/SplashShell';
import { SignupForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Create your account', description: 'Create an OrgCue account and open the Lumio Inc. demo workspace: an IT helpdesk agent from first question to generated files.', path: '/signup', index: false });

export default function Page() {
  return <SplashShell><Suspense><SignupForm /></Suspense></SplashShell>;
}
