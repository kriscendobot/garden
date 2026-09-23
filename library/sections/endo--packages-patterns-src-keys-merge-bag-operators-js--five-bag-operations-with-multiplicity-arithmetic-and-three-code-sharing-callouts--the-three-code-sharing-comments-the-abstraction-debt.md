---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: The three code-sharing comments — the abstraction debt
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

*acknowledged in three places*

The file opens with a *file-level marker* (lines 16-17):

```js
// Based on merge-set-operators.js, but altered for the bag
representation.
// TODO share more code with that file and
keycollection-operators.js.
```

This is the same TODO that cycle 123's `merge-set-operators.js`
carries (*share more code with keycollection-operators.js*).
Cycle 123's TODO names one consolidation target; this cycle's
names *two*: cycle 123 itself and cycle 120's
`keycollection-operators.js`.

Two per-function markers identify *specific generalizations*:

**Lines 190-191** (above `bagIterIsSuperbag`):
```js
// We should be able to use this for iterIsSuperset as well.
// The generalization is free.
```

**Lines 207-208** (above `bagIterIsDisjoint`):
```js
// We should be able to use this for iterIsDisjoint as well.
// The code is identical.
```

The *generalization-is-free* claim for isSuperbag is the
structurally interesting one. Cycle 123's `iterIsSuperset` checks
*membership-only* (`if (xc === 0n) return false`); this cycle's
`bagIterIsSuperbag` checks *count-comparison* (`if (xc < yc)
return false`). For sets, where counts are always 0n or 1n, the
count-comparison reduces to membership — so the *more general* bag
predicate covers the set case. The two-line generalization is the
*specialization-pattern* visible across cycle 123 → this cycle.

The *code-is-identical* claim for isDisjoint is even stronger:
*literally the same code* (both check `if (xc >= 1n && yc >= 1n)
return false`). The duplication is pure cost-of-non-consolidation.
