---
title: Body
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "527-570"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "Why makeFullOrderComparatorKit assigns remotables an order by first-seen-time; the BEWARE that this is observable mutable state and unsharable across subsystems that must not communicate; why fresh full-order comparators preserve already-sorted scalar arrays but not passable arrays in general; why the kit cannot be used for store ordering (no memory of deleted keys); the longLived parameter's WeakMap vs Map trade-off"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state
---

### The strict-refinement property

The full-order kit is constructed by wrapping
`makeComparatorKit` with a stateful `compareRemotables`:

```js
/**
 * Create a comparator kit in which remotables are fully ordered
 * by the order in which they are first seen by *this* comparator kit.
 * ...
 * These full order comparator kit is strictly more precise that the
 * rank order comparator kits above. As a result, any array which is
 * sorted by such a full order will pass the isRankSorted test with
 * a corresponding rank order.
 * ...
 */
export const makeFullOrderComparatorKit = (longLived = false) => {
  let numSeen = 0;
  const seen = longLived ? new WeakMap() : new Map();
  const tag = r => {
    if (seen.has(r)) {
      return seen.get(r);
    }
    numSeen += 1;
    seen.set(r, numSeen);
    return numSeen;
  };
  const compareRemotables = (x, y) => compareRank(tag(x), tag(y));
  return makeComparatorKit(compareRemotables);
};
```

Three pieces of the strict-refinement claim:

1. **Each remotable gets a unique ordinal on first sight**: the
   `tag` function increments `numSeen` and records the
   pair `(remotable, numSeen)` in the `seen` map. Subsequent
   calls with the same remotable return the same ordinal.
2. **Remotable comparison reduces to ordinal comparison**: two
   remotables compare by their tags, which are nonnegative
   integers. `compareRank` on two finite-integer tags reduces
   to a trivial less-than (no NaN to worry about). The
   comparator is now *total* — never returns NaN, never short-
   circuits.
3. **The strict refinement claim**: any array that satisfies
   `isRankSorted` under a full-order comparator also satisfies
   `isRankSorted` under the corresponding rank comparator. The
   logic: the full-order comparator agrees with the rank
   comparator everywhere except *between two remotables*; in
   the disagreement region, the rank comparator returns 0
   (tied via NaN-coerced-to-zero) while the full-order returns
   strictly -1 or +1. Any pair with a strict rank-order result
   gets the same strict result under full-order; any rank-tie
   either stays tied or becomes a strict full-order result.
   In neither direction does the strictness reverse.

### The BEWARE clause: observable mutable state

```js
/**
 * Create a comparator kit in which remotables are fully ordered
 * by the order in which they are first seen by *this* comparator kit.
 * BEWARE: This is observable mutable state, so such a comparator kit
 * should never be shared among subsystems that should not be able
 * to communicate.
 * ...
 */
```

The hazard the comment names is *covert channels through
shared comparator state*. Suppose subsystem A and subsystem B
must not be able to communicate (the standard mutual-suspicion
posture). If both hold the same `FullComparatorKit`, A can:

1. Sort an array of probe remotables that B might also encounter.
2. By choosing which probes to sort first, A controls which
   remotables get which ordinals.
3. When B later sorts an array containing some of those probes,
   the resulting order reveals A's choices.

Even more directly, A can sort `[r1]` first, then `[r2]`, then
ask the comparator `compareRank(r1, r2)` — the answer reveals
which it has seen earlier. Sharing the comparator across
mutually-distrusting subsystems thus opens a side channel.

The mitigation: each subsystem constructs its own
`FullComparatorKit` (perhaps lazily, by calling
`makeFullOrderComparatorKit()` inside the subsystem's
realm). The strict-refinement property holds within each
subsystem; no covert channel exists across them.

### The fresh-comparator-of-scalars invariant

The comment names a subtle compositional property:

```js
/**
 * ...
 * An array which is sorted by a *fresh* full order comparator, i.e.,
 * one that has not yet seen any remotables, will of course remain
 * sorted by according to *that* full order comparator. An array *of
 * scalars* sorted by a fresh full order will remain sorted even
 * according to a new fresh full order comparator, since it will see
 * the remotables in the same order again. Unfortunately, this is
 * not true of arrays of passables in general.
 * ...
 */
```

Three claims:

