---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: How this file serves the wider pass-style cluster
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

This file is the *root* of the pass-style helper graph:

- cycle 71 (`passStyleOf.js`) imports `PASS_STYLE`, `isPrimitive`,
  `confirmTagRecord`, `confirmFunctionTagRecord` to classify
  values.
- cycle 134 (`remotable.js`) imports `confirmTagRecord`,
  `confirmFunctionTagRecord` for the recursive proto-walk.
- cycle 136 (`make-far.js`) imports `PASS_STYLE` to install the
  pass-style tag on remotables.
- cycle 138 (`safe-promise.js`) doesn't import directly but uses
  the same `hideAndHardenFunction` pattern.
- cycle 140 (`deeplyFulfilled.js`) imports `getTag` to read the
  `@@toStringTag` from CopyTagged values.

The §helper-root position: this file's exports are *used by*
nearly every pass-style file. Touching it has wide blast
radius; the §`@deprecated` discipline tracks what's safe to
remove vs what must stay for compatibility.
