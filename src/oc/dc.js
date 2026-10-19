// Minimal stand-in for the prototype's DCLogic component base, so the screen logic in src/screens can stay as written in
// the design files: a class with props, state, setState, forceUpdate and renderVals(). useScreen() mounts one.
import React, { useEffect, useReducer, useRef, useSyncExternalStore } from 'react';
import { K } from './kit';
import { getD } from './db';

// The prototype screens read the kit, the data and React from `window`. Screens import this object as `window`.
export const win = {
  get OCK() { return getD() || K.publicMode ? K : null; }, // publicMode: the customer page runs without workspace data
  get OCD() { return getD(); },
  React,
};

export class DCLogic {
  constructor() { this.props = {}; this.state = {}; this._bump = () => {}; }
  setState(p) { const next = typeof p === 'function' ? p(this.state, this.props) : p; this.state = { ...this.state, ...(next || {}) }; this._bump(); }
  forceUpdate() { this._bump(); }
}

export function useScreen(Cls, props) {
  const ref = useRef(null);
  const [, bump] = useReducer((x) => x + 1, 0);
  if (!ref.current) ref.current = new Cls();
  const inst = ref.current;
  inst._bump = bump;
  inst.props = props;
  useSyncExternalStore(K.store.subscribe, K.store.getState, K.store.getState);
  useEffect(() => () => { if (inst.componentWillUnmount) inst.componentWillUnmount(); }, [inst]);
  return inst.renderVals();
}
