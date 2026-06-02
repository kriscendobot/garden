---
title: The §`confirmNoDuplicates(elements, fullCompare?, reject)` private predicate that builds a fullOrder antiComparator (with the explicit *this fullOrder contains history dependent state ... does not survive the call* discipline) when no explicit comparator is provided, sorts elements by rank, and scans adjacent for equal elements rejecting any duplicate; the §TODO that names the *memoize-no-duplicate-finding* future optimization with explicit *independent of the `fullOrder` use to reach this finding* gloss; the §`assertNoDuplicates(elements, fullCompare?)` public throw-form via `confirmNoDuplicates(..., Fail)`; the §`confirmElements(elements, reject)` three-layer predicate — (1) `passStyleOf(elements) === 'copyArray'` (else *The keys of a copySet or copyMap must be a copyArray*); (2) `isRankSorted(elements, compareAntiRank)` reverse-rank-order required (else *must be sorted in reverse rank order*); (3) delegates to `confirmNoDuplicates(elements, undefined, reject)`; the §`assertElements(elements)` public throw-form *plus* `hideAndHardenFunction(assertElements)` so `.name` doesn't leak; the §`coerceToElements(elementsList)` public factory that takes an iterable, `sortByRank(elementsList, compareAntiRank)` into reverse-rank order, validates via `assertElements`, returns elements; the §`makeSetOfElements(elementIter)` factory that wraps `coerceToElements` with `makeTagged('copySet', ...)` producing a passable CopySet value; the canonical *copySet internal form* invariant — `tagged: 'copySet'` whose payload is a `copyArray` rank-sorted in *reverse* order (`compareAntiRank`) with no duplicates
source: packages/patterns/src/keys/copySet.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-109 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Seventeenth comment-fragment ingest. Kris Kowal-authored
  *copySet element-validation* file — the sibling that cycle 102's
  checkKey.js imports `confirmElements` and `makeSetOfElements`
  from. The 109-line file is the *internal-form-validation* and
  *factory* surface for copySets. Three structurally interesting
  moves: (1) the *history-dependent-state-call-local* discipline
  for the fullOrder antiComparator (built fresh per `confirmNo-
  Duplicates` call when no explicit comparator is provided; the
  comment repeats the discipline introduced in cycle 102's
  `makeCopyBagFromElements`); (2) the *reverse-rank-sorted invariant*
  for copySet keys — `compareAntiRank` not `compareRank`, consistent
  with cycle 84's rankOrder.js and cycle 102's makeCopyBagFromElements
  + makeCopyMap; (3) the *honest-known-perf-limit-with-named-mitigation*
  TODO at the top — *If doing this redundantly turns out to be
  expensive, we could memoize this no-duplicate finding as well,
  independent of the `fullOrder` use to reach this finding*.
  
  Pairs structurally with cycle 102's checkKey.js (which uses this
  file's exports to validate CopySet payloads) and cycle 104's
  compareKeys.js (which uses this file's `getCopySetKeys` indirectly
  via setCompare). Single-section cohesion-honest ingest.
---

## Abstract

