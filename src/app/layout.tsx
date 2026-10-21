import type { Metadata, Viewport } from 'next';
import { DM_Sans, Playfair_Display } from 'next/font/google';
import { DEFAULT_DESCRIPTION, SITE_NAME, SITE_URL, TAGLINE } from '@/lib/site';
import './globals.css';

const dmSans = DM_Sans({ subsets: ['latin', 'latin-ext'], weight: ['400', '500', '600', '700'], variable: '--font-dm-sans', display: 'swap' });
const playfair = Playfair_Display({ subsets: ['latin', 'latin-ext'], weight: ['500', '600', '700'], variable: '--font-playfair', display: 'swap' });

// Site-wide defaults. Pages override title, description and canonical; the signed-in app and auth pages opt out of indexing.
export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: SITE_NAME + ' · ' + TAGLINE, template: '%s · ' + SITE_NAME },
  description: DEFAULT_DESCRIPTION,
  applicationName: SITE_NAME,
  authors: [{ name: SITE_NAME }],
  creator: SITE_NAME,
  publisher: SITE_NAME,
  category: 'Business software',
  formatDetection: { email: false, address: false, telephone: false },
  openGraph: { type: 'website', siteName: SITE_NAME, locale: 'en_US', url: '/', title: SITE_NAME + ' · ' + TAGLINE, description: DEFAULT_DESCRIPTION },
  twitter: { card: 'summary_large_image', title: SITE_NAME + ' · ' + TAGLINE, description: DEFAULT_DESCRIPTION },
  robots: { index: true, follow: true, googleBot: { index: true, follow: true, 'max-image-preview': 'large', 'max-snippet': -1 } },
};

export const viewport: Viewport = {
  themeColor: '#FCF6E9',
  colorScheme: 'light',
  width: 'device-width',
  initialScale: 1,
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={`${dmSans.variable} ${playfair.variable}`}>
      <body>{children}</body>
    </html>
  );
}
