---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: Related sections
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

- cycle 120
  [[endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison]]
  — the *Pareto-partial-order pair-entries machinery* that this
  file's §opening TODO marks as the consolidation target.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopySet shape this file's `setify(makeSetOfElements)`
  adapter re-tags into.
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the dispatch table that calls cycle 120's
  `makeCompareCollection` to produce setCompare *rather than*
  using this file's `iterCompare` directly.
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the bag sister whose own merge-bag-operators.js mirrors this
  file's structure with non-binary multiplicities.
