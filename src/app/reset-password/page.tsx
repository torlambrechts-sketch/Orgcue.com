import { Suspense } from 'react';
import type { Metadata } from 'next';
import { ResetForm } from '@/components/auth/AuthUI';

export const metadata: Metadata = { title: 'Set a new password · Orgcue' };

export default function Page() {
  return <Suspense><ResetForm /></Suspense>;
}
