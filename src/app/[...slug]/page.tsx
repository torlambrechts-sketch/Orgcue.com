import type { Metadata } from 'next';
import ClientApp from '@/components/ClientApp';
import { pageMeta } from '@/lib/site';
import { SEED } from '@/oc/demo-data';

// The signed-in app: one catch-all route rendered client-side by its own router (src/components/Shell.tsx).
// It sits behind the log-in, so every path is noindex; titles still name the page for tabs, history and screen readers.
const TOP: Record<string, string> = { home: 'Home', projects: 'Projects', templates: 'Templates', library: 'Library', portfolio: 'Portfolio', phone: 'Answer on your phone' };
const TABS: Record<string, string> = { overview: 'Overview', members: 'Members', input: 'Input', 'my-input': 'My input', brainstorm: 'Brainstorm', spec: 'Spec', generate: 'Generate', actions: 'Actions' };
const cap = (s: string) => s.replace(/-/g, ' ').replace(/^./, (c) => c.toUpperCase());

export async function generateMetadata({ params }: { params: Promise<{ slug: string[] }> }): Promise<Metadata> {
  const [top = 'home', id, tab] = (await params).slug || [];
  let title = TOP[top] || 'Orgcue';
  if (top === 'settings') title = (id ? cap(id).replace(/ library$/, ' and library') + ' · ' : '') + 'Settings';
  if (top === 'p') { const p = (SEED.projects as { id: string; name: string }[]).find((x) => x.id === id); title = (TABS[tab] || 'Overview') + ' · ' + (p ? p.name : 'Project'); }
  if (top === 'customer') return pageMeta({ title: 'Help us build a better support assistant · Lumio', absoluteTitle: true, description: '4 short questions about getting help with your account. About 3 minutes, no account needed.', index: false });
  return pageMeta({ title, index: false });
}

export default function Page() {
  return <ClientApp />;
}
