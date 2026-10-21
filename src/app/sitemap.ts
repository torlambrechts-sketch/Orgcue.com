import type { MetadataRoute } from 'next';
import { SITE_URL, SPLASH_PAGES } from '@/lib/site';

const UPDATED = new Date('2026-10-21');

export default function sitemap(): MetadataRoute.Sitemap {
  return SPLASH_PAGES.map((p) => ({ url: SITE_URL + p.path, lastModified: UPDATED, changeFrequency: p.path === '/' ? 'weekly' : 'monthly', priority: p.priority }));
}
