---
title: Body
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
parent: endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form
---

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
