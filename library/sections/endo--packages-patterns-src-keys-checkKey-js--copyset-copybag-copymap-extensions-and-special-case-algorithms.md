---
title: The §CopySet section that applies the Confirm/Is/Assert trio to the `tagged: 'copySet'` shape — `copySetMemo` WeakSet + `confirmCopySet` checking tag-match + delegating to sibling `confirmElements`/`confirmKey` for payload validation; the §CopyBag section that mirrors CopySet's shape for `tagged: 'copyBag'`; the §`makeCopyBagFromElements` algorithm — `sortByRank` against `makeFullOrderComparatorKit().antiComparator` then adjacent-equality counting (`while (j < sorted.length && fullCompare(k, sorted[j]) === 0) j += 1;`) to build the `[key, BigInt(count)]` entries — the *history-dependent state* warning that this fullOrder *does not survive* the call; the §CopyMap section with the more-complex `payload: { keys, values }` shape — payload must be a `copyRecord` with *only* `keys` and `values` properties (`ownKeys(rest).length === 0` invariant), keys themselves keys, values a `copyArray`, equal-length keys/values; the `getCopyMapEntries` returning a `Far('CopyMap entries iterable', ...)` exotic iterator (not just an array) for lazy iteration; the §`makeCopyMap` algorithm — *reverse rank sorting the entries* via `compareAntiRank` to colocate keys-of-the-same-equivalence-class with their values rank-sorted, plus the §explicit TODO that names the *copyMap cover issue* in patternMatchers.js as a future-work item that depends on additional validation; the §`copyMapKeySet` shortcut — a copyMap's keys are *already* in the internal form used by copySets, so `makeTagged('copySet', m.payload.keys)` constructs the keyset without re-validation
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
---

## Abstract

The §CopySet section (lines 105-184) defines `confirmCopySet`/`isCopySet`/`assertCopySet`/`getCopySetKeys`/`everyCopySetKey`/`makeCopySet` following the Confirm/Is/Assert trio pattern from the previous section. The §`confirmCopySet` checks `passStyleOf(s) === 'tagged' && getTag(s) === 'copySet'`, then delegates to sibling `confirmElements(s.payload, reject)` (from `./copySet.js`) and to `confirmKey(s.payload, reject)` for payload validation. The §memo WeakSet caches positive judgements. The §CopyBag section (lines 186-290) mirrors CopySet's shape for `tagged: 'copyBag'` with `confirmCopyBag` delegating to `confirmBagEntries`. The §`makeCopyBagFromElements` (lines 268-290) is a worked example of *sort-then-adjacent-counting*: it builds a fullOrder antiComparator via `makeFullOrderComparatorKit().antiComparator`, sorts the elements, then scans adjacent-equal runs counting them into `[key, BigInt(count)]` entries; the §comment names the *history-dependent state* warning — the fullCompare *does not survive* the call. The §CopyMap section (lines 292-481) has the more-complex `payload: { keys, values }` shape — `payload` must be a `copyRecord` with *only* `keys` and `values` properties (enforced via `ownKeys(rest).length === 0` after destructuring rest); keys themselves must be keys; values must be a `copyArray`; keys and values arrays must be equal length. The §`getCopyMapEntries` returns a `Far('CopyMap entries iterable', ...)` exotic — an explicitly-hardened iterable that produces *one hardened-result-object per `next()` call*. The §`makeCopyMap` (lines 465-481) sorts entries by `compareAntiRank` (reverse rank order) to colocate keys-of-the-same-equivalence-class with their values rank-sorted; the §honest TODO names the *copyMap cover issue explained in patternMatchers.js* as a future-work item that depends on additional validation. The §`copyMapKeySet` (lines 454-457) is the *internal-form-shortcut*: a copyMap's keys are already in the internal form used by copySets, so `makeTagged('copySet', m.payload.keys)` constructs the keyset without re-validation.

## Body

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

## Connection to the wider library

This section is the **canonical *one-pattern-three-uniform-applications* worked example**. Four threads:

1. **The uniform Confirm/Is/Assert + memo + structural-payload-validation across CopySet/CopyBag/CopyMap** is reusable for any *tagged-collection-family* validation surface. Each collection adds its own structural-payload check while sharing the trio + memo discipline.

2. **The sort-then-adjacent-counting algorithm** (`makeCopyBagFromElements`) is reusable for any *multiplicity-counting from unsorted input* problem. The §history-dependent-state-call-local discipline is the safe form when the sort needs ordering beyond rank.

3. **The Far iterator (`getCopyMapEntries`) vs hardened array (`getCopyMapEntryArray`) dual-API** is the canonical *offer-both-eager-and-lazy-shapes* discipline. The consumer picks based on access pattern.

4. **The internal-form-shortcut (`copyMapKeySet`)** is the *shared-representation-tag-rewrite* idiom. When two related types share an internal form, the conversion is a tag-rewrite rather than a structural copy.

