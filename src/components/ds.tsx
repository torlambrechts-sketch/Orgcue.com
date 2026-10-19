// Orgpuls design-system primitives used by the prototype (Button, Input, Select, Textarea, Switch, Mark).
// Values are transcribed from design/_ds/orgpuls-design-system-*/_ds_bundle.js.
import React from 'react';

type Style = React.CSSProperties;

const SIZE = {
  lg: { h: 44, px: 20, r: 12, fs: 14.5 }, md: { h: 42, px: 18, r: 11, fs: 14 }, panel: { h: 40, px: 17, r: 11, fs: 13 },
  sm: { h: 36, px: 16, r: 10, fs: 12.5 }, xs: { h: 34, px: 15, r: 9, fs: 12.5 }, act: { h: 34, px: 13, r: 9, fs: 12 },
  xxs: { h: 32, px: 13, r: 9, fs: 12.5 }, tiny: { h: 30, px: 13, r: 9, fs: 12 },
} as const;
const TONE = {
  primary: { bg: 'var(--op-ac)', bc: 'var(--op-ink)', c: 'var(--op-ink)', fw: 700 },
  secondary: { bg: 'transparent', bc: 'var(--op-line)', c: 'var(--op-ink)', fw: 600 },
  quiet: { bg: 'var(--op-sf)', bc: 'var(--op-ink)', c: 'var(--op-ink)', fw: 700 },
  solid: { bg: 'var(--op-ink)', bc: 'var(--op-ink)', c: 'var(--op-sf)', fw: 600 },
  ghost: { bg: 'transparent', bc: 'var(--op-line)', c: 'var(--op-mut)', fw: 600 },
  danger: { bg: 'transparent', bc: 'var(--op-orange)', c: '#8A3A16', fw: 600 },
} as const;

export type ButtonSize = keyof typeof SIZE;
export type ButtonTone = keyof typeof TONE;

export function Button({ size = 'md', tone = 'primary', block, disabled, onClick, style, children, ...rest }: {
  size?: ButtonSize | string; tone?: ButtonTone | string; block?: boolean; disabled?: boolean; onClick?: (e: React.MouseEvent) => void; style?: Style; children?: React.ReactNode;
} & Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, 'onClick' | 'style'>) {
  const s = SIZE[size as ButtonSize] || SIZE.md;
  const t = TONE[tone as ButtonTone] || TONE.primary;
  const base: Style = {
    display: block ? 'flex' : 'inline-flex', width: block ? '100%' : undefined, flex: 'none', alignItems: 'center', justifyContent: 'center', whiteSpace: 'nowrap',
    cursor: disabled ? 'default' : 'pointer', height: s.h, paddingInline: s.px, borderRadius: s.r, fontSize: s.fs, fontWeight: t.fw, background: t.bg,
    border: '1px solid ' + t.bc, color: t.c, textDecoration: 'none', fontFamily: 'inherit', lineHeight: 'normal', opacity: disabled ? 0.55 : 1, boxSizing: 'border-box', ...style,
  };
  return <button type="button" disabled={disabled} onClick={onClick} style={base} {...rest}>{children}</button>;
}

const FIELD = {
  field: { h: 38, r: 10, fs: 13, px: 13, bg: 'var(--op-sf)', bw: 1, fw: 400 },
  control: { h: 40, r: 10, fs: 13.5, px: 11, bg: 'var(--op-sf)', bw: 1, fw: 400 },
  md: { h: 42, r: 11, fs: 14, px: 14, bg: 'var(--op-sf)', bw: 1, fw: 600 },
} as const;
export const fieldStyle = (size: string = 'control'): Style => {
  const s = FIELD[size as keyof typeof FIELD] || FIELD.control;
  return { boxSizing: 'border-box', height: s.h, width: '100%', borderRadius: s.r, border: s.bw + 'px solid var(--op-line)', background: s.bg, paddingInline: s.px, fontSize: s.fs, fontWeight: s.fw, color: 'var(--op-ink)', outline: 'none', fontFamily: 'inherit', minWidth: 0 };
};

