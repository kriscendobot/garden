---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: Related sections
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that imports `PASS_STYLE`, `isPrimitive`,
  `confirmTagRecord` from this file.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — uses `confirmTagRecord` and `confirmFunctionTagRecord` for
  the §recursive proto walk; the §two-distinct-shapes
  discipline is partially *factored out* into this file's
  §two-variants of confirmTagRecord.
- cycle 136
  [[endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline]]
  — installs `PASS_STYLE = 'remotable'` on the prototype during
  `Remotable()` setup.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — uses the same `hideAndHardenFunction` pattern this file
  applies to predicates.
- cycle 140
  [[endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level]]
  — imports `getTag` for the §tagged case in the deeply-fulfilled
  recursion.