The §five-layer copyMap validation (tag + payload-is-record + only-keys-and-values + keys-validity + values-shape-and-length) is a worked example of the *layered-invariant-check with most-specific-diagnostic-first* discipline.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Moved to here so they can check that the copySet contains only keys without creating an import cycle` | The *break-import-cycle-by-relocation* discipline; place the cross-cutting predicate where neither sibling needs to import the other. |
| Uniform Confirm/Is/Assert trio across three collections | The *one-pattern-uniformly-applied* discipline. |
| `This fullOrder contains history dependent state. It is specific to this one call and does not survive it.` | The *transient-state-call-local* discipline; build it fresh, discard after use. |
| `sort + adjacent-equality count` in makeCopyBagFromElements | The *multiplicity-counting via sort* algorithm. |
| `BigInt(j - i)` count | The *bigint-multiplicities* discipline; arbitrarily-large counts without floating-point precision loss. |
| `ownKeys(rest).length === 0` after destructuring | The *strict-record-no-extra-properties* invariant. |
| `Far('CopyMap entries iterable', ...)` exotic iterator | The *capability-conformant iterator* discipline; iterators are Far-exotics not plain objects. |
| `harden({ done, value })` per-step | The *every-yielded-value-hardened* discipline. |
| `getCopyMapEntryArray` (eager) vs `getCopyMapEntries` (lazy) dual API | The *offer-both-shapes* dual-API discipline. |
| `reverse rank sorting ... is a good first step` (`makeCopyMap`) | The *colocate-rank-tied-with-sub-sort* algorithm. |
| `TODO ... if we include this criteria in our validation of copyMaps, which we currently do not` | The *honest-known-limit-with-dependency-named* TODO discipline. |
| `A copyMap's keys are already in the internal form used by copySets` (`copyMapKeySet`) | The *shared-internal-form-tag-rewrite* shortcut. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns key/CopyTagged surface.
- `endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion` — the previous section: Confirm/Is/Assert trio pattern definition + Atom/Scalar/Key + keyMemo + confirmKeyInternal recursion.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — the rank-order regime; `sortByRank`, `compareAntiRank`, and `makeFullOrderComparatorKit` come from there.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; uses these collection shapes.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — the source of `passStyleOf`, `getTag`, `makeTagged`, `Far`.
- `endo--pkg-patterns-readme--*` — the @endo/patterns README; high-level surface.

## Common confusions

- **"`copySetMemo` and `keyMemo` are redundant — every copySet is also a key."** They are *not* redundant. The §memo for copySets caches the *structural-payload validation* result (tag-match + element rank-ordering + element-is-key). The §memo for keys caches the *Key-eligibility* result. A copySet that passes structural validation might still fail Key-eligibility if its elements include errors or promises — which is rare but possible. Each memo serves its own predicate.
- **"`makeCopyBagFromElements` could just use a Map for counting."** A Map would work for *exact-equality* counting; but copyBag uses *rank-equivalence* counting (two values that are full-order-equal share a count). The fullOrder antiComparator with adjacent-counting handles the rank-tie case correctly; a Map would treat rank-tied values as distinct.
- **"`fullCompare` history-dependent state could leak across calls."** It *cannot* — `makeFullOrderComparatorKit()` returns a *new* comparator kit each call. The state lives in the closure; when the function returns, the closure is unreferenced and GC'd. The §comment names this discipline explicitly.
- **"`getCopyMapEntries` should just return an array — the iterator adds complexity."** The §dual-API (`getCopyMapEntries` lazy vs `getCopyMapEntryArray` eager) lets consumers pick based on access pattern. Lazy iteration avoids the upfront allocation for partial-iteration consumers.
- **"The `ownKeys(rest).length === 0` check is paranoid."** It is *correct*. Without it, a copyMap with extra properties (e.g., `{ keys, values, extraField }`) would pass other checks but be malformed. The strict invariant catches this immediately.
- **"`copyMapKeySet` should re-validate the keys."** It should *not* — the input is already an `assertCopyMap`-validated copyMap; its keys array is already in copySet's internal form. Re-validation would be wasted work.
- **"The `makeCopyMap` TODO is a bug that should be fixed."** It is a *known limit with named dependency*. The TODO references `patternMatchers.js`'s *copyMap cover issue*; closing the gap requires adding a validation criterion. The §discipline is to *name the dependency in the TODO* so a future maintainer knows which other file to update alongside.
- **"`compareAntiRank` vs `compareRank` — they should be the same."** They are *reverse-ordered* siblings. The choice between them is per-call: `makeCopyMap` uses anti (reverse) order because it wants rank-tied keys to *cluster together at the same position* in the sort. The detail matters for the adjacent-equality scans elsewhere.
- **"`harden({ done: false, value: [...] })` per `next()` is allocation-heavy."** Each step's iterator result is a *fresh object*; harden makes it immutable. The discipline trades allocation cost for the *no-shared-mutable-iterator-state* invariant. Iterator results that survive across `next()` calls would be a capability-discipline violation.
