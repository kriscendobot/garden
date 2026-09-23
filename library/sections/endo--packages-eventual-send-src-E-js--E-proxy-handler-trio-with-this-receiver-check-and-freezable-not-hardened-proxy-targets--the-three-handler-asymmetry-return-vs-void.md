---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §three-handler-asymmetry — return vs. void
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

The three handlers differ only in *what `apply` and the dispatched
method do*:

| Handler | `apply` returns | dispatched method returns |
|---------|-----------------|---------------------------|
| `makeEProxyHandler` | `HandledPromise.applyFunction(recipient, argArray)` | `HandledPromise.applyMethod(recipient, propertyKey, args)` |
| `makeESendOnlyProxyHandler` | `HandledPromise.applyFunctionSendOnly(recipient, argsArray); return undefined` | `HandledPromise.applyMethodSendOnly(recipient, propertyKey, args); return undefined` |
| `makeEGetProxyHandler` | (n/a; no apply trap) | `HandledPromise.get(x, prop)` |

The §SendOnly-fire-and-forget discipline: returns `undefined`
synchronously; doesn't return a promise. Used when the caller doesn't
care about the result *and* doesn't want to keep a promise pinned in
memory.

The §unhandled-rejection-consequence-of-SendOnly: because no promise
is returned, rejections cannot propagate. Cycle 100's
`unhandled-rejection.js` is the related GC-driven rejection-tracking
that catches these.

The §`makeESendOnlyProxyHandler` validation discipline: instead of
returning a rejected promise on receiver mismatch, it *throws*
synchronously via the `||-Fail` short-circuit:

```js
this === receiver ||
  Fail`Unexpected receiver for "${q(propertyKey)}" method of E.sendOnly(${q(recipient)})`;
```

The §throw-not-reject-in-SendOnly is correct: there's no return
promise to reject, so the failure must be synchronous.
