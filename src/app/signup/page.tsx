import { Suspense } from 'react';
import type { Metadata } from 'next';
import { pageMeta } from '@/lib/site';
import { SignupForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = pageMeta({ title: 'Create your account', description: 'Create an Orgcue account and open the Lumio Inc. demo workspace: an IT helpdesk agent from first question to generated files.', path: '/signup', index: true });

export default function Page() {
  return <Suspense><SignupForm /></Suspense>;
}
