---
title: Connection to the wider library
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
