---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: Safe-promise definition with @@toStringTag tolerance and Node async_hooks explicit allowlist
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

> *Under Hardened JS a promise is "safe" if its `then` method can
> be called synchronously without giving the promise an
> opportunity for a reentrancy attack during that call.*
>
> — `packages/pass-style/src/safe-promise.js` §confirmSafePromise JSDoc

`safe-promise.js` (158 lines, Kris Kowal-last-touched 2026-02-24
in commit `e56bf00f` — same coordinated-update cluster as cycles
108/110/115/118/123/125/132/134/136) defines what a *safe
promise* is. The file exports `isSafePromise` and
`assertSafePromise` (both wrap the private `confirmSafePromise`
with `false`/`Fail` rejector).
