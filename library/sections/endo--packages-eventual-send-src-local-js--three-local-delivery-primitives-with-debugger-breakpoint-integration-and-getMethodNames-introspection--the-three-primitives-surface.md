---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §three-primitives surface
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The three exports correspond to HandledPromise's three local
dispatches:

- **`localApplyFunction(recipient, args)`** — eventual function
  call: `E(recipient)(...args)` when `recipient` is a function.
- **`localApplyMethod(recipient, methodName, args)`** — eventual
  method call: `E(recipient).methodName(...args)`. When
  `methodName === undefined || null`, dispatches to
  `localApplyFunction` (the *base case; bottom out to apply
  functions* discipline).
- **`localGet(t, key)`** — eventual property access: `E.get(t,
  key)`. The simplest of the three: just `t[key]`.

The §three-primitives-mirror-the-three-eventual-send-shapes
discipline: `E(x)(args)` (function-apply), `E(x).m(args)`
(method-apply), `E.get(x, k)` (property-get) are the three
operations HandledPromise's `applyFunction`/`applyMethod`/`get`
handlers dispatch.
