---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: "*Why reverse-rank order? Why anti-rank comparator?*"
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The function takes entries already sorted in **reverse rank order**
(`compareAntiRank`) — *not* forward rank order. The §`compareKeys.js`
sister explains this: rank order is a *preorder* (multiple keys can
have the same rank); to walk the merge join you need a *total order*.
The lift goes:

1. *rank order* preorder → marshal's `compareRank`
2. *anti-rank order* preorder (reverse) → marshal's
   `compareAntiRank`
3. *anti-full-order comparator* total order → built lazily by
   `makeFullOrderComparatorKit().antiComparator` for each invocation

The §`generateFullSortedEntries` private helper does step 3: it walks
the rank-sorted entries, looks ahead to find runs of same-rank ties,
sorts each tie-run with `fullCompare`, and emits the sorted entries.
The §full-order discipline:

```js
const sortedTies = sortByRank(ties, fullCompare);
for (let k = 1; k < sortedTies.length; k += 1) {
  const [key0] = sortedTies[k - 1];
  const [key1] = sortedTies[k];
  Math.sign(fullCompare(key0, key1)) || Fail`Duplicate entry key: ${key0}`;
}
```

The `Math.sign(...) || Fail` idiom enforces *strict ordering* — adjacent
sorted entries must compare strictly non-equal under fullCompare. *This
is the duplicate-key check that catches a corrupt CopyBag or CopyMap
where two entries with the same key slipped past upstream invariants.*

The *anti-* prefix is structurally important. The §`fullCompare` is
the **antiComparator** from `makeFullOrderComparatorKit` — it
produces reverse total order matching the reverse rank order the
caller already established. Both inputs walk in the same direction;
the merge-join algebra is unaffected by direction but the iteration
order matches the caller's expectation.
