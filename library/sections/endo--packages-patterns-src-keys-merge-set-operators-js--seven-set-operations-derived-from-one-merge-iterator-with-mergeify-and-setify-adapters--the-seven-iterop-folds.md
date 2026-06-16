---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: The seven §iterOp folds
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

The file defines seven generic *fold-over-merge-iterator* helpers,
each accepting an `Iterable<[T, bigint, bigint]>` and producing the
operation's result. The seven, with their per-element predicates:

| iterOp | Predicate per element | Output |
|--------|------------------------|--------|
| `iterIsSuperset` | `if (xc === 0n) return false` | boolean (early exit) |
| `iterIsDisjoint` | `if (xc >= 1n && yc >= 1n) return false` | boolean (early exit) |
| `iterCompare` | combine `loneY = xc===0n`, `loneX = yc===0n`; early `NaN` if both | `KeyComparison` (-1 / 0 / 1 / NaN) |
| `iterUnion` | always push `m` | `T[]` (all merged elements) |
| `iterDisjointUnion` | assert no common; push `m` | `T[]` (throws on overlap) |
| `iterIntersection` | push iff `xc >= 1n && yc >= 1n` | `T[]` (common only) |
| `iterDisjointSubtract` | assert x present; push iff `yc === 0n` | `T[]` (left-only after assertion) |

The §iterCompare implementation is the *same Pareto two-flag
pattern* cycle 120's `makeCompareCollection` uses, restricted to
set membership: *something in y not in x* (`loneY`) + *something in
x not in y* (`loneX`) + the §early-exit `if (loneX && loneY) return
NaN` short-circuit. Pareto comparison over set membership.
