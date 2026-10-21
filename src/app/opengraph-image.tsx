// The social preview card for every page, in the splash design's look: plum canvas, gold accent, Instrument Serif.
// Built once at build time. Fonts come from Google Fonts as TTF (the image renderer can't read woff2);
// if that fetch fails the card still renders with the default font.
import { ImageResponse } from 'next/og';

export const alt = 'OrgCue · Specifications your whole organisation agrees on';
export const size = { width: 1200, height: 630 };
export const contentType = 'image/png';

const HEAD = 'Specifications your whole organisation ';
const ACCENT = 'agrees on.';
const LINE = 'Interviews, decided conflicts and a traceable spec for your coding agent or chat assistant';
const PILL = 'Private beta';

async function font(family: string, query: string, text: string): Promise<ArrayBuffer | null> {
  try {
    const css = await (await fetch(`https://fonts.googleapis.com/css2?family=${family.replace(/ /g, '+')}:${query}&text=${encodeURIComponent(text)}`)).text();
    const url = css.match(/src: url\((.+?)\) format\('(?:opentype|truetype)'\)/)?.[1];
    return url ? await (await fetch(url)).arrayBuffer() : null;
  } catch { return null; }
}

export default async function OpenGraphImage() {
  const [serif, serifItalic, sans] = await Promise.all([
    font('Instrument Serif', 'ital@0', HEAD),
    font('Instrument Serif', 'ital@1', ACCENT),
    font('Figtree', 'wght@700', 'OrgCue orgcue.com' + LINE + PILL),
  ]);
  const fonts = [
    serif && { name: 'Instrument Serif', data: serif, weight: 400 as const, style: 'normal' as const },
    serifItalic && { name: 'Instrument Serif', data: serifItalic, weight: 400 as const, style: 'italic' as const },
    sans && { name: 'Figtree', data: sans, weight: 700 as const, style: 'normal' as const },
  ].filter(Boolean) as { name: string; data: ArrayBuffer; weight: 400 | 700; style: 'normal' | 'italic' }[];
  const display = serif ? 'Instrument Serif' : 'serif', ui = sans ? 'Figtree' : 'sans-serif';
  return new ImageResponse(
    <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', background: 'radial-gradient(circle at 80% 0%, #6B3A5E 0%, #3A1430 55%, #2A1224 100%)', color: '#fff', padding: '60px 72px', fontFamily: ui }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 18 }}>
        <svg width="68" height="68" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#4A1F3D" stroke="rgba(255,255,255,.3)" strokeWidth="1.5" /><path d="M17 20.5C17 17.46 19.46 15 22.5 15h19C44.54 15 47 17.46 47 20.5v14c0 3.04-2.46 5.5-5.5 5.5H30l-8.2 7.1c-.97.84-2.48.15-2.48-1.13V40h0A5.5 5.5 0 0 1 17 34.5z" fill="none" stroke="#fff" strokeWidth="3.6" strokeLinejoin="round" /><circle cx="32" cy="27.5" r="4.6" fill="#F2B33D" /></svg>
        <div style={{ display: 'flex', fontSize: 44, fontWeight: 700, letterSpacing: -0.5 }}>Org<span style={{ color: '#F2B33D' }}>Cue</span></div>
        <div style={{ display: 'flex', marginLeft: 'auto', background: '#F2B33D', color: '#1F1A17', borderRadius: 999, padding: '10px 24px', fontSize: 24, fontWeight: 700 }}>{PILL}</div>
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap', fontFamily: display, fontSize: 92, lineHeight: 1, letterSpacing: -1.5, maxWidth: 1040 }}>
        <span>{HEAD}</span><span style={{ fontStyle: 'italic', color: '#F2B33D' }}>{ACCENT}</span>
      </div>
      <div style={{ display: 'flex', fontSize: 26, fontWeight: 700, color: 'rgba(255,255,255,.82)', maxWidth: 1000 }}>{LINE}</div>
    </div>,
    { ...size, fonts },
  );
}
