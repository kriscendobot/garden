---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: Why this is the sister to compareKeys.js
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

Cycle 104
[[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
ingested `compareKeys.js`, which dispatches by pass-style: CopySets,
CopyBags, and CopyMaps each get their own Pareto comparator. Those
three comparators are *not* hand-rolled — they all delegate to
`makeCompareCollection(getEntries, absentValue, compareValues)`
defined in this file. `compareKeys.js` is the per-style *dispatch
table*; `keycollection-operators.js` is the *factory* that produces
the Pareto comparator each row of that table holds.
