---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: The §makeCompareCollection Pareto algorithm
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The §`makeCompareCollection(getEntries, absentValue, compareValues)`
factory closes over its three arguments and returns a binary
comparator. Inside that comparator, the §Pareto loop is the
mechanism:

```js
let leftIsBigger = false;
let rightIsBigger = false;
for (const [_key, leftValue, rightValue] of merged) {
  const comp = compareValues(leftValue, rightValue);
  if (comp === 0) continue;
  else if (comp < 0) rightIsBigger = true;
  else if (comp > 0) leftIsBigger = true;
  else {
    Number.isNaN(comp) ||
      Fail`Unexpected value comparison ${q(comp)} for ${leftValue} vs ${rightValue}`;
    return NaN;
  }
  if (leftIsBigger && rightIsBigger) {
    return NaN;
  }
}
return leftIsBigger ? 1 : rightIsBigger ? -1 : 0;
```

The §two-flag Pareto pattern is the same as cycle 104's
`compareKeys.js` §compareKeysComplete. The §early-exit
`if (leftIsBigger && rightIsBigger) return NaN` lets the iterator
short-circuit as soon as the collections are known incomparable —
the loop doesn't need to walk to the end. The §NaN-passthrough handles
*value*-level incomparability (e.g., comparing two remotable values
with no rank order): if a per-key comparator returns NaN, the
collections are also NaN-comparable.
