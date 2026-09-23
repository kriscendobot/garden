---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: The §windowResort variant of cycle 120's
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

generateFullSortedEntries

The §`windowResort(elements, rankCompare, fullCompare)` private
function is the *single-element* (vs `[key, value]`-pair) sister
to cycle 120's `generateFullSortedEntries`. The two functions have
the same shape:

- Assert input is already rank-sorted (`assertRankSorted`)
- Walk the elements; for each, look ahead for same-rank ties
- If the *same-rank run* is length-1 (no ties), emit directly
- Otherwise, sort the run by `fullCompare` and emit via an inner
  iterator
- Enforce uniqueness via `assertNoDuplicates(resorted, fullCompare)`

Two small differences from cycle 120:

1. **Element vs entry**: cycle 120 walks `[key, value]` entries
   (for CopyBag's `[key, count]` and CopyMap's `[key, value]`);
   this file walks bare elements (for CopySet, whose payload is a
   single-element copyArray).

2. **The §raw-JS-iterator escape hatch**:

   ```js
   // This is the raw JS array iterator whose `.next()` method
   // does not harden the IteratorResult, in violation of our
   // conventions. Fixing this is expensive and I'm confident the
   // unfrozen value does not escape this file, so I'm leaving this
   // as is.
   optInnerIterator = resorted[Symbol.iterator]();
   ```

   The §unfrozen-value-does-not-escape-this-file invariant is the
   *cost-of-correctness-vs-confidence* discipline. The author is
   explicit: this is a known deviation from the hardened-iterator
   convention, justified by the closed-scope guarantee. Cycle 120's
   sister file doesn't carry this exact note but uses the
   harden-decorated `makeIterator(...)` helper instead — the
   difference is *correctness-by-construction* (cycle 120) vs
   *correctness-by-closed-scope-confidence* (this cycle).
