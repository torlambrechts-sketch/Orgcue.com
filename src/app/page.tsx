// Landing page (design/Marketing.dc.html, 1.1). Server-rendered and public.
import type { Metadata } from 'next';
import Link from 'next/link';
import { buttonStyle } from '@/components/ds';
import { BetaBand, Eyebrow, SitePage } from '@/components/site/SiteChrome';
import DecisionDemo from '@/components/site/DecisionDemo';
import JsonLd from '@/components/site/JsonLd';
import { DEFAULT_DESCRIPTION, pageMeta, PRINCIPLES, SITE_NAME, SITE_URL, STEPS, TAGLINE, TARGETS, TRUST, USES } from '@/lib/site';

const TITLE = 'Orgcue · Get your team aligned before the AI builds it';

export const metadata: Metadata = pageMeta({ title: TITLE, absoluteTitle: true, path: '/' });

const ld = {
  '@context': 'https://schema.org',
  '@graph': [
    { '@type': 'Organization', '@id': SITE_URL + '/#org', name: SITE_NAME, url: SITE_URL, logo: SITE_URL + '/icon.svg' },
    { '@type': 'WebSite', '@id': SITE_URL + '/#website', url: SITE_URL, name: SITE_NAME, description: DEFAULT_DESCRIPTION, publisher: { '@id': SITE_URL + '/#org' }, inLanguage: 'en' },
    {
      '@type': 'SoftwareApplication', name: SITE_NAME, applicationCategory: 'BusinessApplication', operatingSystem: 'Web', url: SITE_URL, description: DEFAULT_DESCRIPTION
    },
  ],
};

const section = 'mx-auto max-w-[1120px] px-4 sm:px-7';
const cardH = 'font-display text-[19px] font-semibold';

export default function Landing() {
  return (
    <SitePage>
      <JsonLd data={ld} />
      <section className={section + ' flex flex-wrap items-center gap-9 pb-9 pt-10 sm:pt-12'}>
        <div className="flex min-w-0 flex-[1_1_420px] flex-col gap-[18px]">
          <Eyebrow>{TAGLINE}</Eyebrow>
          <h1 className="m-0 font-display text-[34px] font-semibold leading-[1.05] tracking-[-0.01em] [text-wrap:balance] sm:text-[54px]">Get your team aligned before the AI builds it.</h1>
          <p className="m-0 max-w-[560px] text-[18px] leading-[1.55] text-op-body [text-wrap:pretty]">Orgcue turns what your experts know into a locked, traceable spec any AI tool can execute. Ask the right people, settle the conflicts, then generate.</p>
          <span className="flex flex-wrap gap-2.5">
            <Link href="#beta" style={buttonStyle('lg')}>Become a beta user</Link>
            <Link href="#how" style={buttonStyle('lg', 'secondary')}>See how it works</Link>
          </span>
          <span className="text-[13px] text-op-mut">IT Helpdesk Agent v1 at Lumio: 8 people · 64 answers · 5 decisions · one spec for Copilot Studio in 6 weeks</span>
        </div>
        <DecisionDemo />
      </section>

      <section id="how" aria-labelledby="how-h" className={section + ' scroll-mt-20 pb-9 pt-3'}>
        <Eyebrow>How it works</Eyebrow>
        <h2 id="how-h" className="mb-0 mt-2 font-display text-[30px] font-semibold leading-[1.15] [text-wrap:balance]">From scattered answers to a spec your AI can follow.</h2>
        <ol className="m-0 mt-4 grid list-none gap-3 p-0 [grid-template-columns:repeat(auto-fit,minmax(200px,1fr))]">
          {STEPS.map((s) => (
            <li key={s.n} className="flex min-w-0 flex-col gap-2.5 rounded-[20px] border border-op-line bg-op-sf p-[22px]">
              <span aria-hidden="true" className="flex h-7 w-7 items-center justify-center rounded-full bg-op-ink text-[13px] font-bold text-op-bg">{s.n}</span>
              <h3 className={cardH + ' m-0'}>{s.t}</h3>
              <p className="m-0 text-[14px] leading-[1.5] text-op-body">{s.d}</p>
            </li>
          ))}
        </ol>
      </section>

      <section aria-labelledby="targets-h" className={section + ' pb-9 pt-3'}>
        <h2 id="targets-h" className="m-0 block text-[11px] font-bold uppercase tracking-[.12em] text-op-mut">Generates for · works with</h2>
        <ul className="m-0 mt-3 grid list-none gap-2.5 p-0 [grid-template-columns:repeat(auto-fill,minmax(150px,1fr))]">
          {TARGETS.map((l) => <li key={l} className="flex h-14 items-center justify-center rounded-[14px] border border-op-line bg-op-sf text-[14px] font-bold text-op-body">{l}</li>)}
        </ul>
      </section>

      <section aria-label="Security and privacy" className="mx-4 mb-9 sm:mx-auto sm:max-w-[1064px]">
        <ul className="m-0 grid list-none gap-3.5 rounded-[20px] bg-op-ink p-[22px] px-6 text-op-bg [grid-template-columns:repeat(auto-fit,minmax(200px,1fr))]">
          {TRUST.map((t) => <li key={t.t} className="flex flex-col gap-1"><strong className="text-[15px]">{t.t}</strong><span className="text-[13px] leading-[1.5] opacity-85">{t.d}</span></li>)}
        </ul>
      </section>

      <section aria-labelledby="uses-h" className={section + ' pb-10'}>
        <h2 id="uses-h" className="m-0 font-display text-[30px] font-semibold leading-[1.15] [text-wrap:balance]">One loop for four kinds of work.</h2>
        <div className="mt-3.5 grid gap-3 [grid-template-columns:repeat(auto-fit,minmax(240px,1fr))]">
          {USES.map((u) => (
            <article key={u.t} className="flex flex-col gap-2.5 rounded-[20px] border border-op-line p-[22px]" style={{ background: u.bg }}>
              <h3 className="m-0 font-display text-[20px] font-semibold">{u.t}</h3>
              <p className="m-0 text-[14px] leading-[1.55] text-op-body">{u.d}</p>
              <span className="text-[12.5px] text-op-mut">{u.ex}</span>
            </article>
          ))}
        </div>
      </section>

      <section aria-labelledby="principles-h" className={section + ' pb-10'}>
        <Eyebrow>What we hold to</Eyebrow>
        <h2 id="principles-h" className="mb-0 mt-2 font-display text-[30px] font-semibold leading-[1.15] [text-wrap:balance]">Built so people say what they actually know.</h2>
        <dl className="m-0 mt-3.5 grid gap-x-6 gap-y-4 border-t border-op-line pt-4 [grid-template-columns:repeat(auto-fit,minmax(220px,1fr))]">
          {PRINCIPLES.map((p) => <div key={p.t}><dt className="text-[15px] font-bold">{p.t}</dt><dd className="m-0 mt-1 text-[14px] leading-[1.55] text-op-body">{p.d}</dd></div>)}
        </dl>
      </section>

      <BetaBand source="landing" title="Get your team aligned first. Join the beta." />
    </SitePage>
  );
}
