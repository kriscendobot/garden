---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: "*Things to fold over a merge iterator are everywhere*"
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

The §design pattern visible across both keycollection-operators.js
(cycle 120) and merge-set-operators.js (this cycle) is:

1. *Generate a triple stream over the merged collections*
   (`generateCollectionPairEntries` for `[key, valueA, valueB]`;
   `merge` for `[T, xCount, yCount]`).
2. *Run a generic fold over the stream* (the seven iterOps here;
   the leftIsBigger/rightIsBigger fold in cycle 120's
   `makeCompareCollection`).
3. *Adapt the fold's output to the consumer surface* (`mergeify`
   for elementsOp; `setify` for setOp; `setCompare` in
   `compareKeys.js`).

The §abstraction-debt-marker §TODO at line 17 acknowledges that the
*generate-triple-stream* step appears in two files with similar
shape; future consolidation could push the shared work into a
single helper that both bag-merge-operators, set-merge-operators,
and keycollection-operators draw from.
