import { Suspense } from 'react';
import type { Metadata } from 'next';
import { LoginForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = { title: 'Log in · Orgcue' };

export default function Page() {
  return <Suspense><LoginForm /></Suspense>;
}
