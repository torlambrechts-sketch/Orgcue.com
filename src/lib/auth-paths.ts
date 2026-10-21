// Which routes need an account, and where to send people after signing in.
export const AUTH_PAGES = ['/login', '/signup', '/forgot-password'];
/** Reachable without an account: the auth pages, the email-link handler and the public customer answer page (spec §18.4). */
export const PUBLIC_PREFIXES = [...AUTH_PAGES, '/auth/', '/customer'];
/** The public site (splash pages): served without touching the session, so they stay fast and cacheable. */
export const MARKETING_PAGES = ['/', '/plan', '/collect', '/decide', '/deliver', '/platform'];

export const isPublic = (path: string) => MARKETING_PAGES.includes(path) || PUBLIC_PREFIXES.some((p) => path === p || path.startsWith(p.endsWith('/') ? p : p + '/'));

/** Only same-site paths are allowed as a redirect target (no "//evil.com", no absolute URLs). */
export function safeNext(next: string | null | undefined, fallback = '/home') {
  if (!next || !next.startsWith('/') || next.startsWith('//') || next.startsWith('/\\')) return fallback;
  if (AUTH_PAGES.some((p) => next === p || next.startsWith(p + '?'))) return fallback;
  return next;
}
