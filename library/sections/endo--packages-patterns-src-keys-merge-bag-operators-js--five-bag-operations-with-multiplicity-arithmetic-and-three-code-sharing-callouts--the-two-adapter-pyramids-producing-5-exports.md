---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: The §two-adapter pyramids producing 5 exports
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

The file's adapter pattern mirrors cycle 123's:

```js
const mergeify = bagIterOp => (xbagEntries, ybagEntries) =>
  bagIterOp(merge(xbagEntries, ybagEntries));

const bagEntriesIsSuperbag = mergeify(bagIterIsSuperbag);
const bagEntriesIsDisjoint = mergeify(bagIterIsDisjoint);
const bagEntriesUnion = mergeify(bagIterUnion);
const bagEntriesIntersection = mergeify(bagIterIntersection);
const bagEntriesDisjointSubtract = mergeify(bagIterDisjointSubtract);

const rawBagify = bagEntriesOp => (xbag, ybag) =>
  bagEntriesOp(xbag.payload, ybag.payload);

const bagify = bagEntriesOp => (xbag, ybag) =>
  makeBagOfEntries(bagEntriesOp(xbag.payload, ybag.payload));

export const bagIsSuperbag = rawBagify(bagEntriesIsSuperbag);
export const bagIsDisjoint = rawBagify(bagEntriesIsDisjoint);
export const bagUnion = bagify(bagEntriesUnion);
export const bagIntersection = bagify(bagEntriesIntersection);
export const bagDisjointSubtract = bagify(bagEntriesDisjointSubtract);
```

Same three-layer factory chain (bagIterOp → bagEntriesOp → bagOp).
Same `rawBagify` for predicates / `bagify` for constructors split.
`bagify` re-tags via `makeBagOfEntries(...)` to preserve cycle
115's *canonical copyBag internal form* invariant — *tagged:
'copyBag'* payload is a copyArray of `[key, count: bigint]`
2-tuples, rank-sorted in reverse order, no duplicate keys, every
count >= 1n.

Note the *five exports* (not six like cycle 123): no
`bagDisjointUnion`. Bag union *already sums counts*, so there's
no need for a separate disjoint-union — *equivalent keys merge by
addition automatically*. Sets need the disjoint-union to assert
no shared elements; bags get *element-sharing-is-just-counted*
for free.
