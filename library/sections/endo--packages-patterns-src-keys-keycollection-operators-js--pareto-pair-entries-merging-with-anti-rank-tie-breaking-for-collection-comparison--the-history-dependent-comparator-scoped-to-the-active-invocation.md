---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: The history-dependent comparator — *scoped to the active invocation*
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

```js
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

The full-order comparator is *not* a shared global; each call to
`generateCollectionPairEntries` builds a fresh one. The §JSDoc names
this *history-dependent comparison scoped to the active invocation*.
This matters because `makeFullOrderComparatorKit` resolves ties
between remotables and other rank-incomparable values using a
*history-dependent* discipline — when it encounters a new value, it
gives it a stable position in the order, but that position depends
on the order values were seen. Two concurrent invocations could see
the same values in different orders. Scoping the comparator per-call
isolates the history and keeps the per-key comparison deterministic
*within* one comparison.
