---
title: The §`confirmNoDuplicateKeys(bagEntries, fullCompare?, reject)` private predicate — sister to cycle 110's `confirmNoDuplicates` — that builds a fullOrder antiComparator (with the canonical *this fullOrder contains history dependent state ... does not survive the call* discipline), sorts entries by rank, and scans adjacent for duplicate *keys* (entry[0]); the §key-significance-over-value comment — *Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts* — encoding the fullOrder's lexicographic-key-first composite-key behavior; the §`assertNoDuplicateKeys` public throw-form; the §`confirmBagEntries(bagEntries, reject)` five-layer predicate — (1) `passStyleOf === 'copyArray'`; (2) `isRankSorted(..., compareAntiRank)` reverse-rank-order required; (3) per-entry-shape `passStyleOf(entry) === 'copyArray' && entry.length === 2 && typeof entry[1] === 'bigint'` (else *Each entry of a copyBag must be pair of a key and a bigint representing a count*); (4) per-entry-positive-count `entry[1] >= 1` (else *Each entry of a copyBag must have a positive count*); (5) delegates to `confirmNoDuplicateKeys`; the §`assertBagEntries` public throw-form with `hideAndHardenFunction`; the §`coerceToBagEntries(bagEntriesList)` factory that sorts iterable into reverse-rank order + validates; the §`makeBagOfEntries(bagEntryIter)` factory that wraps `coerceToBagEntries` with `makeTagged('copyBag', ...)` producing a passable CopyBag value; the canonical *copyBag internal form* invariant — `tagged: 'copyBag'` whose payload is a copyArray of `[key, count: bigint]` 2-tuples, rank-sorted in reverse-order, no duplicate keys, every count >= 1n
source: packages/patterns/src/keys/copyBag.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-137 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Eighteenth comment-fragment ingest. Kris Kowal-authored
  *copyBag entry-validation* file — *the* sister file to cycle
  110's `copySet.js`. The 136-line file is the canonical
  *internal-form-validation + factory* surface for copyBags. Same
  shape as cycle 110's copySet.js but with two bag-specific
  additions: (1) per-entry-shape validation (each entry is a
  2-element copyArray with bigint count); (2) per-entry-positive-
  count validation (count >= 1n). Three structurally interesting
  moves: (1) the *key-significance-over-value* comment — *Since
  the key is more significant than the value (the count), sorting
  by fullOrder is guaranteed to make duplicate keys adjacent
  independent of their counts* — encodes the fullOrder's
  lexicographic-key-first composite-key behavior on `[key, count]`
  tuples; (2) the *five-layer-confirmBagEntries* (vs cycle 110's
  three-layer confirmElements) — adds per-entry-shape + per-entry-
  positive-count; (3) the *one-discipline-shared-across-
  implementations* pattern repeats — the §history-dependent-state-
  call-local + §reverse-rank-sorted invariant from copySet.js
  appear verbatim here.
  
  Single-section cohesion-honest ingest. Pairs structurally with
  cycle 110's copySet.js (this file is the *bag-analog*; together
  they describe the canonical internal-form for the two CopyTagged
  Key-set collections — CopySet stores keys, CopyBag stores
  [key, count] entries).
---

## Abstract

