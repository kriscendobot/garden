---
title: Body
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
parent: endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count
---

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
