import { Suspense } from 'react';
import type { Metadata } from 'next';
import { ForgotForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = { title: 'Reset your password · Orgcue' };

export default function Page() {
  return <Suspense><ForgotForm /></Suspense>;
}
