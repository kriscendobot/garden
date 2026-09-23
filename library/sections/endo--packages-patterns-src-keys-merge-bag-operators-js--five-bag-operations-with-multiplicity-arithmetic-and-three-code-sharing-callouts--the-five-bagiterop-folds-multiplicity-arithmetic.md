---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: The five §bagIterOp folds — multiplicity arithmetic
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

The file defines five fold helpers; *missing* are cycle 123's
`iterCompare` (bag-compare lives in cycle 120's
`makeCompareCollection` for compareKeys) and `iterDisjointUnion`
(bags don't need this — `union` already sums counts and unions
keysets).

| bagIterOp | Multiplicity arithmetic | Output |
|-----------|--------------------------|--------|
| `bagIterIsSuperbag` | `if (xc < yc) return false` (early exit) | boolean |
| `bagIterIsDisjoint` | `if (xc >= 1n && yc >= 1n) return false` (early exit; *identical to set version*) | boolean |
| `bagIterUnion` | `push [m, xc + yc]` (sum) | `[T, bigint][]` |
| `bagIterIntersection` | `push [m, min(xc, yc)]` | `[T, bigint][]` |
| `bagIterDisjointSubtract` | `mc = xc - yc; assert mc >= 0n; push iff mc >= 1n` | `[T, bigint][]` |

The §multiplicity-arithmetic is the bag-specific specialization:

- **Union**: counts *add* — `bag({a:1, b:2}) ∪ bag({b:1, c:3})` =
  `bag({a:1, b:3, c:3})`. (Sets ignore counts and just take
  unique elements.)
- **Intersection**: counts *take the min* — `bag({a:1, b:2}) ∩
  bag({b:3, c:1})` = `bag({b:2})`. (Sets take elements in both;
  count doesn't matter.)
- **DisjointSubtract**: counts *subtract*, must remain
  non-negative else fail — `bag({a:5}) - bag({a:2})` =
  `bag({a:3})`. (Sets remove the element if both contain it; bags
  remove the specific multiplicity.)

The §`mc = xc - yc; mc >= 0n || Fail` discipline is the
*disjoint-subtract precondition*: the left bag must *contain* the
right bag (in multiplicity). The §`if (mc >= 1n) push` filters
out zero-count entries — the canonical copyBag invariant from
cycle 115 (*every count >= 1n; absent keys mean count-zero*) is
preserved on output.