type ChangeFn = (e: React.ChangeEvent<HTMLInputElement & HTMLSelectElement & HTMLTextAreaElement>) => void;

export function Input({ size = 'control', style, value, onChange, ...rest }: { size?: string; style?: Style; value?: string; onChange?: ChangeFn } & Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size' | 'style' | 'value' | 'onChange'>) {
  return <input style={{ ...fieldStyle(size), ...style }} value={value ?? ''} onChange={onChange} readOnly={!onChange} {...rest} />;
}

export function Select({ size = 'control', options = [], style, value, onChange, ...rest }: { size?: string; options?: { value: string; label: string }[]; style?: Style; value?: string; onChange?: ChangeFn } & Omit<React.SelectHTMLAttributes<HTMLSelectElement>, 'size' | 'style' | 'value' | 'onChange'>) {
  return (
    <select style={{ ...fieldStyle(size), cursor: 'pointer', ...style }} value={value ?? ''} onChange={onChange ?? (() => {})} {...rest}>
      {options.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
    </select>
  );
}

const TA = {
  panel: { r: 11, fs: 13.5, mh: 74, px: 14, py: 11, bg: 'var(--op-sf)' },
  comment: { r: 12, fs: 13.5, mh: 74, px: 14, py: 12, bg: 'var(--op-sf)' },
  open: { r: 14, fs: 14, mh: 130, px: 15, py: 13, bg: 'var(--op-sf)' },
} as const;
export function Textarea({ size = 'panel', style, value, onChange, ...rest }: { size?: string; style?: Style; value?: string; onChange?: ChangeFn } & Omit<React.TextareaHTMLAttributes<HTMLTextAreaElement>, 'style' | 'value' | 'onChange'>) {
  const s = TA[size as keyof typeof TA] || TA.panel;
  return <textarea style={{ boxSizing: 'border-box', minHeight: s.mh, width: '100%', resize: 'vertical', borderRadius: s.r, border: '1px solid var(--op-line)', background: s.bg, padding: s.py + 'px ' + s.px + 'px', fontSize: s.fs, lineHeight: 1.55, color: 'var(--op-ink)', outline: 'none', fontFamily: 'inherit', ...style }} value={value ?? ''} onChange={onChange} readOnly={!onChange} {...rest} />;
}

export function Switch({ on = false, onChange, label, disabled }: { on?: boolean; onChange?: (v: boolean) => void; label?: string; disabled?: boolean }) {
  return (
    <button type="button" role="switch" aria-checked={on} aria-label={label} disabled={disabled} onClick={() => onChange && onChange(!on)}
      style={{ position: 'relative', display: 'block', height: 22, width: 38, flex: 'none', borderRadius: 999, border: 0, padding: 0, cursor: disabled ? 'default' : 'pointer', opacity: disabled ? 0.6 : 1, background: on ? 'var(--op-ink)' : 'rgba(25,21,16,.15)' }}>
      <span style={{ position: 'absolute', top: 2, left: on ? 18 : 2, display: 'block', width: 18, height: 18, borderRadius: 999, background: 'var(--op-sf)', transition: 'left 150ms' }} />
    </button>
  );
}

export function Mark({ checked = false, size = 19 }: { checked?: boolean; size?: number }) {
  return (
    <span aria-hidden="true" style={{ display: 'flex', flex: 'none', alignItems: 'center', justifyContent: 'center', borderRadius: size >= 22 ? 7 : 5, border: '2px solid var(--op-ink)', fontSize: size >= 22 ? 12 : 11, fontWeight: 700, width: size, height: size, boxSizing: 'border-box', background: checked ? 'var(--op-ink)' : size >= 22 ? 'var(--op-sf)' : 'transparent', color: checked ? 'var(--op-bg)' : 'transparent', lineHeight: 1 }}>✓</span>
  );
}
