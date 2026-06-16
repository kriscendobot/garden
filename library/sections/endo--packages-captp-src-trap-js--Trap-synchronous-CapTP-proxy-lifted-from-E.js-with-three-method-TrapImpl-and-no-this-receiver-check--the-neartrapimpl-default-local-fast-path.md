---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §nearTrapImpl default — §local-fast-path
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
export const nearTrapImpl = harden({
  applyFunction(target, args) { return target(...args); },
  applyMethod(target, prop, args) { return target[prop](...args); },
  get(target, prop) { return target[prop]; },
});
```

The §nearTrapImpl is the *trivial implementation* that
dispatches *locally* to the target. For local-object usage,
`Trap(x).method(...args)` reduces to `x.method(...args)` — no
overhead, no atomics, just direct method dispatch.

The §local-fast-path-via-trivial-impl discipline lets the same
`Trap(x)` surface work in *both* near and far cases. The
caller doesn't change; only the *injected `trapImpl`* differs.
Cycle 119's daemon-capability-bus carries a related §pattern
where same envelope-protocol verbs work whether the handler
is in the same process or across the bus.

The §three-line-implementations: each method body is one line.
The §minimal-trampoline form makes it obvious the overhead is
zero.
