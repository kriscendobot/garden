---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: Related sections
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

- cycle 118 section 2
  [[endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation]]
  — the consumer that imports `getInterfaceGuardPayload` for
  every exo-class defendPrototype call.
- cycle 118 section 1
  [[endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling]]
  — the *RawMethodGuard*, *REDACTED_RAW_ARG*, *PassableMethodGuard*
  sentinels that this file's *no-LegacyRawGuardShape* observation
  references (raw guards postdate PR #1712).
- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--keys-foundation-and-copy-collection-extensions]]
  — the source of `getCopyMapKeys` and `makeCopyMap` that this
  file uses for symbol-named method introspection.
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the @endo/patterns module that this file (also in
  @endo/patterns) parallels structurally; both files normalize
  guard-shaped values.
