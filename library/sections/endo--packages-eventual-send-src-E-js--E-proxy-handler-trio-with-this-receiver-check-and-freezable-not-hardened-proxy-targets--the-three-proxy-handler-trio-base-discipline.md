---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §three-proxy-handler trio + §base discipline
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

The file defines three proxy handlers and a shared base:

```js
const baseFreezableProxyHandler = {
  set(_target, _prop, _value) { return false; },
  isExtensible(_target) { return false; },
  setPrototypeOf(_target, _value) { return false; },
  deleteProperty(_target, _prop) { return false; },
};
```

The §baseFreezableProxyHandler discipline: four meta-traps (`set` /
`isExtensible` / `setPrototypeOf` / `deleteProperty`) all return
`false`. The proxy *acts as if frozen* even though the target is not
hardened. The §return-false-not-throw discipline preserves the
strict-mode invariants (writing to a non-writable property *throws*
in strict mode, but the Proxy meta-trap returning `false` is the
*correct* signal for "no").

Three concrete handlers extend the base:

- `makeEProxyHandler(recipient, HandledPromise)` — `E(x)`: method-
  call dispatch.
- `makeESendOnlyProxyHandler(recipient, HandledPromise)` —
  `E.sendOnly(x)`: fire-and-forget method-call (returns `undefined`).
- `makeEGetProxyHandler(x, HandledPromise)` — `E.get(x)`: property-
  get dispatch.
