---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: "*defaulting absent keys to a count of 0*"
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The §makeCompareCollection JSDoc gives the worked example for CopyBag:

> *given CopyBags X and Y and a value comparator that goes by count
> (defaulting absent keys to a count of 0), X is smaller than Y
> (`result < 0`) iff there are no keys in X that are either absent
> from Y (`compareValues(xCount, absentValue) > 0`) or present in Y
> with a lower count (`compareValues(xCount, yCount) > 0`) AND there
> is at least one key in Y that is either absent from X
> (`compareValues(absentValue, yCount) < 0`) or present with a lower
> count (`compareValues(xCount, yCount) < 0`).*

This is the *CopyBag Pareto partial order* written out: X ≤ Y iff
*every multiplicity in X is ≤ the corresponding multiplicity in Y
(absent = 0)* AND *some multiplicity is strictly less*. The same
pattern lifts to CopySet (Boolean lattice, absentValue = false) and
to CopyMap (where the value-comparator runs on the per-key value).
