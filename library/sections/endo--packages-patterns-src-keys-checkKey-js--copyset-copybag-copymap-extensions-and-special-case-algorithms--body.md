---
title: Body
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
source_lines: "105-481 (CopySet + CopyBag + CopyMap sections including makeCopyBagFromElements, makeCopyMap, getCopyMapEntries Far iterator, copyMapKeySet shortcut)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  The three-collection extension surface of @endo/patterns/keys.
  Three structural ideas: (1) the §Confirm/Is/Assert trio pattern
  (introduced in the previous section) is *uniformly applied* to
  CopySet, CopyBag, and CopyMap — each gets its own memo WeakSet,
  confirm/is/assert trio, and structural-payload validation; (2) the
  §makeCopyBagFromElements algorithm is a worked example of
  *sort-then-adjacent-counting* (sortByRank + while-equal-advance),
  with explicit *history-dependent state ... does not survive*
  warning for the fullCompare; (3) the §makeCopyMap algorithm uses
  *reverse rank sorting* via compareAntiRank to colocate keys with
  values, including an honest TODO about the *copyMap cover issue
  in patternMatchers.js* that depends on additional validation.
  The §`getCopyMapEntries` returning a `Far(iterable)` exotic
  rather than an array is the *lazy-iteration-with-immutability*
  discipline. The §`copyMapKeySet` is the *internal-form-shortcut*
  — a copyMap's keys are *already* in copySet's internal form, so
  the conversion is a tag-wrap-only operation with no
  re-validation.
parent: endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms
---

### §The uniform Confirm/Is/Assert trio across three collections

The §three sections (CopySet / CopyBag / CopyMap) apply the same Confirm/Is/Assert trio pattern from section 1, each with its own memo WeakSet:

| Collection | Memo | Confirm | Is | Assert | Getter | Every | Constructor |
|---|---|---|---|---|---|---|---|
| `copySet` | `copySetMemo` | `confirmCopySet` | `isCopySet` | `assertCopySet` | `getCopySetKeys` | `everyCopySetKey` | `makeCopySet` |
| `copyBag` | `copyBagMemo` | `confirmCopyBag` | `isCopyBag` | `assertCopyBag` | `getCopyBagEntries` | `everyCopyBagEntry` | `makeCopyBag` + `makeCopyBagFromElements` |
| `copyMap` | `copyMapMemo` | `confirmCopyMap` | `isCopyMap` | `assertCopyMap` | `getCopyMapKeys`+`getCopyMapValues`+`getCopyMapEntryArray`+`getCopyMapEntries` | `everyCopyMapKey`+`everyCopyMapValue` | `makeCopyMap` |

The §discipline: *one pattern, three uniformly applied instances*. The §scholar reading this file in order sees the pattern once in section 1 and then recognizes it three more times. Each collection adds its own *structural payload validation* but shares the trio shape.

The §comment that introduces each collection section (`Moved to here so they can check that the copySet contains only keys / copyBag contains only keys / copyMap's keys contains only keys without creating an import cycle`) is structurally significant: the §collections live in their own files (`copySet.js`, `copyBag.js`) but the *Key validation* lives here in `checkKey.js`. Moving the collection-validation functions here breaks an *import cycle* that would otherwise exist (collection-files would need to import Key validation; Key validation would need to import collection structure-validation).

### §The CopySet structural payload validation

The §`confirmCopySet` (lines 118-131):

```js
export const confirmCopySet = (s, reject) => {
  if (copySetMemo.has(s)) return true;
  const result =
    ((passStyleOf(s) === 'tagged' && getTag(s) === 'copySet') ||
      (reject && reject`Not a copySet: ${s}`)) &&
    confirmElements(s.payload, reject) &&
    confirmKey(s.payload, reject);
  if (result) copySetMemo.add(s);
  return result;
};
```

The §three layered checks:

1. **Tag check** — `passStyleOf(s) === 'tagged' && getTag(s) === 'copySet'`. Discriminator for the copySet shape.
2. **Payload structure** — `confirmElements(s.payload, reject)` (imported from `./copySet.js`) validates that the payload is rank-ordered without duplicates.
3. **Payload contents** — `confirmKey(s.payload, reject)` validates that the payload (the elements array) is itself a key (which recursively means every element is a key).

The §`reject && reject\`...\`` short-circuit at the tag-check layer captures the *not-a-copySet* diagnostic. Subsequent layers (`confirmElements`, `confirmKey`) produce their own diagnostics for *element-level* failures.

The §memo-positive-only discipline: the *first* call constructs the result via the three-layer check; the *cache add* happens only on positive. Negative calls re-evaluate, ensuring a later `assertCopySet` after a silent `isCopySet` gets the diagnostic.

### §The CopyBag sort-then-adjacent-counting algorithm

The §`makeCopyBagFromElements` (lines 268-290) is the most algorithmically interesting function in the file:

