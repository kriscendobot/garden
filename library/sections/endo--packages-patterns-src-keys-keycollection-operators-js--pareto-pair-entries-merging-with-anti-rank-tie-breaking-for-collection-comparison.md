---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
---

# Pareto pair-entries merging with anti-rank tie-breaking for collection comparison

> *If the corresponding entries for any single key are incomparable
> or the comparison result has the opposite sign of the result for a
> different key, then the KeyCollections are incomparable.*
>
> — `packages/patterns/src/keys/keycollection-operators.js` §makeCompareCollection JSDoc

`keycollection-operators.js` (223 lines, Turadg Aleahmad-last-touched
2026-03-26) is the *generic infrastructure that compareKeys.js uses
to lift element-wise comparison into Pareto partial-order
comparison over CopySets, CopyBags, and CopyMaps*. The file exports
two helpers (`generateCollectionPairEntries` and
`makeCompareCollection`) and one private generator
(`generateFullSortedEntries`). Together they form *one structural
mechanism*: merge two collections' entries by their common keys, run
a value comparator per key, and combine the per-key results into a
Pareto comparison that returns `<0`, `0`, `>0`, or `NaN` (incomparable).

## Why this is the sister to compareKeys.js

Cycle 104
[[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
ingested `compareKeys.js`, which dispatches by pass-style: CopySets,
CopyBags, and CopyMaps each get their own Pareto comparator. Those
three comparators are *not* hand-rolled — they all delegate to
`makeCompareCollection(getEntries, absentValue, compareValues)`
defined in this file. `compareKeys.js` is the per-style *dispatch
table*; `keycollection-operators.js` is the *factory* that produces
the Pareto comparator each row of that table holds.

## The pair-entries iterator pattern

The §`generateCollectionPairEntries` function is the structural core.
Given two collections of the same kind, plus a `getEntries` callback
that produces an array of `[key, value]` pairs sorted in reverse
rank order, it produces an iterator over triples `[key, valueA,
valueB]` where:

- if a key appears in both collections, the triple has both values
- if a key appears only in `c1`, `valueB` is the caller-supplied
  `absentValue`
- if a key appears only in `c2`, `valueA` is the `absentValue`

The iterator walks both inputs in lockstep, comparing the front keys
with a `fullCompare`. Equal keys produce a merged triple; otherwise
the lexically-smaller key advances on its own with the other side's
`absentValue`. This is the same shape as a *sorted-merge-join* in
relational algebra.

## *Why reverse-rank order? Why anti-rank comparator?*

The function takes entries already sorted in **reverse rank order**
(`compareAntiRank`) — *not* forward rank order. The §`compareKeys.js`
sister explains this: rank order is a *preorder* (multiple keys can
have the same rank); to walk the merge join you need a *total order*.
The lift goes:

1. *rank order* preorder → marshal's `compareRank`
2. *anti-rank order* preorder (reverse) → marshal's
   `compareAntiRank`
3. *anti-full-order comparator* total order → built lazily by
   `makeFullOrderComparatorKit().antiComparator` for each invocation

The §`generateFullSortedEntries` private helper does step 3: it walks
the rank-sorted entries, looks ahead to find runs of same-rank ties,
sorts each tie-run with `fullCompare`, and emits the sorted entries.
The §full-order discipline:

```js
const sortedTies = sortByRank(ties, fullCompare);
for (let k = 1; k < sortedTies.length; k += 1) {
  const [key0] = sortedTies[k - 1];
  const [key1] = sortedTies[k];
  Math.sign(fullCompare(key0, key1)) || Fail`Duplicate entry key: ${key0}`;
}
```

The `Math.sign(...) || Fail` idiom enforces *strict ordering* — adjacent
sorted entries must compare strictly non-equal under fullCompare. *This
is the duplicate-key check that catches a corrupt CopyBag or CopyMap
where two entries with the same key slipped past upstream invariants.*

The *anti-* prefix is structurally important. The §`fullCompare` is
the **antiComparator** from `makeFullOrderComparatorKit` — it
produces reverse total order matching the reverse rank order the
caller already established. Both inputs walk in the same direction;
the merge-join algebra is unaffected by direction but the iteration
order matches the caller's expectation.

## The history-dependent comparator — *scoped to the active invocation*

```js
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

The full-order comparator is *not* a shared global; each call to
`generateCollectionPairEntries` builds a fresh one. The §JSDoc names
this *history-dependent comparison scoped to the active invocation*.
This matters because `makeFullOrderComparatorKit` resolves ties
between remotables and other rank-incomparable values using a
*history-dependent* discipline — when it encounters a new value, it
gives it a stable position in the order, but that position depends
on the order values were seen. Two concurrent invocations could see
the same values in different orders. Scoping the comparator per-call
isolates the history and keeps the per-key comparison deterministic
*within* one comparison.

## *Maintain a single-result buffer for each iterator*

The merge loop uses the §single-result `{ done, key, value }` buffer
pattern:

```js
let xDone; let xKey; let xValue;
let yDone; let yKey; let yValue;
const nonEntry = [undefined, undefined];
const nextX = () => {
  !xDone || Fail`Internal: nextX must not be called once done`;
  const result = xValue;
  ({ done: xDone, value: [xKey, xValue] = nonEntry } = x.next());
  return result;
};
nextX();
```

The pattern *pre-advances* — `nextX()` is called once before the
loop starts so that `xKey`/`xValue` hold the first entry. Each
subsequent `nextX()` returns the *current* value and advances the
iterator. The same shape applies to `nextY`. The §`!xDone || Fail`
guard prevents calling `nextX` once exhausted (an internal-error
invariant; should be unreachable by design).

The `nonEntry = [undefined, undefined]` array is used as the
destructuring default when the iterator finishes — `value` becomes
`nonEntry` and `[xKey, xValue]` destructures to `[undefined,
undefined]`. The §destructure-with-default idiom avoids a special
branch for the iterator-done case.

## The §makeCompareCollection Pareto algorithm

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

## *defaulting absent keys to a count of 0*

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

## *This can be generalized to virtual collections in the future*

The §JSDoc names a forward-looking generalization:

> *This can be generalized to virtual collections in the future by
> replacing `getEntries => Array` with
> `generateEntries => IterableIterator`.*

The current API takes `getEntries(collection) => Array<[Key, V]>` —
the whole collection must materialize into memory as an array. For
*virtual collections* (collections backed by a database or remote
service that doesn't materialize), the iterator could be lazy: take
`generateEntries(collection) => IterableIterator<[Key, V]>` instead.
The merge-join algebra is iterator-friendly; only the API surface
needs widening.

The §rank-sorted-entries-as-input precondition is what makes the
virtual-collection generalization easy — as long as the virtual
collection can produce its entries in rank order (which it must to
serve as a Key), the Pareto comparison composes.

## Why this file pairs the four Keys sources

The Keys substrate now consists of four cycle-ingested files:

- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--keys-foundation-and-copy-collection-extensions]]
  + [[endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-validation]]
  — the *Confirm/Is/Assert* trio + CopySet/CopyBag/CopyMap kind
  validation. *Is a thing a valid Key?*
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the *Pareto partial-order comparator dispatch table*. *How do
  two Keys compare?* Dispatches to `makeCompareCollection` results
  for CopySet / CopyBag / CopyMap.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopySet shape itself. *5-layer validation +
  key-significance-over-value invariant.*
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopyBag shape itself. *Sister to CopySet with key-and-count
  significance.*
- *this cycle (120)* — the *Pareto-pair-entries-merging machinery*
  that the CopySet / CopyBag / CopyMap rows of compareKeys.js's
  dispatch table all share. *How is the partial-order
  cross-collection mechanism built once and reused?*

Together the five cycles cover the Keys substrate's whole comparison
surface: kind-validation (102), dispatch-table (104), shape (110 +
115), and *partial-order machinery* (120).

## Why one section

The 223-line file is *three closely-coupled functions implementing
one structural mechanism*. `generateFullSortedEntries` is a private
helper that only `generateCollectionPairEntries` uses;
`generateCollectionPairEntries` is consumed only by
`makeCompareCollection`. The functions form a strict
private→helper→export chain. Splitting them would manufacture
boundaries the code refuses to maintain.

## Related sections

- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the dispatch table that calls into this file's
  `makeCompareCollection` for CopySet, CopyBag, and CopyMap rows.
- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--keys-foundation-and-copy-collection-extensions]]
  — the *Confirm/Is/Assert* trio that validates collections before
  comparison reaches them.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — CopySet shape (caller of `makeCompareCollection` with
  `absentValue = false` Boolean lattice).
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — CopyBag shape (caller of `makeCompareCollection` with
  `absentValue = 0` count semantics).
