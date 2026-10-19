'use client';
// The signed-in account in the top bar: initials button, menu with the account, the demo role it is viewing as, and Log out.
import React, { useEffect, useRef, useState } from 'react';
import { css } from './Blocks';

export default function AccountMenu({ name, email, ini, persona, onSignOut }: { name: string; email: string; ini: string; persona: string; onSignOut: () => void }) {
  const [open, setOpen] = useState(false);
  const [busy, setBusy] = useState(false);
  const ref = useRef<HTMLSpanElement>(null);
  useEffect(() => {
    if (!open) return;
    const away = (e: MouseEvent) => { if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false); };
    const esc = (e: KeyboardEvent) => { if (e.key === 'Escape') setOpen(false); };
    document.addEventListener('mousedown', away); document.addEventListener('keydown', esc);
    return () => { document.removeEventListener('mousedown', away); document.removeEventListener('keydown', esc); };
  }, [open]);
  return (
    <span ref={ref} style={css('position: relative; flex: none;')}>
      <button type="button" aria-label={'Account · ' + name} aria-haspopup="menu" aria-expanded={open} onClick={() => setOpen(!open)}
        style={css('display: flex; width: 34px; height: 34px; align-items: center; justify-content: center; border-radius: 999px; border: none; cursor: pointer; background: var(--op-ink); color: var(--op-bg); font-family: inherit; font-size: 12px; font-weight: 700;')}>{ini}</button>
      {open && (
        <div role="menu" style={css('position: absolute; right: 0; top: 42px; z-index: 80; width: 270px; display: flex; flex-direction: column; gap: 10px; border: 1px solid var(--op-line); border-radius: 18px; background: var(--op-sf); padding: 14px; box-shadow: 0 18px 40px -24px rgba(25,21,16,.45);')}>
          <span style={css('display: flex; flex-direction: column; gap: 2px; min-width: 0;')}>
            <span style={css('font-size: 14px; font-weight: 700; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')}>{name}</span>
            {email && <span style={css('font-size: 12.5px; color: var(--op-mut); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')}>{email}</span>}
            <span style={css('font-size: 12.5px; color: var(--op-mut);')}>Lumio Inc. · Member</span>
          </span>
          <span style={css('display: block; height: 1px; background: var(--op-line);')} />
          <span style={css('display: flex; flex-direction: column; gap: 2px; font-size: 12.5px;')}>
            <span style={css('font-weight: 600;')}>Viewing as {persona}</span>
            <span style={css('color: var(--op-mut);')}>Change it with View as in the demo bar.</span>
          </span>
          <span style={css('display: block; height: 1px; background: var(--op-line);')} />
          <button type="button" role="menuitem" disabled={busy} onClick={() => { setBusy(true); onSignOut(); }}
            style={css('display: flex; align-items: center; height: 36px; border: 1px solid var(--op-line); border-radius: 10px; background: transparent; padding: 0 12px; cursor: pointer; font-family: inherit; font-size: 13px; font-weight: 600; color: var(--op-ink);')}>{busy ? 'Logging out …' : 'Log out'}</button>
        </div>
      )}
    </span>
  );
}
