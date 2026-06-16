---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: Related sections
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the classifier whose result switches the recursion in this
  function. The §`isAtom` + `isPromise` + `passStyleOf` triple
  is the standard pass-style entry pattern.
- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatch this function's `E.when(...)`
  uses for remote promises.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — the §`isPromise` from @endo/promise-kit is the same one cycle
  138 uses; this file's §non-hardened-promise tolerance is *not*
  the same as a safe-promise (a non-hardened promise fails
  safe-promise's frozen check; both can pass `isPromise`).
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — the *remotable* leaf style this function's `case 'remotable'`
  passes through unchanged.