```js
export const makeCopyBagFromElements = elementIter => {
  // This fullOrder contains history dependent state. It is specific
  // to this one call and does not survive it.
  const fullCompare = makeFullOrderComparatorKit().antiComparator;
  const sorted = sortByRank(elementIter, fullCompare);
  /** @type {[K,bigint][]} */
  const entries = [];
  for (let i = 0; i < sorted.length; ) {
    const k = sorted[i];
    let j = i + 1;
    while (j < sorted.length && fullCompare(k, sorted[j]) === 0) {
      j += 1;
    }
    entries.push([k, BigInt(j - i)]);
    i = j;
  }
  return makeCopyBag(entries);
};
```

The §algorithm:

1. **Build a fullOrder antiComparator** for this call. The §comment names the *history-dependent state* warning: the comparator's internal state (which tracks first-seen-order for remotables that share a rank) is *call-local* and does not survive the call.
2. **Sort all elements** by the antiComparator (reverse rank order).
3. **Two-pointer scan** for adjacent-equal runs. `i` is the start of the current equivalence class; `j` advances while `fullCompare(k, sorted[j]) === 0` (the elements are full-order-equal). At the end of the run, push `[k, BigInt(j - i)]` to entries and continue from `j`.
4. **Build the copyBag** via `makeCopyBag(entries)`.

The §rationale for fullOrder (vs rank order): rank order has *equivalence classes* — two remotables with the same rank are *tied* under rankOrder. A *bag* needs to count each *distinct* element separately even when they're rank-tied. The fullOrder breaks rank-ties by first-seen-position, so two remotables are *distinct* under fullCompare; the adjacent-equality scan correctly counts each as its own bag-entry.

The §`BigInt(j - i)` shape: copyBag entries use bigint counts (not numbers) so they can represent arbitrarily-large multiplicities without floating-point precision loss.

The §history-dependent-but-call-local discipline is reusable for any *transient sorting that needs ordering beyond rank*. The comparator is constructed fresh per call; the *history* accumulated inside is discarded when the call returns.

### §The CopyMap structural payload validation

The §`confirmCopyMap` (lines 305-333):

