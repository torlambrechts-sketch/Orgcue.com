'use client';
// The hero's decision card: a conflict that the decider settles, looping every few seconds (design/Marketing.dc.html).
// Holds still on the decided state for people who prefer reduced motion.
import { useEffect, useState } from 'react';

const OPTIONS = [
  { label: 'One verification question', group: 'Service desk · 35 points', pts: 35 },
  { label: 'MFA push before any change', group: 'Security and risk · Legal and risk · 65 points', pts: 65 },
];

export default function DecisionDemo() {
  const [tick, setTick] = useState(0);
  useEffect(() => {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) { setTick(2); return; }
    const iv = setInterval(() => setTick((t) => (t + 1) % 4), 2200);
    return () => clearInterval(iv);
  }, []);
  const chosen = tick >= 2;
  return (
    <figure aria-label="Example decision card" className="m-0 flex min-w-0 flex-[1_1_360px] flex-col gap-3 rounded-[22px] border border-op-line bg-op-sf p-5 shadow-[0_18px_40px_-28px_rgba(25,21,16,.35)]">
      <span className="flex items-center gap-2">
        <span className="rounded-full bg-[var(--op-viz5)] px-2.5 py-0.5 text-[11px] font-bold">◆ DEC-03</span>
        <span aria-live="polite" className={chosen ? 'rounded-full bg-op-mint px-2.5 py-0.5 text-[11px] font-bold text-[var(--op-greendeep)]' : 'rounded-full border border-[var(--op-rustbar)] bg-op-peach px-2.5 py-0.5 text-[11px] font-bold text-op-dangerdeep'}>{chosen ? '✓ Decision recorded' : '⇄ Conflict'}</span>
      </span>
      <span className="font-display text-[21px] font-semibold">Password resets through chat</span>
      {OPTIONS.map((o, i) => {
        const on = (tick === 1 && i === 1) || (chosen && i === 1);
        return (
          <div key={o.label} className="flex flex-col gap-1.5 rounded-[14px] p-3 transition-none" style={{ border: on ? '1.5px solid var(--op-ink)' : '1px solid var(--op-line)', background: on ? 'var(--op-sbg)' : 'var(--op-bg)', opacity: chosen && i === 0 ? 0.6 : 1 }}>
            <span className="text-[14px] font-semibold">{o.label}</span>
            <span className="text-[12px] text-op-mut">{o.group}</span>
            <span className="block h-[5px] overflow-hidden rounded-full bg-[var(--op-ink-a08)]"><span className="block h-full bg-[var(--op-sage)]" style={{ width: o.pts + '%' }} /></span>
          </div>
        );
      })}
      <figcaption className="text-[12.5px] text-op-body">{chosen ? 'Rationale recorded · A-015 sent to Security and risk to accept · REQ-020 added to the spec' : 'Advisory points show how much people care, not who is right. The decider decides.'}</figcaption>
    </figure>
  );
}
