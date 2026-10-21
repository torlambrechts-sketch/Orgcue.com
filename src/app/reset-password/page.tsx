import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import { ResetForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Set a new password', description: 'Choose a new password for your Orgcue account.', index: false });

export default function Page() {
  return <Suspense><ResetForm /></Suspense>;
}
