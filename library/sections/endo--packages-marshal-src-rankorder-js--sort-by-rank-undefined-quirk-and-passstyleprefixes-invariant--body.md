---
title: Body
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "167, 380-451"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why sortByRank manually moves `undefined` from end to start under a reverse comparator; the invariant `passStylePrefixes MUST NOT sort any category after undefined`; the WeakMap-keyed-by-comparator pattern for memoizing rank-sorted arrays; the harden-then-sort-then-harden-result discipline"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant
---

### The Array.prototype.sort `undefined` quirk

JavaScript's `Array.prototype.sort` has a language-imposed special
case: elements with the value `undefined` are placed at the *end*
of the result, and they are never passed to the comparator
function. This is by design (per the EcmaScript spec) but it is
also the source of cross-implementation subtle bugs, since the
comparator's verdict on `undefined` is irrelevant. The behavior
makes the sort *not stable* in the sense that the comparator's
opinion about `undefined` ordering is ignored.

For a forward (ascending) rank-order sort, this quirk is benign
*because* the rank ordering happens to place `undefined` last
anyway (the `passStylePrefixes` table ends with `undefined: 'z'`
at the highest cover-range character; see the sister section in
`encodePassable.js` for why). The language-imposed placement
matches what the rank rule would have produced.

### Why the reverse comparator needs a manual fixup

For a reverse-order sort (using `antiComparator`, which inverts
the result of `comparator`), the rank ordering says `undefined`
should be *first* (it ranks above everything in forward order, so
it ranks below everything in reverse order). But `Array.prototype.sort`'s
quirk still places `undefined` at the end, regardless of the
comparator. This is the bug the inline comment names:

```js
const sorted = unsorted.sort(compare);
// For reverse comparison, move `undefined` values from the end to the start.
// Note that passStylePrefixes (@see {@link ./encodePassable.js}) MUST NOT
// sort any category after `undefined`.
if (compare(true, undefined) > 0) {
  let i = sorted.length - 1;
  while (i >= 0 && sorted[i] === undefined) i -= 1;
  const n = sorted.length - i - 1;
  if (n > 0 && n < sorted.length) {
    sorted.copyWithin(n, 0);
    sorted.fill(/** @type {T} */ (undefined), 0, n);
  }
}
```

Three pieces of comment-encoded reasoning:

1. **Detecting the reverse case**: the check `compare(true, undefined) > 0`
   asks "does the comparator think `true` ranks higher than
   `undefined`?" Under the forward comparator (where `boolean`
   sorts before `undefined`), `compare(true, undefined)` returns
   `-1` (or negative), so the condition is false and no fixup
   happens. Under the reverse comparator (`antiComparator`,
   which inverts), the same call returns `+1`, so the condition
   fires and the fixup runs. The check is comparator-agnostic;
   it does not need to know which comparator was supplied,
   only the comparator's verdict on one canonical pair.

2. **The relocation algorithm**:
   - Walk backward from `sorted.length - 1` to find the boundary
     between the actual values and the trailing `undefined`
     block (the index `i` where `sorted[i] !== undefined`).
   - `n = sorted.length - i - 1` is the count of trailing
     `undefined` elements.
   - `sorted.copyWithin(n, 0)` shifts the non-undefined block
     right by `n` positions (preserving relative order).
   - `sorted.fill(undefined, 0, n)` writes `n` `undefined`s into
     the freed leading positions.

3. **The MUST-NOT invariant**: the comment names a coordinating
   invariant on `passStylePrefixes` — *no PassStyle may sort
   after `undefined`*. If any PassStyle had a higher rank than
   `undefined`, the forward sort would already have a mis-placed
   `undefined` block (and the reverse sort would need a more
   complex fixup, since not every trailing `undefined` would
   need relocation — only the ones the rank rule places first
   and the language quirk pushes to the end). The invariant
   keeps the fixup as simple as it is, and it is anchored at
   two sites: the `Array.prototype.sort puts undefined values at the end`
   comment in `encodePassable.js`'s table definition (sister
   section in cycle 81), and this comment in `rankOrder.js`'s
   `sortByRank`. Either site could detect a violation if the
   table changed.

