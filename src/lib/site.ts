import type { Metadata } from 'next';
// Site-wide constants and the marketing copy (from design/Marketing.dc.html, adapted to the Orgcue product spec).

/** Canonical origin. Previews and local builds still point canonical URLs at production. */
export const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL || 'https://orgcue.vercel.app').replace(/\/$/, '');
export const SITE_NAME = 'Orgcue';
export const TAGLINE = 'The intake and decision layer for AI work';
export const DEFAULT_DESCRIPTION =
  'Orgcue collects what your experts know, settles conflicts through one named decider, and turns it into a locked, traceable spec for Copilot Studio, Agentforce, Claude Code, Cursor and other AI tools.';

export const STEPS = [
  { n: '1', t: 'Ask the right people', d: 'Each person answers only what they know, privately, in about 12 minutes, on their phone.' },
  { n: '2', t: 'Settle the conflicts', d: 'Everyone’s input is revealed at once. Duplicates merge, and real disagreements go to one decider with both sides.' },
  { n: '3', t: 'Generate for your AI', d: 'A locked spec compiles to the tool you use, with every constraint verbatim and every line traced to its source.' },
  { n: '4', t: 'Track it to done', d: 'Every decision ends in an owned, dated action, and every contributor hears what happened to their input.' },
];

export const TARGETS = ['Copilot Studio', 'Agentforce', 'Claude Code', 'Cursor', 'ChatGPT', 'Slack', 'Teams', 'ServiceNow'];

export const TRUST = [
  { t: 'Your data region', d: 'US or EU, chosen once per organization.' },
  { t: 'SSO and SCIM', d: 'Entra ID, Okta and Google.' },
  { t: 'Append-only audit log', d: 'Every change recorded and exportable.' },
  { t: 'Never trained on your data', d: 'Zero-retention model endpoints.' },
];

export const USES = [
  { t: 'AI agents', d: 'IT, HR and customer helpdesks that follow the rules your experts set.', ex: 'IT Helpdesk Agent v1 → Copilot Studio', bg: 'var(--op-sf)' },
  { t: 'Software', d: 'Feature specs that engineers and coding agents can both build from.', ex: 'Expense Approval Service → Claude Code', bg: 'var(--op-sbg)' },
  { t: 'Policies', d: 'AI-use and security policies written with the people who apply them.', ex: 'AI Acceptable Use Policy 2027 → policy draft', bg: 'var(--op-mint)' },
  { t: 'Processes', d: 'Suppliers, inputs, steps and outputs from the people who run the work.', ex: 'Process input · SIPOC → BPMN 2.0', bg: 'var(--op-sf)' },
];

export const PRINCIPLES = [
  { t: 'Blind first', d: 'Answers stay private until collection closes, then everyone sees them at once.' },
  { t: 'Work, not people', d: 'Nobody is scored or ranked. Peers see function groups, not names.' },
  { t: 'Constraints are sacred', d: 'Hard constraints are owned, inserted verbatim and can’t be voted out.' },
  { t: 'Everything traces', d: 'Every generated line links to its input, its decision and its test.' },
];

// Plans without prices: no amounts, billing terms or limits until pricing is decided.
export type Tier = { name: string; summary: string; features: string[]; recommended?: boolean };
export const TIERS: Tier[] = [
  { name: 'Team', summary: 'For a first project and the people who answer it.', features: ['Unlimited contributors', 'Slack, Teams and email', 'All generation targets', 'Actions and milestones'] },
  { name: 'Business', summary: 'For organizations running several projects at once.', features: ['Everything in Team', 'Template builder', 'ServiceNow and Jira sync', 'Evidence packs'], recommended: true },
  { name: 'Enterprise', summary: 'For organizations that need their own instance and identity setup.', features: ['Everything in Business', 'SSO and SCIM', 'Audit export to your SIEM', 'Dedicated instance', 'Template packs included'] },
];

export const FAQ = [
  { q: 'Do contributors need an account?', a: 'No. Contributors and external respondents answer from a link and never need an account.' },
  { q: 'Can we choose where data is stored?', a: 'Yes, US or EU, once per organization at setup. Answers, specs and actions stay in that region.' },
  { q: 'Do you train models on our answers?', a: 'No. Every processing step uses in-region, zero-retention endpoints, and that is in the contract.' },
  { q: 'We already use Jira. Do we need the actions module?', a: 'Actions are included. Track them in Orgcue, or sync each one to Jira or ServiceNow and see its status here.' },
];

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
