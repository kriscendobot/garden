---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: The §merge function — the same merge-join algebra, different
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

output shape

The §`merge(xelements, yelements)` function is the sister to
cycle 120's `generateCollectionPairEntries`. Same merge-join
algebra; different output tuple:

- Cycle 120: `[Key, valueA | absentValue, valueB | absentValue]`
- This cycle: `[T, xCount: bigint, yCount: bigint]` (bigint counts!)

The §bigint-count generalization is the structural anticipation of
CopyBag: *For sets, these counts are always 0 or 1, but this
representation generalizes nicely for bags*. The CopySet
implementation hardwires count to `0n` or `1n`; the same algebra
applied to CopyBags would carry the actual multiplicity. (The
upstream bag sister is `merge-bag-operators.js`.)

The §history-dependent comparator scoping is repeated verbatim from
cycle 120:

```js
// This fullOrder contains history dependent state. It is specific
// to this one `merge` call and does not survive it.
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

The same *call-local fullOrder* discipline. Same anti-rank +
anti-full-order lift.

The §four-let buffer pattern is repeated:

```js
let x; let xDone;
let y; let yDone;

const xi = xs[Symbol.iterator]();
const nextX = () => {
  !xDone || Fail`Internal: nextX should not be called once done`;
  ({ done: xDone, value: x } = xi.next());
};
nextX();
```

Pre-advance once before the loop; subsequent `nextX()` advances and
records into the buffers. The §`!xDone || Fail` invariant is
unreachable by design.

The §merge loop emits triples per the comparison:

- `xDone && yDone` → done, terminating value `[null, 0n, 0n]` (the
  `// @ts-expect-error Because the terminating value does not
  matter` comment makes the *value-doesn't-matter-when-done*
  contract explicit)
- `xDone` only y left → `[y, 0n, 1n]`, advance y
- `yDone` only x left → `[x, 1n, 0n]`, advance x
- comp === 0 (equivalent) → `[x, 1n, 1n]`, advance both
- comp < 0 → `[x, 1n, 0n]`, advance x
- comp > 0 → `[y, 0n, 1n]`, advance y; the §`comp > 0 ||
  Fail`Internal: Unexpected comp ${q(comp)}`` invariant *exhaust
  the trichotomy* (NaN would fall here; this is the unreachable
  branch).
