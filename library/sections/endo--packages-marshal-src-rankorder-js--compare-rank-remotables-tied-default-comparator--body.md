---
title: Body
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "362-374"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why marshal added a third rank comparator between short-circuiting compareRank and fully-ordering fullCompare: compareRankRemotablesTied considers all remotables tied for the same rank but does not short-circuit on encountering them; its adoption as the default compare argument for isRankSorted, assertRankSorted, sortByRank, rankSearch, getIndexCover, unionRankCovers, and intersectRankCovers"
ingested: 2026-06-27
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator
---

### The comment and the construction

```js
export const { comparator: compareRank, antiComparator: compareAntiRank } =
  makeComparatorKit();

/**
 * Like `compareRank` and `compareAntiRank` and unlike `fullCompare`,
 * `compareRankRemotablesTied` and `compareAntiRankRemotablesTied`
 * considers all remotables tied for the same rank.
 * Unlike `compareRank` and `compareAntiRank`,
 * `compareRankRemotablesTied` and `compareAntiRankRemotablesTied`
 * do not short circuit on encounting remotables.
 */
export const {
  comparator: compareRankRemotablesTied,
  antiComparator: compareAntiRankRemotablesTied,
} = makeComparatorKit((_x, _y) => 0);
```

`makeComparatorKit` takes an optional remotable-comparator. The
three rank-regime comparators it builds differ *only* in that
argument:

| Comparator | remotable-comparator argument | On meeting a remotable pair |
|---|---|---|
| `compareRank` / `compareAntiRank` | omitted (defaults to the NaN-returning shape) | returns the `NaN`-tie and **short-circuits** — stops descending into the surrounding structure |
| `compareRankRemotablesTied` / `compareAntiRankRemotablesTied` | `(_x, _y) => 0` | reports the remotable pair **tied** but **keeps comparing** the rest of the structure |
| (the full-order kit, see sibling section) | first-seen-ordinal comparator | imposes a **strict total order** on remotables |

### Why short-circuiting versus tied-but-continuing matters

The two NaN-tie comparators (`compareRank`) and the explicit-zero
comparator (`compareRankRemotablesTied`) agree that *a remotable
is tied with any other remotable* — neither imposes an order on
remotables. They differ in what happens to the **surrounding
structure** once a remotable is reached:

- `compareRank` propagates the `NaN` outward: a tie at any
  depth coerces the whole comparison to a tie and stops. Two
  copyArrays `[r1, "a"]` and `[r2, "b"]` come back tied even
  though their second elements differ, because the comparison
  short-circuits at the remotable in position 0. This is the
  deep-tied behaviour documented in the
  [inner-comparator](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md)
  section (the `[r1, 0]` / `[r2, "x"]` example).
- `compareRankRemotablesTied` treats the position-0 remotables
  as tied (returns 0 for that element) and **continues to the
  next element**, so `[r1, "a"]` and `[r2, "b"]` are ordered by
  their second elements. Remotables remain mutually unordered,
  but they no longer *poison* the comparison of everything
  around them.

This makes `compareRankRemotablesTied` the comparator a caller
wants when sorting or range-querying collections that contain
remotables but whose *non-remotable* structure should still
drive the order — which is the common case for keyed-store keys.

### Adoption as the default `compare` argument

The refresh that introduced this comparator also made it the
**default** for the seven public order-consuming entry points.
Each signature changed from a required `compare` to an optional
one defaulting to `compareRankRemotablesTied`:

```js
export const isRankSorted = (passables, compare = compareRankRemotablesTied) => { … }
export const assertRankSorted = (sorted, compare = compareRankRemotablesTied) => …
export const sortByRank = (passables, compare = compareRankRemotablesTied) => { … }
const rankSearch = (sorted, key, compare = compareRankRemotablesTied, bias = 'leftMost') => { … }
export const getIndexCover = (sorted, [leftKey, rightKey], compare = compareRankRemotablesTied) => { … }
export const unionRankCovers = (covers, compare = compareRankRemotablesTied) => { … }
export const intersectRankCovers = (covers, compare = compareRankRemotablesTied) => { … }
```

Two consequences worth noting for a reader of the older API:

1. **Parameter order moved.** Several of these functions also
   reordered their parameters so the now-optional `compare`
   trails the required arguments — for example `rankSearch`
   went from `(sorted, compare, key, bias)` to
   `(sorted, key, compare, bias)`, and `getIndexCover` from
   `(sorted, compare, rankCover)` to `(sorted, rankCover, compare)`.
   `unionRankCovers` and `intersectRankCovers` similarly moved
   `compare` to last. Callers that passed `compare` positionally
   under the old signatures must be updated.
2. **The default is the tied-but-continuing comparator, not the
   short-circuiting one.** Callers who relied on the implicit
   deep-tie poisoning of `compareRank` must now pass `compareRank`
   explicitly to keep that behaviour; the no-argument call now
   continues past remotables.

### Why this comment cluster justifies a section

The doc comment is only seven lines, but it names a distinction —
*tied-and-short-circuit* versus *tied-but-continue* versus
*strictly-ordered* — that is otherwise invisible from the
function names and is load-bearing for anyone reading or sorting
keyed-store keys. Paired with the silent default-argument and
parameter-order changes across seven public functions, it is the
canonical source for "what comparator does the rank regime use
when you do not pass one?" — an answer that the five original
`rankOrder.js` sections, written before this comparator existed,
do not give.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L362-L374) at commit `337d16a8`.