The §file opens (lines 1-19) with imports identical to cycle 110's `copySet.js`: `harden`, `Fail`+`hideAndHardenFunction` from `@endo/errors`, plus `makeTagged`/`passStyleOf`/`compareAntiRank`/`isRankSorted`/`makeFullOrderComparatorKit`/`sortByRank` from `@endo/marshal`. The §`confirmNoDuplicateKeys(bagEntries, fullCompare?, reject)` private predicate (lines 35-55) is the centerpiece — sister to cycle 110's `confirmNoDuplicates`: builds a fullOrder antiComparator if not provided (with the canonical *this fullOrder contains history dependent state ... does not survive the call* discipline); sorts entries by rank; scans adjacent for duplicate *keys* by comparing `bagEntries[i-1][0]` and `bagEntries[i][0]`. The §key-significance-over-value comment (lines 42-44): *Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts*. The §`assertNoDuplicateKeys` (lines 63-65) is the public throw-form via `confirmNoDuplicateKeys(..., Fail)`. The §`confirmBagEntries(bagEntries, reject)` (lines 72-105) is the *five-layer* predicate (vs cycle 110's three-layer `confirmElements`): (1) `passStyleOf === 'copyArray'`; (2) `isRankSorted(..., compareAntiRank)` reverse-rank-order required; (3) per-entry-shape — each entry must be a 2-element copyArray with bigint count (`passStyleOf(entry) === 'copyArray' && entry.length === 2 && typeof entry[1] === 'bigint'`); (4) per-entry-positive-count — `entry[1] >= 1` (else *Each entry of a copyBag must have a positive count*); (5) delegates to `confirmNoDuplicateKeys` for the no-duplicate-keys check. The §`assertBagEntries` (lines 113-116) is the public throw-form *plus* `hideAndHardenFunction` so `.name` doesn't leak. The §`coerceToBagEntries(bagEntriesList)` (lines 122-127) is the public factory — sorts iterable into reverse-rank order, validates via `assertBagEntries`, returns the entries array. The §`makeBagOfEntries(bagEntryIter)` (lines 134-136) is the public factory wrapping `coerceToBagEntries` with `makeTagged('copyBag', ...)` to produce a passable `CopyBag` value.

## Body

### §The key-significance-over-value discipline

The §lines 42-44:

> Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts.

The §canonical observation about how fullOrder behaves on composite-key (`[key, count]`) tuples:

- **Tuples are sorted lexicographically** — first by the first element (the key), then by the second (the count).
- **Duplicate keys cluster adjacently** — regardless of their count values. Two entries `[k, 3n]` and `[k, 7n]` will be adjacent after the sort because they share the first element.
- **The duplicate-check looks at keys only** — `fullCompare(k0, k1) === 0` where `k0 = bagEntries[i-1][0]` and `k1 = bagEntries[i][0]`.

The §discipline ensures: *duplicate-keys with different counts are detected as duplicates*. The bag invariant is *one entry per key*; multiple entries with the same key are malformed. The sort-and-adjacent-scan algorithm finds them regardless of count differences.

The §rationale connects to cycle 84's `rankOrder.js`: rank order on copyArrays is *lexicographic by element-wise rank order*. So sorting `[[k1, c1], [k2, c2], ...]` by anti-rank produces an array where elements are primarily sorted by `k_i` (the first elements). Duplicate keys land adjacent.

### §The five-layer confirmBagEntries predicate

The §`confirmBagEntries` (lines 72-105):

```js
export const confirmBagEntries = (bagEntries, reject) => {
  if (passStyleOf(bagEntries) !== 'copyArray') {
    return (
      reject &&
      reject`The entries of a copyBag must be a copyArray: ${bagEntries}`
    );
  }
  if (!isRankSorted(bagEntries, compareAntiRank)) {
    return (
      reject &&
      reject`The entries of a copyBag must be sorted in reverse rank order: ${bagEntries}`
    );
  }
  for (const entry of bagEntries) {
    if (
      passStyleOf(entry) !== 'copyArray' ||
      entry.length !== 2 ||
      typeof entry[1] !== 'bigint'
    ) {
      return (
        reject &&
        reject`Each entry of a copyBag must be pair of a key and a bigint representing a count: ${entry}`
      );
    }
    if (entry[1] < 1) {
      return (
        reject &&
        reject`Each entry of a copyBag must have a positive count: ${entry}`
      );
    }
  }
  return confirmNoDuplicateKeys(bagEntries, undefined, reject);
};
```

The §five layered checks:

1. **`passStyleOf(bagEntries) === 'copyArray'`** — the payload must be a copyArray. Reject with *The entries of a copyBag must be a copyArray*.
2. **`isRankSorted(bagEntries, compareAntiRank)`** — sorted in reverse rank order. Reject with *must be sorted in reverse rank order*.
3. **Per-entry shape** — each entry must be a 2-element copyArray with bigint count. Three conjoint conditions:
   - `passStyleOf(entry) === 'copyArray'`
   - `entry.length === 2`
   - `typeof entry[1] === 'bigint'`
4. **Per-entry positive count** — `entry[1] >= 1`. Reject with *Each entry of a copyBag must have a positive count*.
5. **`confirmNoDuplicateKeys(bagEntries, undefined, reject)`** — no duplicate keys.

The §`for ... of` loop runs layers 3 + 4 per entry; the first malformed entry triggers the reject. The §`continue` semantic doesn't apply (the function returns on first failure).

The §discipline: *additive validation*. Each layer adds a constraint that wouldn't make sense without the prior layers. Layer 3 (per-entry shape) only makes sense if Layer 1 (top-level copyArray) passed; Layer 4 (positive count) only makes sense if Layer 3 (per-entry shape) passed.

The §contrast with cycle 110's `confirmElements` (three-layer): copySet payloads are *just keys* (no count); copyBag payloads are *[key, count] tuples* (per-entry shape + per-entry positive count add two more layers).

### §The positive-count discipline

The §line 96: *`if (entry[1] < 1) ... must have a positive count*.

The §discipline: counts in a bag must be `>= 1n`. The §rationale:

- **Count 0n** — represents *zero copies of the key*. Semantically *no entry*. Including a 0-count entry would be malformed; the entry shouldn't exist.
- **Negative counts** — make no semantic sense for a multi-set. Bags are collections-with-multiplicity; negative multiplicity isn't part of the model.

The §canonical bag-semantics: *a bag is a function from keys to positive bigint counts*. Entries are *materialized counts*; absent entries are *count 0*. The validation enforces this materialization rule — entries that should be *absent* (count 0) must literally be absent, not present-with-count-0.

The §note on bigint-vs-number: the count is `bigint` (per layer 3 — `typeof entry[1] === 'bigint'`), supporting arbitrarily-large multiplicities. The §comparison `entry[1] < 1` uses bigint comparison (JavaScript's `<` works on bigints).

### §The factory functions

The §`coerceToBagEntries` (lines 122-127):

```js
export const coerceToBagEntries = bagEntriesList => {
  const bagEntries = sortByRank(bagEntriesList, compareAntiRank);
  assertBagEntries(bagEntries);
  return bagEntries;
};
```

Same three-step shape as cycle 110's `coerceToElements`:

1. **Sort by reverse-rank order** — `sortByRank(..., compareAntiRank)`.
2. **Validate** — `assertBagEntries` runs all five layers.
3. **Return**.

The §`makeBagOfEntries` (lines 134-136):

```js
export const makeBagOfEntries = bagEntryIter =>
  makeTagged('copyBag', coerceToBagEntries(bagEntryIter));
```

Same wrap-with-makeTagged shape as cycle 110's `makeSetOfElements`. The §discipline: *every CopyBag has the same internal form*. The §`makeBagOfEntries` factory is *the* construction path; bypassing it would risk creating a malformed copyBag.

The §canonical copyBag shape:

```js
{
  tag: 'copyBag',
  payload: [
    /* reverse-rank-sorted `[key, count]` 2-tuples,
       no duplicate keys, every count >= 1n */
    [keyA, 5n],
    [keyB, 3n],
    [keyC, 1n],
    // ...
  ]
}
```

### §The pair-with-cycle-110-copySet.js

The §reciprocal relationship: cycle 110's `copySet.js` and cycle 115's `copyBag.js` (this ingest) are *exact siblings* by the same author at the same commit. Both files follow the same shape:

| Aspect | copySet.js (cycle 110) | copyBag.js (this) |
|---|---|---|
| Private no-duplicate predicate | `confirmNoDuplicates(elements, fullCompare?, reject)` | `confirmNoDuplicateKeys(bagEntries, fullCompare?, reject)` |
| Public throw-form | `assertNoDuplicates` | `assertNoDuplicateKeys` |
| Multi-layer payload predicate | `confirmElements` (3 layers) | `confirmBagEntries` (5 layers) |
| Public throw-form | `assertElements` | `assertBagEntries` |
| Coerce-iterable factory | `coerceToElements` | `coerceToBagEntries` |
| Tagged-value factory | `makeSetOfElements` → `tagged: 'copySet'` | `makeBagOfEntries` → `tagged: 'copyBag'` |

The §differences are the *bag-specific additions*: per-entry shape (each entry is a 2-tuple, not a single key); per-entry positive count; key-significance-over-value commentary on the fullOrder behavior.

The §discipline: *the canonical internal form for copyBag entries lives in copyBag.js; cycle 102's checkKey.js consumes the validation via the imports*. checkKey.js's line 11 imports both `confirmBagEntries` (this file) and `makeBagOfEntries` (this file).

### §The hideAndHardenFunction discipline (repeat)

The §`assertBagEntries` (line 116):

```js
hideAndHardenFunction(assertBagEntries);
```

Same pattern as cycle 110 + checkKey.js + compareKeys.js: public assert/is functions have `.name` hidden to prevent leak as authority discriminator. The §asymmetry: `confirmBagEntries` (line 106) is plain `harden(...)`; only the public `assert*` form is `hideAndHardenFunction`-wrapped.

### §The TODO ecosystem (parallel with cycle 110)

The §file has the same two TODOs as cycle 110's copySet.js:

1. **`&&= once tooling ready`** (lines 38-39) — wait for `&&=` operator support.
2. **No-duplicate memoization** (lines 29-31) — *If doing this redundantly turns out to be expensive*; mitigation: memoize independent of fullOrder.

The §parallel TODOs reflect the *one-discipline-shared-across-implementations* pattern. The same future-work shape applies to both files; if a maintainer addresses one, they likely address the other.

## Connection to the wider library

This section is the **canonical *bag-analog-of-set-validation* worked example**. Four threads:

1. **The five-layer-vs-three-layer additive validation discipline** — copyBag's `confirmBagEntries` adds *two layers* on top of copySet's `confirmElements`: per-entry shape + per-entry positive count. The §pattern: *richer payload shape → more validation layers*.

2. **The key-significance-over-value discipline** — *Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts*. Reusable for any *composite-key-tuple-sort with key-significance* situation.

3. **The positive-count bag-semantics invariant** — counts must be `>= 1n`. Absent keys mean count-zero; materialized entries must have positive counts. Reusable for any *multi-set with no-zero-entries* model.

4. **The sister-file design discipline** — copyBag.js mirrors copySet.js in structure; same Author + same commit + same idioms (history-dependent-state-call-local, reverse-rank-sorted, lenient via Rejector, hideAndHardenFunction on public asserts). The §one-discipline-shared-across-implementations pattern.

The §library context after this cycle:

- **Cycle 71** `passStyleOf.js` — provides `passStyleOf` consumed by `confirmBagEntries`.
- **Cycle 81** `encodePassable.js` — rank-order-preserving encoder; consistent invariant.
- **Cycle 84** `rankOrder.js` — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit`.
- **Cycle 102** `checkKey.js` — uses both this file's `confirmBagEntries` + `makeBagOfEntries` *and* `confirmElements` + `makeSetOfElements` (from cycle 110's copySet.js).
- **Cycle 104** `compareKeys.js` — uses `getCopyBagEntries` via bagCompare.
- **Cycle 110** `copySet.js` — set-sibling of this file.
- **Cycle 115** (this ingest) `copyBag.js` — the canonical internal form + validation + factory for CopyBag.

