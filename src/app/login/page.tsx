import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import { LoginForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Log in', description: 'Log in to Orgcue with your email and password.', index: false });

export default function Page() {
  return <Suspense><LoginForm /></Suspense>;
}
