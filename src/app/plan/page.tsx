// Plan (/plan): design/splash-handoff/.../Splash/Plan.dc.html. Static, public, no session.
import type { Metadata } from 'next';
import JsonLd from '@/components/site/JsonLd';
import SplashShell from '@/components/splash/SplashShell';
import PlanPage from '@/components/splash/pages/Plan';
import { pageMeta, SITE_NAME, SITE_URL, SPLASH_PAGES } from '@/lib/site';

const page = SPLASH_PAGES.find((p) => p.path === '/plan')!;
export const metadata: Metadata = pageMeta({ title: page.title, description: page.description, path: page.path, absoluteTitle: false });

const ld = {
  '@context': 'https://schema.org',
  '@type': 'BreadcrumbList',
  itemListElement: [{ '@type': 'ListItem', position: 1, name: SITE_NAME, item: SITE_URL + '/' }, { '@type': 'ListItem', position: 2, name: 'Plan', item: SITE_URL + '/plan' }],
};

export default function Page() {
  return (
    <SplashShell>
      <JsonLd data={ld} />
      <PlanPage />
    </SplashShell>
  );
}
