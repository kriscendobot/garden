---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §hideAndHardenFunction applied to predicates
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

Four predicates use `hideAndHardenFunction` (not plain `harden`):

- `isPrimitive`
- `isObject`
- `isTypedArray`
- `assertChecker`

The §reason (cycle 134, 136, 138 established): assertion-like
functions hide their `.name` from stack traces to reduce
information leak. The §predicates-are-assertion-adjacent
discipline applies the same hide-and-harden treatment.
