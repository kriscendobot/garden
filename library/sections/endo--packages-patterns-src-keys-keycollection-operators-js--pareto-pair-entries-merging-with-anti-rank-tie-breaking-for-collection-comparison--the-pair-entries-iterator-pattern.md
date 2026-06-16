---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: The pair-entries iterator pattern
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The §`generateCollectionPairEntries` function is the structural core.
Given two collections of the same kind, plus a `getEntries` callback
that produces an array of `[key, value]` pairs sorted in reverse
rank order, it produces an iterator over triples `[key, valueA,
valueB]` where:

- if a key appears in both collections, the triple has both values
- if a key appears only in `c1`, `valueB` is the caller-supplied
  `absentValue`
- if a key appears only in `c2`, `valueA` is the `absentValue`

The iterator walks both inputs in lockstep, comparing the front keys
with a `fullCompare`. Equal keys produce a merged triple; otherwise
the lexically-smaller key advances on its own with the other side's
`absentValue`. This is the same shape as a *sorted-merge-join* in
relational algebra.