1. **Self-sorted-stays-sorted**: a comparator's own output stays
   sorted under the same comparator. Trivially true (the
   ordinal table is unchanged).
2. **Scalars-cross-fresh-comparators**: an array containing
   *no remotables* (so consisting only of scalars: numbers,
   bigints, strings, etc.) sorted by a fresh full-order
   comparator remains sorted under *any* fresh full-order
   comparator. The reasoning: fresh comparators differ from
   each other *only* in their internal remotable-ordinal
   state, but for an array with no remotables, the
   `compareRemotables` callback is never invoked; the
   comparator's behavior reduces to the underlying rank
   comparator, which is deterministic.
3. **Passables-do-not-cross**: an array containing remotables
   does *not* in general stay sorted across fresh
   comparators. A fresh comparator B will assign the
   remotables ordinals in the order it first encounters them,
   which depends on the sort algorithm's iteration order
   over the input array — usually the same as the input
   order, which means the remotables in a sorted-by-A array
   would still get monotonically increasing ordinals from B
   (so the array would still appear sorted). But this is not
   guaranteed for all sort implementations or for all
   subsequent operations; the *resulting tags* under A and B
   would differ, and any operation that relied on those tags
   being equal (e.g., a hash) would diverge.

The strict-refinement property thus holds *within* a kit but
not always across fresh kits. The scalars exception is the
narrow case where it does cross.

### The no-store-ordering caveat

```js
/**
 * ...
 * Note that this order does not meet the requirements for store
 * ordering, since it has no memory of deleted keys.
 * ...
 */
```

A persistent store (CopyMap on disk, LMDB-backed bag, etc.)
must give every key a deterministic position that survives the
key's deletion and re-insertion. If the store used a
`FullOrderComparatorKit` for its remotable ordering, then
deleting and re-adding a remotable key would assign it a *new*
ordinal (the previous ordinal entry in `seen` is gone with the
deletion, and the next-encounter increment gives a fresh
number). The key would land in a different position the second
time around — breaking the persistence invariant.

The mitigation: stores use rank order (the default NaN-tied
comparator), where remotable identity collapses to "all
remotables tied", and use an *external* ordinal-mapping table
(per `passStylePrefixes`'s `|` reservation) that persists
across deletion. The `FullOrderComparatorKit` is for
in-memory uses (snapshotting a hash-stable canonical order
for diagnostic purposes, comparing two in-memory data
structures for equality up to remotable identity, etc.)
where deletion-and-re-insertion is not a concern.

### The longLived parameter

```js
/**
 * ...
 * @param {boolean=} longLived
 * @returns {FullComparatorKit}
 */
export const makeFullOrderComparatorKit = (longLived = false) => {
  let numSeen = 0;
  // When dynamically created with short lifetimes (the default) a WeakMap
  // would perform poorly, and the leak created by a Map only lasts as long
  // as the Map.
  /** @type {WeakMap<object, number> | Map<object, number>} */
  const seen = longLived ? new WeakMap() : new Map();
```

The trade-off:

- **`Map` (default, `longLived = false`)**: better lookup
  performance for short-lived kits. The "leak" — the kit
  retains every remotable it has seen — is bounded by the
  kit's own lifetime. If the kit is created for a single
  sort and then discarded, the leak is gone with it.
- **`WeakMap` (`longLived = true`)**: lets remotables be
  garbage-collected even while the kit lives, at the cost
  of higher per-operation overhead. Use for kits that
  outlive any individual remotable they might tag.

The inline comment names the reasoning: `WeakMap` "performs
poorly" for short-lived dynamic kits, so the default is `Map`.
Stewards of long-lived kits opt in to the `WeakMap` cost.

### Why this comment cluster justifies a section

The `makeFullOrderComparatorKit` function is short — about 17
lines — but its comment block carries four facts that govern
how the function may safely be used: the strict-refinement
relationship to rank order, the observable-mutable-state
hazard for cross-subsystem use, the cross-fresh-comparator
invariant for scalar arrays, and the no-store-ordering
caveat. Each fact is load-bearing: a user who ignores the
BEWARE clause can build a covert channel; a user who relies on
cross-fresh-comparator stability with passable arrays will
hit subtle hash-instability bugs; a user who tries to use the
kit for persistent store ordering will lose every deleted-and-
readded key's position. The comment cluster is the canonical
source for these constraints.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L527-L570) at commit `2e933309`.
