---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §three-method-TrapImpl interface — narrower than E.js's six-method API
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
export const nearTrapImpl = harden({
  applyFunction(target, args) { return target(...args); },
  applyMethod(target, prop, args) { return target[prop](...args); },
  get(target, prop) { return target[prop]; },
});
```

§TrapImpl has **three methods**:

| Method | Used by | What it does |
|--------|---------|-------------|
| `applyFunction(target, args)` | `Trap(x)(...args)` | Sync function call |
| `applyMethod(target, prop, args)` | `Trap(x).method(...args)` | Sync method call |
| `get(target, prop)` | `Trap.get(x).prop` | Sync property read |

§Three-methods-not-six: cycle 146's `E.js` exposes E(x) /
E.sendOnly(x) / E.get(x) / E.resolve(x) / E.when(x) — five
surfaces. Trap has *three*. No SendOnly (synchronous calls
don't need fire-and-forget); no resolve (synchronous calls
return values directly); no when (no promise chain).

The §narrowed-API-for-narrower-semantics observation: each
removed method was *promise-related*. Trap's whole point is
*no promises*; the API shape reflects that.