```js
export const confirmCopyMap = (m, reject) => {
  if (copyMapMemo.has(m)) return true;
  if (!(passStyleOf(m) === 'tagged' && getTag(m) === 'copyMap')) {
    return reject && reject`Not a copyMap: ${m}`;
  }
  const { payload } = m;
  if (passStyleOf(payload) !== 'copyRecord') {
    return reject && reject`A copyMap's payload must be a record: ${m}`;
  }
  const { keys, values, ...rest } = payload;
  const result =
    (ownKeys(rest).length === 0 ||
      (reject &&
        reject`A copyMap's payload must only have .keys and .values: ${m}`)) &&
    confirmElements(keys, reject) &&
    confirmKey(keys, reject) &&
    (passStyleOf(values) === 'copyArray' ||
      (reject && reject`A copyMap's .values must be a copyArray: ${m}`)) &&
    (keys.length === values.length ||
      (reject &&
        reject`A copyMap must have the same number of keys and values: ${m}`));
  if (result) copyMapMemo.add(m);
  return result;
};
```

The §five-layer check:

1. **Tag check** — `tagged: 'copyMap'`.
2. **Payload-is-record check** — `passStyleOf(payload) === 'copyRecord'`.
3. **Only-keys-and-values invariant** — destructure `{ keys, values, ...rest }`; assert `ownKeys(rest).length === 0`. The §rest-spread + ownKeys-zero idiom is the *no-extra-properties* discipline; any property other than `keys` and `values` makes the copyMap invalid.
4. **Keys-are-rank-ordered + keys-are-keys** — `confirmElements(keys, reject) && confirmKey(keys, reject)`.
5. **Values-is-copyArray + same-length** — `passStyleOf(values) === 'copyArray'` and `keys.length === values.length`.

The §five-layer chain via `&&` short-circuits on the first failure, producing the *most-specific* diagnostic for the failure mode. The §discipline: each layer has its own diagnostic so the caller can tell *which* invariant was violated.

The §`ownKeys(rest).length === 0` invariant catches the case where a copyMap was constructed with extra metadata — a future maintainer adding fields would need to update this check. The §strict-record discipline avoids accidental property leakage.

### §The Far iterator for getCopyMapEntries

The §`getCopyMapEntries` (lines 398-424):

```js
export const getCopyMapEntries = m => {
  assertCopyMap(m);
  const {
    payload: { keys, values },
  } = m;
  const { length } = /** @type {Array} */ (keys);
  return Far('CopyMap entries iterable', {
    [Symbol.iterator]: () => {
      let i = 0;
      return Far('CopyMap entries iterator', {
        next: () => {
          let result;
          if (i < length) {
            result = harden({ done: false, value: [keys[i], values[i]] });
            i += 1;
            return result;
          } else {
            result = harden({ done: true, value: undefined });
          }
          return result;
        },
      });
    },
  });
};
```

The §structure:

- **Outer `Far('CopyMap entries iterable', { [Symbol.iterator]: ... })`** — the iterable object exposing `Symbol.iterator`.
- **Inner `Far('CopyMap entries iterator', { next: ... })`** — the iterator object exposing `next()`.
- **Per-step `harden({ done, value })`** — each `next()` result is freshly hardened.

The §discipline: every yielded value is a *hardened pair* `[keys[i], values[i]]`; the iterator is itself a Far-exotic (cross-realm-passable, frozen, capability-conformant).

The §contrast with `getCopyMapEntryArray` (lines 383-390) which returns a *hardened-array* of all entries upfront:

```js
export const getCopyMapEntryArray = m => {
  assertCopyMap(m);
  const { payload: { keys, values } } = m;
  return harden(keys.map((key, i) => [key, values[i]]));
};
```

The §two shapes:

- **`getCopyMapEntryArray`** — eager array; convenient for consumers that need random-access or want to use `Array.prototype.*` directly.
- **`getCopyMapEntries`** — lazy iterable; convenient for consumers that just want to iterate once and may want to early-exit.

The §design intent: *offer both shapes; let the consumer pick*. The §lazy form avoids allocating the entries array when the consumer iterates only partway.

### §The makeCopyMap reverse-rank-sort and TODO

The §`makeCopyMap` (lines 465-481):

```js
export const makeCopyMap = entries => {
  // This is weird, but reverse rank sorting the entries is a good first step
  // for getting the rank sorted keys together with the values
  // organized by those keys. Also, among values associated with
  // keys in the same equivalence class, those are rank sorted.
  // TODO This
  // could solve the copyMap cover issue explained in patternMatchers.js.
  // But only if we include this criteria in our validation of copyMaps,
  // which we currently do not.
  const sortedEntries = sortByRank(entries, compareAntiRank);
  const keys = sortedEntries.map(([k, _v]) => k);
  const values = sortedEntries.map(([_k, v]) => v);
  const result = makeTagged('copyMap', { keys, values });
  assertCopyMap(result);
  return result;
};
```

The §comment names the algorithm and its limitation:

> Reverse rank sorting the entries is a good first step for getting the rank sorted keys together with the values organized by those keys. Also, among values associated with keys in the same equivalence class, those are rank sorted.
>
> TODO This could solve the copyMap cover issue explained in patternMatchers.js. But only if we include this criteria in our validation of copyMaps, which we currently do not.

The §two-step algorithm:

1. **Sort entries by `compareAntiRank`** (reverse rank order). The §benefit: rank-tied keys are *adjacent* in the sorted entries.
2. **Project to parallel arrays** — `keys = sorted.map(([k,_]) => k)`, `values = sorted.map(([_,v]) => v)`. The two arrays preserve the sort order; values stay paired with their keys.

The §TODO acknowledges *the copyMap cover issue explained in patternMatchers.js*. The cover issue is a known limit in the @endo/patterns matcher infrastructure related to how copyMaps fit into rank-order bounding. The §discipline: the construction algorithm *would help* if validation also enforced the *adjacent-tied-keys-have-rank-sorted-values* invariant — but the current validation doesn't. The TODO is *honest about the dependency*.

The §design intent: the algorithm is *correct for the construction we control*; the validation accepts copyMaps that don't follow the discipline; the gap is named but not closed. Future work that adds the validation criterion would close the gap.

### §The copyMapKeySet internal-form-shortcut

The §`copyMapKeySet` (lines 454-457):

```js
export const copyMapKeySet = m =>
  // A copyMap's keys are already in the internal form used by copySets.
  makeTagged('copySet', m.payload.keys);
```

The §three-line discipline:

- **The function takes a copyMap and returns a copySet of its keys**.
- **No re-validation needed** — the comment names the structural invariant: *a copyMap's keys are already in the internal form used by copySets*.
- **Construction is a tag-wrap-only operation** — `makeTagged('copySet', m.payload.keys)` reuses the same underlying array; no copy, no sort, no validation.

The §rationale: copyMaps and copySets share the *rank-ordered + key-array* internal form. The copyMap's `keys` payload is *exactly* what a copySet's `payload` is. So extracting the keys is a O(1) tag-rewrite, not a O(n) reconstruction.

The §discipline is reusable for any *shared-internal-form* between two related collections — the conversion is a tag-rewrite, not a copy. The §performance benefit is meaningful for large copyMaps.

The §implicit invariant: the caller-or-builder is responsible for ensuring the copyMap was *constructed* with the proper keys discipline (rank-ordered, no duplicates, all keys are keys). If the copyMap was somehow constructed without this discipline (which `assertCopyMap` would reject), the resulting copySet would be *malformed* — but the runtime accepts the assumption because validation has already passed.
