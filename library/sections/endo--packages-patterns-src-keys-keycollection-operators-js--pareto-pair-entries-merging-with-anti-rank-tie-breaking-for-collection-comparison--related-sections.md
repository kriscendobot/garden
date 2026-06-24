---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: Related sections
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the dispatch table that calls into this file's
  `makeCompareCollection` for CopySet, CopyBag, and CopyMap rows.
- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--keys-foundation-and-copy-collection-extensions]]
  — the *Confirm/Is/Assert* trio that validates collections before
  comparison reaches them.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — CopySet shape (caller of `makeCompareCollection` with
  `absentValue = false` Boolean lattice).
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — CopyBag shape (caller of `makeCompareCollection` with
  `absentValue = 0` count semantics).
