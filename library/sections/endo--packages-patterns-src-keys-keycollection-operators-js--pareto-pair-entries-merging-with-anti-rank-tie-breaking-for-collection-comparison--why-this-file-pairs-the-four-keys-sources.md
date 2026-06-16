---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: Why this file pairs the four Keys sources
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The Keys substrate now consists of four cycle-ingested files:

- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--keys-foundation-and-copy-collection-extensions]]
  + [[endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-validation]]
  — the *Confirm/Is/Assert* trio + CopySet/CopyBag/CopyMap kind
  validation. *Is a thing a valid Key?*
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the *Pareto partial-order comparator dispatch table*. *How do
  two Keys compare?* Dispatches to `makeCompareCollection` results
  for CopySet / CopyBag / CopyMap.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopySet shape itself. *5-layer validation +
  key-significance-over-value invariant.*
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopyBag shape itself. *Sister to CopySet with key-and-count
  significance.*
- *this cycle (120)* — the *Pareto-pair-entries-merging machinery*
  that the CopySet / CopyBag / CopyMap rows of compareKeys.js's
  dispatch table all share. *How is the partial-order
  cross-collection mechanism built once and reused?*

Together the five cycles cover the Keys substrate's whole comparison
surface: kind-validation (102), dispatch-table (104), shape (110 +
115), and *partial-order machinery* (120).