Together seven cycles describe the *full @endo/patterns + marshal Keys + Collections substrate* including both CopySet and CopyBag.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent` | The *composite-key-tuple-sort with key-significance* discipline; lexicographic-key-first sort. |
| `confirmNoDuplicateKeys` (vs copySet's `confirmNoDuplicates`) | The *sister-file-with-renamed-predicate* pattern; bag entries use `[key, count]` tuples. |
| Five-layer `confirmBagEntries` (copyArray + sorted + entry-shape + positive-count + no-duplicate-keys) | The *additive-validation-layers* discipline; richer payload → more layers. |
| `Each entry of a copyBag must be pair of a key and a bigint representing a count` | The *per-entry-shape* validation; 2-element copyArray + bigint count. |
| `Each entry of a copyBag must have a positive count` (`entry[1] < 1`) | The *positive-count* invariant for multi-set entries; count-0 means absent-entry. |
| `bigint` count vs number | The *arbitrary-large-multiplicity* discipline; supports counts beyond `Number.MAX_SAFE_INTEGER`. |
| `confirmNoDuplicateKeys(bagEntries, undefined, reject)` delegation | The *layer-5-delegates-to-sibling-predicate* shape. |
| `hideAndHardenFunction(assertBagEntries)` | Same as cycle 110 + checkKey.js + compareKeys.js. |
| Parallel TODOs (`&&=` + memoize-no-duplicate-finding) | The *one-discipline-shared-across-implementations* pattern. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns Keys + Collections surface.
- `endo--packages-patterns-src-keys-copyset-js--*` (cycle 110) — **the sister file**; same author, same commit, same idioms; differs in lacking per-entry shape + positive-count validation.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — imports `confirmBagEntries` + `makeBagOfEntries` from this file for CopyBag validation.
- `endo--packages-patterns-src-keys-compareKeys-js--*` (cycle 104) — uses `getCopyBagEntries` via `bagCompare`.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.

## Common confusions

- **"`confirmBagEntries` could just delegate to `confirmElements` plus an entry-shape check."** It could not — `confirmElements` checks that *the array elements are themselves keys*, but bag entries are `[key, count]` tuples (not keys). The duplicate-check also differs: bag's `confirmNoDuplicateKeys` compares `entry[0]` (the key) only; set's `confirmNoDuplicates` compares the whole element.
- **"Count 0 entries should be allowed — they just mean zero copies."** They should *not* be present. The §discipline: *absent keys mean count-zero; materialized entries must have positive counts*. Including count-0 entries would be redundant and would invite ambiguity (is the entry there or not?).
- **"`entry[1] < 1` uses number comparison — but the count is bigint."** JavaScript's `<` works on bigints. The comparison `bigint < 1` returns true for `0n`, `-1n`, etc. The `1` literal is coerced to `1n` for the bigint comparison (or compared per JS bigint semantics; either way the check is correct).
- **"`fullCompare(k0, k1)` on the keys-only might miss duplicate entries with different counts."** It doesn't — *duplicate keys with different counts are still duplicates*. The §discipline: *the bag invariant is one entry per key*. An array containing `[k, 3n]` and `[k, 7n]` has duplicate keys (the count difference doesn't matter for the invariant).
- **"Sister-file copyBag.js is just copySet.js with tweaks."** It's *systematically parallel* — same author + same commit + same idioms. The differences are *bag-specific* (per-entry shape + positive-count + key-significance comment) but the overall structure is identical.
- **"Why `confirmBagEntries` not `confirmEntries`?"** Because *entries* is ambiguous (could be Map entries, Set entries, etc.). *BagEntries* is *the specific shape used by bags*: `[key, count]` 2-tuples. The §discipline: *name the predicate by its specific accepted-shape*.
- **"`makeBagOfEntries` is just a one-liner — why not inline it?"** Same rationale as cycle 110's `makeSetOfElements`: it's *the canonical construction path*. A user constructing `makeTagged('copyBag', [...])` directly might produce a malformed bag. The factory is the *blessed* path.
- **"The reverse-rank-sorted invariant is over-engineered for bags."** It serves the *adjacent-equality-scan* algorithm in `confirmNoDuplicateKeys`. Without sorting, duplicate-detection would be O(n²); with sort + adjacent-scan, it's O(n log n) plus O(n).
- **"`assertBagEntries` uses `asserts` TypeScript syntax — TS overhead."** The `asserts` annotation is purely *type-narrowing*; no runtime cost. It tells TypeScript that *after this call, the bag entries are validated*; the subsequent code can treat them as such.
- **"Two TODOs identical to copySet.js means copy-paste sloppiness."** It means *the same discipline applies to both files*. If the maintainer addresses the `&&=` future-work or the memoization optimization in one file, they likely address it in the other. The §one-discipline-shared-across-implementations pattern.
