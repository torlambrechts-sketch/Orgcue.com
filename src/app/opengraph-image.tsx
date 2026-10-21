// The social preview card for every page (Orgpuls look: cream canvas, ink mark, saffron accent).
// Built once at build time. Fonts come from Google Fonts as TTF (the image renderer can't read woff2);
// if that fetch fails the card still renders with the default font.
import { ImageResponse } from 'next/og';
import { TAGLINE } from '@/lib/site';

export const alt = 'Orgcue · Get your team aligned before the AI builds it';
export const size = { width: 1200, height: 630 };
export const contentType = 'image/png';

const HEADLINE = 'Get your team aligned before the AI builds it.';
const PILL = 'Ask · Settle · Generate · Track';
const LINE = 'Traceable specs for Copilot Studio, Claude Code, Cursor and more';

async function font(family: string, weight: number, text: string): Promise<ArrayBuffer | null> {
  try {
    const css = await (await fetch(`https://fonts.googleapis.com/css2?family=${family.replace(/ /g, '+')}:wght@${weight}&text=${encodeURIComponent(text)}`)).text();
    const url = css.match(/src: url\((.+?)\) format\('(?:opentype|truetype)'\)/)?.[1];
    return url ? await (await fetch(url)).arrayBuffer() : null;
  } catch { return null; }
}

export default async function OpenGraphImage() {
  const [display, sans] = await Promise.all([font('Playfair Display', 600, 'Orgcue' + HEADLINE), font('DM Sans', 700, TAGLINE.toUpperCase() + PILL + LINE)]);
  const fonts = [display && { name: 'Playfair Display', data: display, weight: 600 as const, style: 'normal' as const }, sans && { name: 'DM Sans', data: sans, weight: 700 as const, style: 'normal' as const }].filter(Boolean) as { name: string; data: ArrayBuffer; weight: 600 | 700; style: 'normal' }[];
  const serif = display ? 'Playfair Display' : 'serif', ui = sans ? 'DM Sans' : 'sans-serif';
  return new ImageResponse(
    <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', background: '#FCF6E9', color: '#191510', padding: '64px 72px', fontFamily: serif }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 20 }}>
        <div style={{ width: 72, height: 72, borderRadius: 20, background: '#191510', color: '#FCF6E9', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 42, fontWeight: 600 }}>O</div>
        <div style={{ fontSize: 46, fontWeight: 600 }}>Orgcue</div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 22 }}>
        <div style={{ fontSize: 21, letterSpacing: 3, color: '#5F5849', fontFamily: ui, fontWeight: 700 }}>{TAGLINE.toUpperCase()}</div>
        <div style={{ fontSize: 78, lineHeight: 1.05, fontWeight: 600, maxWidth: 1000, letterSpacing: -1 }}>{HEADLINE}</div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 18, fontFamily: ui, fontSize: 24, fontWeight: 700, color: '#3A342A' }}>
        <div style={{ display: 'flex', flexShrink: 0, background: '#F5C64A', border: '2px solid #191510', borderRadius: 999, padding: '9px 22px', color: '#191510' }}>{PILL}</div>
        <div style={{ display: 'flex' }}>{LINE}</div>
      </div>
    </div>,
    { ...size, fonts },
  );
}
