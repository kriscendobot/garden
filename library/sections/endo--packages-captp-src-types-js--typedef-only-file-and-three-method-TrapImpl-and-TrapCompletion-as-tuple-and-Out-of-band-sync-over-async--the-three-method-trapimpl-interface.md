---
title: §The three-method TrapImpl interface
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
/**
 * @typedef {object} TrapImpl
 * @property {(target: any, args: Array<any>) => any} applyFunction
 * @property {(target: any, method: string | symbol | number, args: Array<any>) => any} applyMethod
 * @property {(target: any, prop: string | symbol | number) => any} get
 */
```

§Three-method-TrapImpl: §applyFunction + §applyMethod + §get. §Distinct-from-cycle-241's-six-method-handler-protocol: §cycle-241-includes-send-only-versions (getSendOnly + applyFunctionSendOnly + applyMethodSendOnly) + §cycle-249-has-only-the-synchronous-three; §the-send-only-variants-don't-make-sense-for-Trap-because-Trap-is-sync-by-construction.

§Two-different-handler-protocols-in-the-same-family: §full-async-six-method (cycle 241 postponed.js) + §sync-only-three-method (cycle 249 captp/types). §The-axis-difference: §async-allows-send-only + §sync-doesn't-allow-send-only.

§First-explicit-observation in library of §the-three-method-vs-six-method-handler-protocol-distinction as a named-design-axis (sync-allows-three + async-allows-six).
