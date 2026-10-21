// Header and footer of the public site (design/Marketing.dc.html). Server components: plain links, no JavaScript needed.
import Link from 'next/link';
import { buttonStyle } from '@/components/ds';
import { SITE_NAME } from '@/lib/site';
import AccountLinks from './AccountLinks';
import BetaSignup from './BetaSignup';

export function Logo() {
  return (
    <Link href="/" aria-label={SITE_NAME + ' home'} className="flex items-center gap-2.5 text-op-ink no-underline hover:no-underline">
      <span aria-hidden="true" className="flex h-8 w-8 items-center justify-center rounded-[10px] bg-op-ink font-display text-[17px] font-semibold text-op-bg">O</span>
      <span className="font-display text-[20px] font-semibold text-op-ink">{SITE_NAME}</span>
    </Link>
  );
}

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-20 border-b border-op-line bg-op-sf/95 backdrop-blur-[2px]">
      <div className="mx-auto flex max-w-[1120px] flex-wrap items-center justify-between gap-3 px-4 py-3.5 sm:px-6">
        <Logo />
        <nav aria-label="Site" className="flex flex-wrap items-center gap-x-4 gap-y-1 text-[14px]">
          <Link href="/#how" className="hidden text-op-ink sm:inline">Product</Link>
          <Link href="/pricing" className="hidden text-op-ink sm:inline">Plans</Link>
          <AccountLinks cta={<Link href="#beta" style={buttonStyle('sm')}>Become a beta user</Link>} />
        </nav>
      </div>
    </header>
  );
}

export function SiteFooter() {
  return (
    <footer className="border-t border-op-line bg-op-sf">
      <div className="mx-auto flex max-w-[1120px] flex-wrap justify-between gap-3 px-4 py-6 text-[13px] text-op-mut sm:px-7">
        <p className="m-0 max-w-[440px] leading-[1.55]"><strong className="text-op-ink">{SITE_NAME}</strong> · the intake and decision layer for AI work. Your data stays in the US or EU region you choose, and is never used for training.</p>
        <nav aria-label="Footer" className="flex flex-wrap items-start gap-3.5">
          <Link href="/#how">How it works</Link>
          <Link href="/pricing">Plans</Link>
          <Link href="#beta">Become a beta user</Link>
          <Link href="/login">Log in</Link>
          <span>© 2026 {SITE_NAME}</span>
        </nav>
      </div>
    </footer>
  );
}

export function Eyebrow({ children }: { children: React.ReactNode }) {
  return <span className="block text-[11px] font-bold uppercase tracking-[.12em] text-op-mut">{children}</span>;
}

/** The beta list band that ends every public page; header and in-page CTAs link to #beta. */
export function BetaBand({ source, title = 'Become a beta user.' }: { source: string; title?: string }) {
  return (
    <section id="beta" aria-labelledby="beta-h" className="mx-4 mb-12 scroll-mt-20 sm:mx-auto sm:max-w-[1064px]">
      <div className="flex flex-col gap-4 rounded-[24px] border border-op-line bg-op-sbg p-7">
        <span className="flex min-w-0 flex-col gap-1.5">
          <Eyebrow>Private beta</Eyebrow>
          <h2 id="beta-h" className="m-0 font-display text-[26px] font-semibold leading-[1.2]">{title}</h2>
          <p className="m-0 max-w-[640px] text-[14.5px] leading-[1.55] text-op-body">Orgcue is in private beta. Join the list and we’ll invite you as places open, starting with teams that have a first AI project in mind.</p>
        </span>
        <BetaSignup source={source} />
      </div>
    </section>
  );
}

/** Shared frame for the public pages. */
export function SitePage({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen flex-col bg-op-bg text-op-ink">
      <a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:left-3 focus:top-3 focus:z-30 focus:rounded-md focus:bg-op-sf focus:px-3 focus:py-2">Skip to content</a>
      <SiteHeader />
      <main id="main" className="flex-1">{children}</main>
      <SiteFooter />
    </div>
  );
}
