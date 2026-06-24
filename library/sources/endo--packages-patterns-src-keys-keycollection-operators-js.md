---
source: packages/patterns/src/keys/keycollection-operators.js
source_repo: endojs/endo
source_branch: master
source_commit: c63b8b709ecb25a32469f5eae1003a719c7f3608
source_date: 2026-03-26
source_authors: [Turadg Aleahmad]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twentieth comment-fragment ingest. The 223-line file is the
  *generic infrastructure that compareKeys.js uses to lift element-
  wise comparison into Pareto partial-order comparison over
  CopySets, CopyBags, and CopyMaps*. Sister to cycle 104's
  compareKeys.js (the dispatch table); cycle 102's checkKey.js
  (kind validation); cycle 110's copySet.js + cycle 115's
  copyBag.js (the collection shapes themselves).

  Three closely-coupled functions implement one structural
  mechanism:
    (1) `generateFullSortedEntries` (private) — refines a
        rank-sorted iterable into a fullCompare-sorted iterable,
        breaking same-rank ties by full-order comparison and
        enforcing key-uniqueness via `Math.sign(fullCompare) ||
        Fail`Duplicate entry key:` idiom;
    (2) `generateCollectionPairEntries` — sorted-merge-join over
        two collections' reverse-rank-sorted entries, producing
        `[key, valueA, valueB]` triples where missing values fall
        back to the caller's `absentValue`; uses a
        *history-dependent comparator scoped to the active
        invocation* (`makeFullOrderComparatorKit().antiComparator`);
        the §single-result `{ done, key, value }` buffer pattern
        with pre-advance via `nextX()`/`nextY()`;
    (3) `makeCompareCollection(getEntries, absentValue,
        compareValues)` factory — closes over its three args and
        returns a binary KeyComparison using the §two-flag
        leftIsBigger/rightIsBigger Pareto pattern + the §early-exit
        `if (leftIsBigger && rightIsBigger) return NaN`
        short-circuit + the §NaN-passthrough for value-level
        incomparability.

  Single most structurally interesting move: *the anti-rank +
  history-dependent antiComparator scoping*. Rank is a preorder
  (ties possible); to walk the merge-join you need a total order.
  `makeFullOrderComparatorKit().antiComparator` is built *fresh per
  call* so the deterministic history-dependent tiebreak is scoped
  to that one comparison — two concurrent invocations could see the
  same values in different histories without affecting each
  other's result.

  *defaulting absent keys to a count of 0* — the §JSDoc gives the
  worked CopyBag example: X ≤ Y iff every multiplicity in X is ≤
  the corresponding multiplicity in Y (absent = 0) AND some
  multiplicity is strictly less. The same Pareto algebra lifts to
  CopySet (Boolean lattice, absentValue = false) and CopyMap
  (per-key value comparison).

  Pairs the four Keys sources to cover the substrate's whole
  comparison surface: kind-validation (102) + dispatch-table (104)
  + shape (110 + 115) + *partial-order machinery* (120). The
  forward-looking *virtual-collection generalization* (replace
  `getEntries => Array` with `generateEntries => IterableIterator`)
  is named explicitly in the JSDoc as a future direction the
  iterator-friendly merge-join algebra already supports.

  Cycle 120 was nominally comments-lane (cycle 119 pivoted chat→
  designs). Comments-lane is now active again. Papers-lane has
  been blocked for 14+ consecutive cycles.
---

> Abstract: `packages/patterns/src/keys/keycollection-operators.js`
> is the *generic Pareto-partial-order machinery* that powers
> CopySet, CopyBag, and CopyMap comparison. Cycle 104's
> compareKeys.js dispatches by pass-style; the per-style rows do
> not hand-roll Pareto logic — they delegate to
> `makeCompareCollection(getEntries, absentValue, compareValues)`
> exported from this file. The 223-line file is *three closely-
> coupled functions implementing one structural mechanism*: merge
> two collections' entries by key, run a value comparator per key,
> and combine the per-key results into a Pareto comparison
> returning `<0`, `0`, `>0`, or `NaN`.
>
> The three pieces: (1) `generateFullSortedEntries` (private)
> refines a rank-sorted iterable into a fullCompare-sorted
> iterable, breaking same-rank ties + enforcing key-uniqueness; (2)
> `generateCollectionPairEntries` is a sorted-merge-join over two
> collections producing `[key, valueA, valueB]` triples (missing
> sides get `absentValue`); (3) `makeCompareCollection` factory
> closes over its three args and returns the per-style binary
> comparator using a leftIsBigger/rightIsBigger Pareto pattern with
> early-exit `if (leftIsBigger && rightIsBigger) return NaN`.
>
> The single most structurally interesting move is the §history-
> dependent comparator scoping —
> `makeFullOrderComparatorKit().antiComparator` is built *fresh per
> call* so the deterministic tiebreak for rank-tied remotables is
> scoped to the active invocation. Two concurrent invocations could
> see the same values in different orders without affecting each
> other's result.
>
> The §JSDoc names the forward-looking *virtual-collection
> generalization*: replace `getEntries => Array` with
> `generateEntries => IterableIterator` to support collections that
> don't materialize. The iterator-friendly merge-join algebra
> already supports it; only the API surface needs widening.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison](../sections/endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison.md) | patterns, marshal | current |

The 223-line file is three closely-coupled functions in a strict
private→helper→export chain (`generateFullSortedEntries` →
`generateCollectionPairEntries` → `makeCompareCollection`). The
chain implements one mechanism; splitting would manufacture
boundaries the code refuses to maintain. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@c63b8b709` (`master`) via the
  local bare-clone.
- Last touched 2026-03-26 by Turadg Aleahmad in commit "fix(types):
  compat with strictFunctionTypes".
- Verified file existence and structure via the local bare-clone:
  223 lines / `harden`-decorated, default-import-from-`@endo/harden`
  style.
- **Twentieth comment-fragment ingest.** Pairs structurally with
  cycle 102's `checkKey.js` + cycle 104's `compareKeys.js` + cycle
  110's `copySet.js` + cycle 115's `copyBag.js` to cover the Keys
  substrate's whole comparison surface.
- Cycle 120 was nominally **comments-lane**. Comments-lane is
  active. Papers-lane has been blocked for 14+ consecutive cycles
  (97/100/102/104/106/108/110/112/113/114/116/117/118/119) due to
  lack of PDF-fetching infrastructure.
- One section cohesion-honest count. The three functions form a
  strict private→helper→export chain that implements one mechanism;
  splitting would manufacture boundaries.