### The memoization-keyed-by-comparator pattern

```js
/**
 * @type {WeakMap<RankCompare,WeakSet<Passable[]>>}
 */
const memoOfSorted = new WeakMap();
```

`memoOfSorted` is a `WeakMap` from comparator functions to
`WeakSet`s of arrays. Once an array has been rank-sorted under a
particular comparator, it goes into that comparator's
`WeakSet`; subsequent calls to `isRankSorted(array, compare)` or
`sortByRank(array, compare)` can check the set in O(1) and skip
the sort entirely.

```js
export const sortByRank = (passables, compare) => {
  /** @type {T[]} mutable for in-place sorting, but with hardened elements */
  let unsorted;
  if (Array.isArray(passables)) {
    harden(passables);
    // Calling isRankSorted gives it a chance to get memoized for
    // this `compare` function even if it was already memoized for a different
    // `compare` function.
    if (isRankSorted(passables, compare)) {
      return passables;
    }
    unsorted = [...passables];
  } else {
    unsorted = Array.from(passables, harden);
  }
  // ... sort + undefined fixup ...
  harden(sorted);
  const subMemoOfSorted = memoOfSorted.get(compare);
  assert(subMemoOfSorted !== undefined);
  subMemoOfSorted.add(sorted);
  return sorted;
};
```

Two reuses of the cache:

1. **Already-sorted shortcut**: if the input is already a
   rank-sorted array (per the same comparator), `isRankSorted`
   returns `true` and `sortByRank` returns the input
   unchanged. The hot path through CopyMap operations frequently
   sees inputs that have already been sorted by previous
   passes; the memoization saves repeated O(n log n) work on
   those.

2. **Cross-comparator inference**: the comment names a subtle
   second benefit: even if `passables` was sorted under a
   *different* comparator, calling `isRankSorted` with the
   current comparator does the verification walk inline, and
   *if it passes*, memoizes for the current comparator too. The
   sort hot path thus learns "this array is sorted under the
   new comparator" without an extra pass.

The `WeakMap`/`WeakSet` choices are GC-friendly: when a
comparator is garbage-collected, its entire `WeakSet` of
already-sorted arrays goes with it; when an array is garbage-
collected, it falls out of every `WeakSet` that referenced it.
There is no leak across the program's lifetime.

### Harden-then-sort-then-harden discipline

The function's contract with hardened inputs and outputs:

```js
if (Array.isArray(passables)) {
  harden(passables);
  // ...
  unsorted = [...passables];
} else {
  unsorted = Array.from(passables, harden);
}
const sorted = unsorted.sort(compare);
// ...
harden(sorted);
```

Three places `harden` is called:

1. **Input array hardened**: if the caller passed an array
   (not a generic iterable), the input is hardened in place.
   This is the "if you give me an array, I freeze it" rule —
   callers must not subsequently mutate.
2. **Each element hardened (iterable case)**: if the caller
   passed an iterable that is not already an array, each
   element passes through `harden` as it lands in the new
   mutable working array. This handles the case of a generator
   that yields not-yet-hardened values.
3. **Result hardened**: the sorted output is hardened before
   return, so consumers get a frozen array of frozen elements.

The mid-step working array (`unsorted`) is *not* hardened — it
must remain mutable for `Array.prototype.sort` to do its work
in place. The discipline is "harden the inputs, sort the
copy, harden the result, return."

### Why this comment cluster justifies a section

The `sortByRank` function looks straightforward on first read,
but the comment cluster names three load-bearing facts that a
reader of the code alone would not derive:

1. The `undefined`-at-end JavaScript-language quirk and its
   asymmetric impact on forward vs reverse sorts.
2. The `passStylePrefixes` invariant that no category sorts
   after `undefined` — a cross-file coordination that the local
   code does not assert, only assumes.
3. The memoization's hot-path optimization for repeated sorts
   of the same data under different comparators.

Each of these affects the rank-order regime's correctness or
performance in ways that are non-obvious from the function body.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L380-L451) at commit `337d16a8`.
