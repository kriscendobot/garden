---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
---

# Five bag operations with multiplicity arithmetic and three code-sharing callouts

> *// Based on merge-set-operators.js, but altered for the bag
> representation.*
> *// TODO share more code with that file and
> keycollection-operators.js.*
>
> — `packages/patterns/src/keys/merge-bag-operators.js` lines 16-17

`merge-bag-operators.js` (291 lines, Kris Kowal-last-touched
2026-02-24 in commit `e56bf00f` — same author and commit as
cycles 108, 110, 115, 118, 123) is the *bag-algebra layer* sister
to cycle 123's `merge-set-operators.js`. Structurally near-
identical but with *bag-specific multiplicity arithmetic*. The
file makes the *abstraction-debt-marker* discipline visible with
*three* explicit code-sharing comments — one file-level, two
per-function.

## The three code-sharing comments — the abstraction debt
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

## The §bagWindowResort entry-variant

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

## The §merge function — six-let-buffer variant

The §`merge(xbagEntries, ybagEntries)` function produces
`Iterable<[T, xCount, yCount]>` — *same output shape* as cycle
123's `merge`. But the buffer-let pattern grows from *four* to
*six* variables:

- Cycle 123: `let x; let xDone; let y; let yDone;` (element + done
  flag)
- This cycle: `let x; let xc; let xDone; let y; let yc; let yDone;`
  (element + count + done flag)

The extra `xc`/`yc` buffers carry the *actual multiplicities from
the bag entries* (not hardcoded `1n`/`0n` as in cycle 123). Each
emitted triple `[m, xc, yc]` carries the *real* counts:

- `xDone` only y left → `[y, 0n, yc]` (yc is the actual y count)
- `yDone` only x left → `[x, xc, 0n]` (xc is the actual x count)
- comp === 0 (equivalent) → `[x, xc, yc]` (both real counts)
- comp < 0 → `[x, xc, 0n]`
- comp > 0 → `[y, 0n, yc]`

Cycle 123's `merge` could be obtained by hardcoding `xc=1n` when
present (and `yc=1n` similarly). The *generalization-is-free*
claim is structural: bag-merge subsumes set-merge.

The §history-dependent comparator scoping is repeated verbatim
from cycles 120 + 123:

```js
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

Fresh per call. *Does not survive this one merge call.*

## The five §bagIterOp folds — multiplicity arithmetic

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

## The §two-adapter pyramids producing 5 exports

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

## §The bag and set algebras are not the same algebra

The structurally most interesting observation across cycles
123 + 125: *the same merge-iterator and the same adapter pyramids
support two different algebras*. Sets form a *Boolean lattice*
(elements are present or absent); bags form a *multiplicity
lattice* (elements have non-negative integer multiplicities).
The *iterOps* express the differences:

- Set union: *push each* — element-presence only.
- Bag union: *add counts* — multiplicities accumulate.

- Set intersection: *push if both present* — element-presence.
- Bag intersection: *push min(xc, yc)* — multiplicity-min.

- Set superset: *every y is in x* (`xc !== 0n` for each y).
- Bag superset: *every y's count <= x's count* (`xc >= yc`).

The set version is *bag-version-with-counts-clipped-to-{0n,1n}*.
The *generalization-is-free* claim is structural: the bag
machinery subsumes the set machinery; consolidation should be
straightforward. The TODO marker is the abstraction debt
acknowledgment.

## Keys substrate now spans seven cycle-ingested files

Cycle 125 extends the Keys substrate to **seven files**:

- cycle 102 — `checkKey.js` (kind validation)
- cycle 104 — `compareKeys.js` (partial-order dispatch table)
- cycle 110 — `copySet.js` (CopySet shape)
- cycle 115 — `copyBag.js` (CopyBag shape)
- cycle 120 — `keycollection-operators.js` (Pareto-partial-order
  pair-merging machinery)
- cycle 123 — `merge-set-operators.js` (set-algebra layer)
- **cycle 125 (this cycle)** — `merge-bag-operators.js`
  (bag-algebra layer with multiplicity arithmetic)

The seven cover the substrate's complete *operational surface in
both the set and bag dimensions*: kind-validation, partial-order
dispatch, shape (set + bag), partial-order pair-merging
machinery, set-algebra, bag-algebra.

## Related sections

- cycle 123
  [[endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters]]
  — the *set sister*; same structural shape, different algebra
  (Boolean lattice vs multiplicity lattice).
- cycle 120
  [[endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison]]
  — the second TODO target named by this file's opening comment;
  the *Pareto-partial-order pair-merging machinery* that
  `compareKeys.js`'s setCompare and bagCompare both consume.
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopyBag shape this file's `bagify(makeBagOfEntries)`
  adapter re-tags into; the §canonical copyBag invariant
  preserved by the §`if (mc >= 1n) push` filter.
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the dispatch table that handles bag comparison via cycle
  120's `makeCompareCollection`, *not* via a `bagIterCompare`
  exported from this file (which is why this cycle has five
  iterOps instead of cycle 123's seven).
