// Header and footer of the public site (design/Marketing.dc.html). Server components: plain links, no JavaScript needed.
import Link from 'next/link';
import { buttonStyle } from '@/components/ds';
import { SITE_NAME } from '@/lib/site';
import AccountLinks from './AccountLinks';

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
          <Link href="/pricing" className="hidden text-op-ink sm:inline">Pricing</Link>
          <AccountLinks cta={<Link href="/signup" style={buttonStyle('sm')}>Create an account</Link>} />
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
          <Link href="/pricing">Pricing</Link>
          <Link href="/signup">Create an account</Link>
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
