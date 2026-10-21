import type { Metadata } from 'next';
// Site-wide constants and search metadata for the public pages.

/** Canonical origin. Previews and local builds still point canonical URLs at production. */
export const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL || 'https://orgcue.vercel.app').replace(/\/$/, '');
export const SITE_NAME = 'OrgCue';
export const TAGLINE = 'Specifications your whole organisation agrees on';
export const DEFAULT_DESCRIPTION =
  'OrgCue interviews sales, security, IT and customers in plain language, finds where they disagree, and hands a traceable spec to your coding agent or chat assistant.';

/** The public pages (design/splash-handoff/.../Splash). Titles and descriptions follow each page's heading and intro. */
export const SPLASH_PAGES = [
  { path: '/', title: 'OrgCue · Specifications your whole organisation agrees on', description: DEFAULT_DESCRIPTION, priority: 1 },
  { path: '/plan', title: 'Plan: agree on the MVP before the interviews', description: 'Set an OrgCue project up in minutes, write a first draft with Claude watching for gaps, and let stakeholders vote on the MVP before the interviews start.', priority: 0.8 },
  { path: '/collect', title: 'Collect: interviews people actually finish', description: 'Each person gets only the questions their role can answer: no prompt jargon, a time estimate up front, and every question can be skipped. Packages per person, group or function.', priority: 0.8 },
  { path: '/decide', title: 'Decide: disagreements made visible, never averaged', description: 'Answers become requirements with codes, evidence and acceptance criteria. Where people disagree, OrgCue shows both sides, you choose, and the reason is logged.', priority: 0.8 },
  { path: '/deliver', title: 'Deliver: one specification, a file for every tool', description: 'A specification signed off section by section, then AGENTS.md, plan, tests, issues and a system prompt your coding agent, issue tracker or chat assistant can read.', priority: 0.8 },
  { path: '/beta', title: 'Become a beta user', description: 'Join the OrgCue private beta. We invite teams with a first AI project in mind to run it in OrgCue: interviews, decided conflicts and a traceable spec for their AI tools.', priority: 0.9 },
  { path: '/platform', title: 'Platform: AI models, integrations and an audit trail', description: 'Your choice of AI model, connections to the tools you already use, EU data, roles and an audit trail from every answer to every line of the handoff.', priority: 0.7 },
] as const;

/** Routes that are not for search engines: the signed-in app, auth flows and per-project respondent links. */
export const PRIVATE_PATHS = ['/home', '/projects', '/templates', '/library', '/portfolio', '/settings', '/p/', '/phone', '/customer', '/auth/', '/reset-password'];


/**
 * Complete metadata for one page. Next.js replaces (does not merge) a parent's openGraph/twitter objects, so every
 * page gets the full set here. `index: false` keeps private and transactional pages out of search results.
 */
export function pageMeta({ title, description = DEFAULT_DESCRIPTION, path, index = true, absoluteTitle = false }: { title: string; description?: string; path?: string; index?: boolean; absoluteTitle?: boolean }): Metadata {
  const full = absoluteTitle ? title : title + ' · ' + SITE_NAME;
  return {
    title: absoluteTitle ? { absolute: title } : title,
    description,
    ...(path ? { alternates: { canonical: path } } : {}),
    openGraph: { type: 'website', siteName: SITE_NAME, locale: 'en_US', title: full, description, ...(path ? { url: path } : {}) },
    twitter: { card: 'summary_large_image', title: full, description },
    robots: index ? { index: true, follow: true } : { index: false, follow: false, googleBot: { index: false, follow: false } },
  };
}
