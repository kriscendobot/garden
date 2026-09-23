---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: Related sections
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

- cycle 66
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise substrate that consumes promise-kit's
  primitives.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — defines what a *safe* promise is; this file's *racing*
  shape complements the *definition* shape.
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — duplicates `isPrimitive` (different trade-off); this file
  acknowledges the duplication with §honest-TODO and
  §layering-constraints-block-DRY observation.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (the
  @endo/harden migration that touched many @endo files
  simultaneously).
