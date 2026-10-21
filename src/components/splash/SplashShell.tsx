// Frame for every public page: the splash design's fonts (Figtree, Instrument Serif) and page background.
import { Figtree, Instrument_Serif } from 'next/font/google';
import './splash.css';
import './splash-hover.css';

const figtree = Figtree({ subsets: ['latin', 'latin-ext'], weight: ['400', '500', '600', '700'], variable: '--font-figtree', display: 'swap' });
const instrument = Instrument_Serif({ subsets: ['latin', 'latin-ext'], weight: '400', style: ['normal', 'italic'], variable: '--font-instrument', display: 'swap' });

export default function SplashShell({ children }: { children: React.ReactNode }) {
  return (
    <div className={`splash ${figtree.variable} ${instrument.variable}`} style={{ background: '#F7F5F2', color: '#1F1A17', fontFamily: 'var(--font-figtree),system-ui,sans-serif', minHeight: '100vh' }}>
      <main id="main">{children}</main>
    </div>
  );
}
