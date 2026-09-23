---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: Why one section
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The 223-line file is *three closely-coupled functions implementing
one structural mechanism*. `generateFullSortedEntries` is a private
helper that only `generateCollectionPairEntries` uses;
`generateCollectionPairEntries` is consumed only by
`makeCompareCollection`. The functions form a strict
private→helper→export chain. Splitting them would manufacture
boundaries the code refuses to maintain.
