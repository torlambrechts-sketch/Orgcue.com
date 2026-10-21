import { ImageResponse } from 'next/og';

export const size = { width: 180, height: 180 };
export const contentType = 'image/png';

// The OrgCue mark (public/orgcue-mark.svg) full bleed: iOS rounds the corners itself.
export default function AppleIcon() {
  return new ImageResponse(
    <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#4A1F3D' }}>
      <svg width="180" height="180" viewBox="0 0 64 64"><path d="M17 20.5C17 17.46 19.46 15 22.5 15h19C44.54 15 47 17.46 47 20.5v14c0 3.04-2.46 5.5-5.5 5.5H30l-8.2 7.1c-.97.84-2.48.15-2.48-1.13V40h0A5.5 5.5 0 0 1 17 34.5z" fill="none" stroke="#fff" strokeWidth="3.6" strokeLinejoin="round" /><circle cx="32" cy="27.5" r="4.6" fill="#F2B33D" /></svg>
    </div>,
    size,
  );
}
