import type { MetadataRoute } from 'next';
import { PRIVATE_PATHS, SITE_URL } from '@/lib/site';

// Public pages are crawlable; the signed-in app, email-link handlers and respondent links are not.
// Log-in and password pages stay crawlable so their noindex tag is seen.
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [{ userAgent: '*', allow: ['/', '/pricing', '/signup'], disallow: PRIVATE_PATHS }],
    sitemap: SITE_URL + '/sitemap.xml',
    host: SITE_URL,
  };
}
