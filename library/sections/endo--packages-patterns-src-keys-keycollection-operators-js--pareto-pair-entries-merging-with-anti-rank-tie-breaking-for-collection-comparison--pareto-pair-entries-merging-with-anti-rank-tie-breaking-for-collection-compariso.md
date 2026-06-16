---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: Pareto pair-entries merging with anti-rank tie-breaking for collection comparison
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

> *If the corresponding entries for any single key are incomparable
> or the comparison result has the opposite sign of the result for a
> different key, then the KeyCollections are incomparable.*
>
> — `packages/patterns/src/keys/keycollection-operators.js` §makeCompareCollection JSDoc

`keycollection-operators.js` (223 lines, Turadg Aleahmad-last-touched
2026-03-26) is the *generic infrastructure that compareKeys.js uses
to lift element-wise comparison into Pareto partial-order
comparison over CopySets, CopyBags, and CopyMaps*. The file exports
two helpers (`generateCollectionPairEntries` and
`makeCompareCollection`) and one private generator
(`generateFullSortedEntries`). Together they form *one structural
mechanism*: merge two collections' entries by their common keys, run
a value comparator per key, and combine the per-key results into a
Pareto comparison that returns `<0`, `0`, `>0`, or `NaN` (incomparable).
