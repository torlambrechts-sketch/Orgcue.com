import type { MetadataRoute } from 'next';
import { SITE_URL } from '@/lib/site';

const UPDATED = new Date('2026-10-21');

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    { url: SITE_URL + '/', lastModified: UPDATED, changeFrequency: 'weekly', priority: 1 },
    { url: SITE_URL + '/pricing', lastModified: UPDATED, changeFrequency: 'monthly', priority: 0.8 },
    { url: SITE_URL + '/signup', lastModified: UPDATED, changeFrequency: 'yearly', priority: 0.5 },
  ];
}
