import type { Metadata } from 'next';
import { DM_Sans, Playfair_Display } from 'next/font/google';
import './globals.css';

const dmSans = DM_Sans({ subsets: ['latin', 'latin-ext'], weight: ['400', '500', '600', '700'], variable: '--font-dm-sans', display: 'swap' });
const playfair = Playfair_Display({ subsets: ['latin', 'latin-ext'], weight: ['500', '600', '700'], variable: '--font-playfair', display: 'swap' });

export const metadata: Metadata = {
  title: 'Orgcue',
  description: 'Collect what your organization knows, settle conflicts with one decider, and generate traceable instructions for AI tools.',
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={`${dmSans.variable} ${playfair.variable}`}>
      <body>{children}</body>
    </html>
  );
}
