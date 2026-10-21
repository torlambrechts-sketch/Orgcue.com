// Decide (/decide): design/splash-handoff/.../Splash/Decide.dc.html. Static, public, no session.
import type { Metadata } from 'next';
import JsonLd from '@/components/site/JsonLd';
import SplashShell from '@/components/splash/SplashShell';
import DecidePage from '@/components/splash/pages/Decide';
import { pageMeta, SITE_NAME, SITE_URL, SPLASH_PAGES } from '@/lib/site';

const page = SPLASH_PAGES.find((p) => p.path === '/decide')!;
export const metadata: Metadata = pageMeta({ title: page.title, description: page.description, path: page.path, absoluteTitle: false });

const ld = {
  '@context': 'https://schema.org',
  '@type': 'BreadcrumbList',
  itemListElement: [{ '@type': 'ListItem', position: 1, name: SITE_NAME, item: SITE_URL + '/' }, { '@type': 'ListItem', position: 2, name: 'Decide', item: SITE_URL + '/decide' }],
};

export default function Page() {
  return (
    <SplashShell>
      <JsonLd data={ld} />
      <DecidePage />
    </SplashShell>
  );
}