The §file opens (lines 1-19) with imports of `harden` and `Fail`/`hideAndHardenFunction` from `@endo/errors`, plus `makeTagged`/`passStyleOf`/`compareAntiRank`/`isRankSorted`/`makeFullOrderComparatorKit`/`sortByRank` from `@endo/marshal`. The §`confirmNoDuplicates(elements, fullCompare?, reject)` private predicate (lines 35-52) is the centerpiece: it builds a fullOrder antiComparator (via `makeFullOrderComparatorKit().antiComparator`) if no explicit `fullCompare` was provided, with the explicit comment naming the *history-dependent-state-call-local* discipline — *This fullOrder contains history dependent state. It is specific to this one call and does not survive it*; sorts elements by rank; scans adjacent pairs for equal elements (`fullCompare(k0, k1) === 0`); rejects duplicates via `reject\`value has duplicate keys: ${k0}\``. The §TODO at the top of this function names a future optimization: *If doing this redundantly turns out to be expensive, we could memoize this no-duplicate finding as well, independent of the `fullOrder` use to reach this finding*. The §`assertNoDuplicates(elements, fullCompare?)` (lines 60-62) is the public throw-form via `confirmNoDuplicates(..., Fail)`. The §`confirmElements(elements, reject)` (lines 69-83) is the three-layer copySet-payload predicate: (1) `passStyleOf(elements) === 'copyArray'` (else *The keys of a copySet or copyMap must be a copyArray*); (2) `isRankSorted(elements, compareAntiRank)` reverse-rank-order required (else *must be sorted in reverse rank order*); (3) delegates to `confirmNoDuplicates(elements, undefined, reject)` for the duplicate-free check. The §`assertElements(elements)` (lines 86-89) is the public throw-form via `confirmElements(..., Fail)` *plus* `hideAndHardenFunction(assertElements)` so `.name` doesn't leak. The §`coerceToElements(elementsList)` (lines 95-100) is the public factory that takes an iterable, `sortByRank(elementsList, compareAntiRank)` into reverse-rank order, validates via `assertElements`, returns the elements array. The §`makeSetOfElements(elementIter)` (lines 107-109) is the public factory that wraps `coerceToElements` with `makeTagged('copySet', ...)` to produce a passable `CopySet` value.

## Body

### §The history-dependent-state-call-local discipline for fullOrder

The §`confirmNoDuplicates` (lines 35-52):

```js
const confirmNoDuplicates = (elements, fullCompare, reject) => {
  // This fullOrder contains history dependent state. It is specific
  // to this one call and does not survive it.
  // TODO Once all our tooling is ready for `&&=`, the following
  // line should be rewritten using it.
  fullCompare = fullCompare || makeFullOrderComparatorKit().antiComparator;

  elements = sortByRank(elements, fullCompare);
  const { length } = elements;
  for (let i = 1; i < length; i += 1) {
    const k0 = elements[i - 1];
    const k1 = elements[i];
    if (fullCompare(k0, k1) === 0) {
      return reject && reject`value has duplicate keys: ${k0}`;
    }
  }
  return true;
};
```

The §two-step *sort-then-adjacent-duplicate-scan* algorithm:

1. **Build the fullOrder antiComparator** (if not provided) via `makeFullOrderComparatorKit().antiComparator`. The §comment names the discipline: *This fullOrder contains history dependent state. It is specific to this one call and does not survive it*. The fullOrder's internal state (which tracks first-seen-position for rank-tied remotables) is *call-local*; when `confirmNoDuplicates` returns, the closure becomes unreferenced and GC'd.
2. **Sort the elements** by the antiComparator. Equal elements (under fullOrder equality) become *adjacent*.
3. **Scan adjacent pairs**: if `fullCompare(k0, k1) === 0`, the elements are duplicates; reject. Otherwise continue.

The §`&&=` TODO comment (lines 38-39):

> Once all our tooling is ready for `&&=`, the following line should be rewritten using it.

The §logical assign-if-falsy operator (`&&=`) would make `fullCompare ||= makeFullOrderComparatorKit().antiComparator` the canonical form. But waiting on full-tooling-support across all SES-targeted environments. The §honest-tooling-readiness deferral is documented inline.

