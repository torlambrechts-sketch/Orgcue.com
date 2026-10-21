// Beta (/beta): the beta list on a page of its own. Static, public, no session.
import type { Metadata } from 'next';
import JsonLd from '@/components/site/JsonLd';
import SplashShell from '@/components/splash/SplashShell';
import BetaPage from '@/components/splash/BetaPage';
import { pageMeta, SITE_NAME, SITE_URL, SPLASH_PAGES } from '@/lib/site';

const page = SPLASH_PAGES.find((p) => p.path === '/beta')!;
export const metadata: Metadata = pageMeta({ title: page.title, description: page.description, path: page.path });

const ld = {
  '@context': 'https://schema.org',
  '@type': 'BreadcrumbList',
  itemListElement: [{ '@type': 'ListItem', position: 1, name: SITE_NAME, item: SITE_URL + '/' }, { '@type': 'ListItem', position: 2, name: 'Beta', item: SITE_URL + '/beta' }],
};

export default function Page() {
  return (
    <SplashShell>
      <JsonLd data={ld} />
      <BetaPage />
    </SplashShell>
  );
}
