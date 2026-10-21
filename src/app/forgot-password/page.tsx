import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import { ForgotForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Reset your password', description: 'Get a link to set a new Orgcue password.', index: false });

export default function Page() {
  return <Suspense><ForgotForm /></Suspense>;
}