The §`reject && reject\`...\`` short-circuit (cycle 102's introduced Rejector dual-mode pattern) is used here too — silent mode (`reject === false`) skips the template-tag construction; throw mode (`reject === Fail`) constructs and throws.

The §efficiency-TODO at the top (lines 25-31):

> If provided and `elements` is already known to be sorted by this `fullCompare`, then we should get a memo hit rather than a resorting. However, currently, we still enumerate the entire array each time.
>
> TODO: If doing this redundantly turns out to be expensive, we could memoize this no-duplicate finding as well, independent of the `fullOrder` use to reach this finding.

The §two-part observation:

- **Re-sorting is potentially wasteful** when the caller already knows the elements are sorted by the same fullCompare. The §current implementation *always* re-sorts.
- **No-duplicate memoization is a separate optimization** from the fullOrder memoization. The §TODO names them *independent of each other* — they could be combined or done separately.

The §discipline: *name the perf-limit and the mitigation; don't optimize prematurely*. The current code is *correct but not minimal*. Future work can add memoization if measurement shows the cost.

### §The three-layer confirmElements predicate

The §`confirmElements` (lines 69-83):

```js
export const confirmElements = (elements, reject) => {
  if (passStyleOf(elements) !== 'copyArray') {
    return (
      reject &&
      reject`The keys of a copySet or copyMap must be a copyArray: ${elements}`
    );
  }
  if (!isRankSorted(elements, compareAntiRank)) {
    return (
      reject &&
      reject`The keys of a copySet or copyMap must be sorted in reverse rank order: ${elements}`
    );
  }
  return confirmNoDuplicates(elements, undefined, reject);
};
```

The §three layered checks:

1. **`passStyleOf(elements) === 'copyArray'`** — the payload must be a copyArray. Reject with *The keys of a copySet or copyMap must be a copyArray*.
2. **`isRankSorted(elements, compareAntiRank)`** — sorted in *reverse rank order*. Reject with *must be sorted in reverse rank order*.
3. **`confirmNoDuplicates(elements, undefined, reject)`** — no duplicates. `undefined` for fullCompare means *build a fresh fullOrder antiComparator*.

The §error message *…of a copySet or copyMap* names *both* consumers — copySets and copyMaps both store their keys in this same canonical form. The §discipline: *one validation surface serves multiple consumers that share an internal form*.

The §`compareAntiRank` is the *reverse* of `compareRank`. The §invariant: copySet keys are sorted in *anti-rank* (descending rank) order. The §rationale connects to cycle 84's rankOrder.js: the anti-comparator is used because it lets the rank-sorted-array work nicely with `makeCopyBagFromElements`'s adjacent-equality scan (cycle 102) and with `makeCopyMap`'s reverse-rank-sorting (cycle 102).

### §The canonical copySet internal form

The §`coerceToElements` + `makeSetOfElements` (lines 95-109):

```js
export const coerceToElements = elementsList => {
  const elements = sortByRank(elementsList, compareAntiRank);
  assertElements(elements);
  return elements;
};

export const makeSetOfElements = elementIter =>
  makeTagged('copySet', coerceToElements(elementIter));
```

The §canonical copySet construction:

1. **`sortByRank(elementsList, compareAntiRank)`** — produce a *reverse-rank-sorted* array. The input can be any iterable; the output is a deterministic array.
2. **`assertElements(elements)`** — validate the result. Catches *duplicates* (which sorting doesn't eliminate) and *non-key elements* (which sorting can't fix).
3. **`makeTagged('copySet', ...)`** — wrap as a passable tagged value with `tag: 'copySet'` and the elements as payload.

The §canonical copySet shape:

```js
{
  tag: 'copySet',
  payload: [/* reverse-rank-sorted, no duplicates, all keys */]
}
```

The §discipline: *every copySet has the same internal form*. The §`makeSetOfElements` factory is *the* way to construct a copySet; bypassing it would risk creating a malformed value. The §`makeTagged` from `@endo/marshal` produces the canonical passable wrapper.

### §The hideAndHardenFunction discipline

The §`assertElements` (line 89):

```js
hideAndHardenFunction(assertElements);
```

The §discipline (introduced in cycle 102's checkKey.js): the function's `.name` is removed to prevent its leak as an authority discriminator. Same pattern as `isScalarKey`/`assertScalarKey`/`isKey`/`assertKey`/`isCopySet`/`assertCopySet` etc. in checkKey.js.

The §asymmetry note: `confirmElements` is plain `harden(...)`-ed (line 84) but `assertElements` is `hideAndHardenFunction`-wrapped (line 89). The §discipline: *only public assert/is functions need hiding*; internal `confirm` functions don't need hiding because they're not exposed under their own names.

### §The pair-with-cycle-102 checkKey.js

The §lines 10-11 of checkKey.js (from cycle 102):

```js
import { confirmElements, makeSetOfElements } from './copySet.js';
```

The §reciprocal relationship: cycle 102's checkKey.js imports from this file for the CopySet/CopyBag/CopyMap validation. Specifically:

- **`confirmElements`** is used in `confirmCopySet`, `confirmCopyMap` (for the keys array validation).
- **`makeSetOfElements`** is used in `makeCopySet` to produce the canonical CopySet value.

The §design discipline: *the canonical internal form for copySet keys lives in copySet.js; checkKey.js consumes the validation via the imports*. Both files can be read independently; the file boundary is the *canonical form* (this file) vs the *validation trio pattern* (checkKey.js).

The §`getCopyBagEntries` from checkKey.js uses a sibling `./copyBag.js` (which presumably has the analogous `confirmBagEntries` + `makeBagOfEntries`) — same shape, different collection type.

### §The TODO ecosystem

The §file has two TODOs that name future-work with explicit rationale:

1. **`&&= once all tooling ready`** (lines 38-39) — wait for `&&=` operator support across SES-targeted environments.
2. **No-duplicate memoization** (lines 29-31) — *If doing this redundantly turns out to be expensive*; mitigation: memoize independently of fullOrder use.

The §discipline: TODOs that name *the trigger condition* (when to act) plus *the action* (what to do) plus *the rationale* (why it's deferred). Reusable for any *deferred optimization* shape.

## Connection to the wider library

This section is the **canonical *internal-form-with-shared-validation* worked example**. Four threads:

1. **The history-dependent-state-call-local discipline** — fullOrder antiComparator built fresh per call; closure state discarded on return. Reusable for any *transient ordering with sub-rank tiebreakers* shape.

2. **The reverse-rank-sorted invariant for copySet keys** — `compareAntiRank` not `compareRank`. Consistent with cycle 84's rankOrder.js and cycle 102's makeCopyBagFromElements + makeCopyMap. The §discipline: *reverse-rank order positions tied keys adjacently for downstream scan-based algorithms*.

3. **The three-layer confirmElements predicate** — (1) is-copyArray; (2) is-reverse-rank-sorted; (3) no-duplicates. Most-specific-diagnostic-first via `&&` short-circuit. Each layer has its own error message.

4. **The sort-then-adjacent-duplicate-scan algorithm** — `confirmNoDuplicates`. Reusable for any *duplicate-detection in a passable collection* shape.

The §file is part of the @endo/patterns Keys + Collections substrate:

- **Cycle 71** `passStyleOf.js` — provides `passStyleOf` consumed by `confirmElements`.
- **Cycle 81** `encodePassable.js` — rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.
- **Cycle 84** `rankOrder.js` — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- **Cycle 102** `checkKey.js` — uses this file's `confirmElements` + `makeSetOfElements` for CopySet validation.
- **Cycle 104** `compareKeys.js` — uses this file's exports indirectly via `setCompare` (cycle 102's checkKey.js → setCompare).
- **Cycle 110** (this ingest) `copySet.js` — the canonical internal form + validation + factory.

Together cycles 71 + 81 + 84 + 102 + 104 + 110 describe the *full @endo/patterns + marshal Keys + Collections substrate*.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `This fullOrder contains history dependent state ... does not survive it` | The *transient-call-local-comparator* discipline; rebuild fresh per call. |
| `&&= once all our tooling is ready` TODO | The *deferred-modern-syntax-with-named-trigger* TODO pattern. |
| `If doing this redundantly turns out to be expensive ... memoize independent of fullOrder` TODO | The *honest-known-perf-limit-with-named-mitigation* TODO pattern. |
| `compareAntiRank` for copySet keys | The *reverse-rank-sorted invariant* — ties cluster for downstream scan-based algorithms. |
| Three-layer `confirmElements`: copyArray + rank-sorted + no-duplicates | The *most-specific-diagnostic-first via `&&` short-circuit* layered-predicate pattern. |
| `The keys of a copySet or copyMap must be ...` shared error message | The *one-validation-serves-multiple-consumers* discipline; copySet and copyMap share internal form. |
| `hideAndHardenFunction(assertElements)` | The *public-function-name-hiding* discipline; prevents `.name` leak as authority discriminator. |
| `makeTagged('copySet', coercedElements)` | The *canonical-internal-form via factory function* — `makeSetOfElements` is *the* construction path. |
| `sort-then-adjacent-duplicate-scan` | The *duplicate-detection in a passable collection* algorithm; works under any rank-tiebreaking fullOrder. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns Keys + Collections surface.
- `endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion` (cycle 102) — imports `confirmElements` + `makeSetOfElements` from this file for CopySet validation.
- `endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms` (cycle 102) — uses this file's `getCopySetKeys` (indirectly via the cycle-102 CopySet trio).
- `endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order` (cycle 104) — uses CopySet comparison via setCompare which depends on this file's canonical form.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — provides `passStyleOf` for the copyArray check.

## Common confusions

- **"`confirmNoDuplicates` should accept `false` for fullCompare to skip sorting."** It cannot — *no fullCompare means build a fresh fullOrder antiComparator*. The §discipline: sort-then-adjacent-scan is the duplicate-detection algorithm; without sort, adjacent scan misses non-adjacent duplicates. The fullCompare parameter lets a caller *reuse a comparator* across calls; passing `false` would skip the sort entirely, breaking the algorithm.
- **"`compareAntiRank` is just `compareRank` reversed — why have both?"** They're *both used* in different contexts. Rank order is the *default*; anti-rank order positions tied keys adjacently for scan-based algorithms. The two coexist so callers can pick based on the consumer's needs.
- **"`assertNoDuplicates` is private — why is it exported?"** It is exported (line 60) but not commonly called by users. It's a *narrow primitive* for code that has already-sorted elements and just needs the duplicate check. The §discipline: *expose the narrow primitive for advanced consumers*; the canonical path is `coerceToElements + makeSetOfElements`.
- **"`makeTagged('copySet', ...)` is just a wrapper — why have a factory?"** The factory ensures the *internal form invariant* (sorted, no duplicates, all keys). A user constructing `makeTagged('copySet', [...])` directly might produce a malformed copySet. The factory is the *blessed* construction path.
- **"`confirmElements` is also used for copyMap — that's coupling."** The §discipline names this explicitly: *The keys of a copySet or copyMap must be a copyArray*. Both collections share the same key-array discipline; consolidating the validation prevents drift. The §error message *…of a copySet or copyMap* makes the shared use visible.
- **"The `&&=` TODO is just style preference."** It is — and the §discipline waits for *all tooling ready*. The TODO documents *when to apply* (tooling readiness) so a future maintainer doesn't apply it prematurely on environments that lack support.
- **"`coerceToElements` could just call `confirmElements`."** It cannot — `confirmElements` requires *already-sorted* input. `coerceToElements` *sorts first, then validates*. The two functions handle different input shapes: pre-sorted (confirmElements) vs unsorted iterable (coerceToElements).
- **"`fullCompare(k0, k1) === 0` for duplicate detection — what if the comparator returns `-0`?"** JavaScript's `===` treats `-0 === 0` as `true`, so the check works. The §implementation accepts either `+0` or `-0` from the comparator as the equal-signal.
- **"`elements = sortByRank(elements, fullCompare)` mutates the input array."** It doesn't — `sortByRank` returns a *new* sorted array; the local `elements` parameter binding is reassigned to the new array. The caller's array is unchanged.
- **"`makeFullOrderComparatorKit().antiComparator` creates allocations per call — that's wasteful."** It is — and §intentionally accepted. The §`fullCompare` parameter lets callers pass an externally-managed comparator to amortize the cost. The default path (no fullCompare) prioritizes *correctness via call-local state* over *allocation cost*.
