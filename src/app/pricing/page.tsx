// Pricing (design/Marketing.dc.html, 1.2). Server-rendered and public; the FAQ uses <details>, so it works without JavaScript.
import type { Metadata } from 'next';
import Link from 'next/link';
import { buttonStyle } from '@/components/ds';
import { Eyebrow, SitePage } from '@/components/site/SiteChrome';
import JsonLd from '@/components/site/JsonLd';
import { FAQ, pageMeta, SITE_NAME, SITE_URL, TIERS } from '@/lib/site';

const TITLE = 'Pricing';
const DESCRIPTION = 'Orgcue is priced by live projects. Contributors are always free and unlimited, and actions and project tracking are included in every plan: Team, Business and Enterprise.';

export const metadata: Metadata = pageMeta({ title: TITLE, description: DESCRIPTION, path: '/pricing' });

const ld = {
  '@context': 'https://schema.org',
  '@graph': [
    {
      '@type': 'Product', name: SITE_NAME, description: DESCRIPTION, brand: { '@type': 'Brand', name: SITE_NAME },
      offers: TIERS.filter((t) => t.amount).map((t) => ({ '@type': 'Offer', name: t.name, price: t.amount, priceCurrency: 'USD', url: SITE_URL + '/pricing', description: t.per })),
    },
    { '@type': 'FAQPage', mainEntity: FAQ.map((f) => ({ '@type': 'Question', name: f.q, acceptedAnswer: { '@type': 'Answer', text: f.a } })) },
    { '@type': 'BreadcrumbList', itemListElement: [{ '@type': 'ListItem', position: 1, name: SITE_NAME, item: SITE_URL + '/' }, { '@type': 'ListItem', position: 2, name: 'Pricing', item: SITE_URL + '/pricing' }] },
  ],
};

export default function Pricing() {
  return (
    <SitePage>
      <JsonLd data={ld} />
      <section className="mx-auto flex max-w-[1120px] flex-col gap-2.5 px-4 pb-6 pt-11 sm:px-7">
        <Eyebrow>Pricing</Eyebrow>
        <h1 className="m-0 font-display text-[34px] font-semibold leading-[1.05] tracking-[-0.01em] [text-wrap:balance] sm:text-[54px]">Priced by live projects. Contributors are always free.</h1>
        <p className="m-0 max-w-[720px] text-[16px] leading-[1.55] text-op-body">Annual organization subscription. Unlimited contributors on every plan, with actions and project tracking included in every tier.</p>
      </section>
      <section aria-label="Plans" className="mx-auto grid max-w-[1120px] items-stretch gap-3.5 px-4 [grid-template-columns:repeat(auto-fit,minmax(250px,1fr))] sm:px-7">
        {TIERS.map((t) => (
          <article key={t.name} className="flex flex-col gap-1.5 rounded-[22px] p-6" style={{ border: t.recommended ? '2px solid var(--op-ink)' : '1px solid var(--op-line)', background: t.recommended ? 'var(--op-sf)' : 'var(--op-bg)' }}>
            <span className="flex items-center justify-between gap-2">
              <h2 className="m-0 font-display text-[24px] font-semibold">{t.name}</h2>
              {t.recommended && <span className="rounded-full bg-op-ac px-2.5 py-[3px] text-[11.5px] font-bold">Most teams</span>}
            </span>
            <span className="font-display text-[34px] font-semibold tabular-nums">{t.price}</span>
            <span className="text-[13px] text-op-mut">{t.per}</span>
            <ul className="m-0 mt-1 flex list-none flex-col gap-[7px] p-0">
              {t.features.map((f) => <li key={f} className="flex gap-2 text-[14px] leading-[1.4]"><span aria-hidden="true" className="font-bold text-op-link">✓</span>{f}</li>)}
            </ul>
            <span className="mt-auto pt-2.5"><Link href="/signup" style={buttonStyle('md', t.recommended ? 'primary' : 'secondary', true)}>Create an account</Link></span>
          </article>
        ))}
      </section>
      <p className="mx-4 mt-3.5 rounded-[16px] border border-dashed border-[var(--op-rule)] px-[18px] py-3.5 text-[14px] sm:mx-auto sm:max-w-[1064px]">
        <strong>Add-on · template packs.</strong> IT and security, HR and policy, customer service. $2,400 a year each, or included on Enterprise.
      </p>
      <section aria-labelledby="faq-h" className="mx-auto max-w-[1120px] px-4 pb-12 pt-8 sm:px-7">
        <h2 id="faq-h" className="m-0 font-display text-[30px] font-semibold leading-[1.15]">Questions</h2>
        <div className="mt-3 flex flex-col border-t border-op-line">
          {FAQ.map((f, i) => (
            <details key={f.q} open={i === 0} className="group border-b border-op-line">
              <summary className="flex cursor-pointer list-none items-center justify-between gap-3 py-4 text-[15.5px] font-bold [&::-webkit-details-marker]:hidden">
                <span>{f.q}</span><span aria-hidden="true" className="group-open:hidden">+</span><span aria-hidden="true" className="hidden group-open:inline">−</span>
              </summary>
              <p className="m-0 mb-4 max-w-[760px] text-[14.5px] leading-[1.6] text-op-body">{f.a}</p>
            </details>
          ))}
        </div>
      </section>
    </SitePage>
  );
}
