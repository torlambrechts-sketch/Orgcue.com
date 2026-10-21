// Home (/): design/splash-handoff/.../Splash/Home.dc.html. Static, public, no session.
import type { Metadata } from 'next';
import JsonLd from '@/components/site/JsonLd';
import SplashShell from '@/components/splash/SplashShell';
import HomePage from '@/components/splash/pages/Home';
import { pageMeta, SITE_NAME, SITE_URL, SPLASH_PAGES } from '@/lib/site';

const page = SPLASH_PAGES.find((p) => p.path === '/')!;
export const metadata: Metadata = pageMeta({ title: page.title, description: page.description, path: page.path, absoluteTitle: true });

const ld = {
  '@context': 'https://schema.org',
  '@graph': [
    { '@type': 'Organization', '@id': SITE_URL + '/#org', name: SITE_NAME, url: SITE_URL, logo: SITE_URL + '/orgcue-mark.svg' },
    { '@type': 'WebSite', '@id': SITE_URL + '/#website', url: SITE_URL, name: SITE_NAME, description: page.description, publisher: { '@id': SITE_URL + '/#org' }, inLanguage: 'en' },
    { '@type': 'SoftwareApplication', name: SITE_NAME, applicationCategory: 'BusinessApplication', operatingSystem: 'Web', url: SITE_URL, description: page.description },
  ],
};

export default function Page() {
  return (
    <SplashShell>
      <JsonLd data={ld} />
      <HomePage />
    </SplashShell>
  );
}
