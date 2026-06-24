---
source: packages/patterns/src/keys/copyBag.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Eighteenth comment-fragment ingest. Kris Kowal-authored
  *copyBag entry-validation + factory* surface — *the* sister
  file to cycle 110's `copySet.js` (same author, same commit
  `e56bf00f`). The 136-line file is the canonical *internal-form-
  validation + factory* for copyBags. Three structurally
  interesting bag-specific additions vs the set sister: (1) the
  *key-significance-over-value* comment — *Since the key is more
  significant than the value (the count), sorting by fullOrder
  is guaranteed to make duplicate keys adjacent independent of
  their counts* — encodes the fullOrder's lexicographic-key-first
  composite-key behavior on `[key, count]` tuples; (2) the
  *five-layer* `confirmBagEntries` predicate (vs cycle 110's
  three-layer `confirmElements`) — adds per-entry-shape (each
  entry is a 2-element copyArray with bigint count) + per-entry-
  positive-count (count >= 1n; absent keys mean count-zero); (3)
  the *one-discipline-shared-across-implementations* pattern
  repeats — same history-dependent-state-call-local + reverse-
  rank-sorted invariant + Rejector dual-mode + hideAndHardenFunction
  + parallel TODOs (deferred `&&=` syntax; memoize no-duplicate
  finding) as cycle 110's copySet.js. The canonical copyBag
  internal form: `tagged: 'copyBag'` whose payload is a copyArray
  of `[key, count: bigint]` 2-tuples, rank-sorted in reverse
  order, no duplicate keys, every count >= 1n.
---

> Abstract: `packages/patterns/src/keys/copyBag.js` is the
> *bag-analog* of cycle 110's `copySet.js` — same author, same
> commit, same idioms, with two bag-specific additions to the
> validation predicate. The file defines: (a)
> `confirmNoDuplicateKeys(bagEntries, fullCompare?, reject)` —
> the private predicate that builds a fullOrder antiComparator,
> sorts, and scans adjacent for duplicate keys (entry[0]) only;
> (b) `assertNoDuplicateKeys` public throw-form; (c) the
> **five-layer** `confirmBagEntries(bagEntries, reject)` — (1)
> is-copyArray; (2) is-reverse-rank-sorted; (3) per-entry-shape
> (2-element copyArray with bigint count); (4) per-entry-positive-
> count (count >= 1n); (5) delegates to `confirmNoDuplicateKeys`;
> (d) `assertBagEntries` public throw-form with
> `hideAndHardenFunction`; (e) `coerceToBagEntries(bagEntriesList)`
> factory that sorts iterable into reverse-rank order + validates;
> (f) `makeBagOfEntries(bagEntryIter)` factory wrapping with
> `makeTagged('copyBag', ...)`. The canonical copyBag internal
> form: `tagged: 'copyBag'` payload is a copyArray of
> `[key, count: bigint]` 2-tuples, rank-sorted in *reverse* order,
> no duplicate keys, every count >= 1n. The §key-significance-
> over-value comment encodes that the fullOrder antiComparator
> sorts entries primarily by key (regardless of count) so
> duplicate keys cluster adjacent for the no-duplicate-keys scan.
> Two named TODOs identical to cycle 110's copySet.js (deferred
> `&&=` once tooling-ready; memoize no-duplicate-finding
> independent of fullOrder use).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [bag-entry-validation-with-per-entry-shape-and-positive-count](../sections/endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count.md) | hardened-javascript, patterns | current |

The 136-line file is honestly one cohesive argument-cluster — *one validation + factory surface* with shared idioms (history-dependent-state-call-local, reverse-rank-sorted invariant, Rejector dual-mode, hideAndHardenFunction on public asserts). Single-section ingest preserves the unified structure, parallel to cycle 110's copySet.js single-section ingest.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f289ff8484094b785b11636b8bc71d87e` via the local bare-clone.
- Last touched 2025-10-09 by Kris Kowal — same author, same commit as cycle 110's `copySet.js` and cycle 108's `exo-makers.js`.
- Verified file existence and structure via the local bare-clone: 136 lines / 39 comment lines (~29% comment density).
- **Eighteenth comment-fragment ingest**. The chosen file *pairs structurally* with cycle 110's `copySet.js` — the two together describe the canonical internal-form for the two CopyTagged Key-set collections (CopySet stores keys; CopyBag stores `[key, count]` entries).
- Cycle 115 pivoted from chat-lane (exhausted) to comments-lane for variety after a long run of design-lane cycles.
- Single-section cohesion-honest count. The 136-line file is *one validation + factory surface*; like cycle 110's sister, multi-section split would create artificial divisions.
