---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: The §bagWindowResort entry-variant
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

The §`bagWindowResort` private function mirrors cycle 123's
`windowResort` and cycle 120's `generateFullSortedEntries`. Three
points of variation:

1. **Type signature**: takes `[T, bigint][]` (bag entries with
   counts) instead of `T[]` (bare elements; cycle 123) or
   `[Key, V][]` (key-value entries; cycle 120).

2. **The §`assertNoDuplicateKeys`** import (vs cycle 123's
   `assertNoDuplicates`): cycle 110's copySet uses
   `assertNoDuplicates` (element-uniqueness); cycle 115's copyBag
   uses `assertNoDuplicateKeys` (key-uniqueness even when counts
   differ). This cycle inherits the bag version.

3. **The §terminating-value** at line 85:
   ```js
   return harden({ done: true, value: [null, 0n] });
   ```
   vs cycle 123's `value: null`. The bag terminating value is a
   *tuple-shaped null sentinel* (`[null, 0n]`) — the destructuring
   `value: [x, xc]` in `nextX()` needs a tuple-shaped fallback.
   Cycle 123 has the *same idea* (the `value = nonEntry` shape)
   but expressed as an *external `nonEntry`* constant.

Same §raw-JS-array-iterator-doesn't-harden escape hatch with the
*unfrozen-value-does-not-escape-this-file* invariant. Same
*correctness-by-closed-scope-confidence* deviation.
