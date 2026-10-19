import { Suspense } from 'react';
import type { Metadata } from 'next';
import { SignupForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = { title: 'Create your account · Orgcue' };

export default function Page() {
  return <Suspense><SignupForm /></Suspense>;
}
