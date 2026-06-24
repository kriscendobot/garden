---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §makeTrap factory — same §callable-with-methods discipline
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
export const makeTrap = trapImpl => {
  const Trap = x => {
    const handler = TrapProxyHandler(x, trapImpl);
    return new Proxy(funcTarget, handler);
  };

  const makeTrapGetterProxy = x => { ... };
  Trap.get = makeTrapGetterProxy;

  return harden(Trap);
};
```

The §callable-with-methods discipline (parallel to E.js's
makeE): `Trap` is both a function *and* an object with a
`.get` method. Implementation differs from E.js in two ways:

1. **Property assignment, not `Object.assign`** —
   `Trap.get = makeTrapGetterProxy` directly (vs E.js's
   `harden(assign(fn, { get, resolve, sendOnly, when }))`).
2. **Two surfaces, not five** — only `Trap` (apply) and
   `Trap.get` (property read).

The §simpler-shape-because-fewer-methods observation: with
only one extra method, direct assignment is fine; with five,
`Object.assign` is cleaner.

§Final `harden(Trap)` makes the whole structure immutable
after construction. (E.js wraps the assign-result in `harden`;
same effect.)
