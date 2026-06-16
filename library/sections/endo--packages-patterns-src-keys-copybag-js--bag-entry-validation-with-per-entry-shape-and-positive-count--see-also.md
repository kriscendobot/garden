---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns Keys + Collections surface.
- `endo--packages-patterns-src-keys-copyset-js--*` (cycle 110) — **the sister file**; same author, same commit, same idioms; differs in lacking per-entry shape + positive-count validation.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — imports `confirmBagEntries` + `makeBagOfEntries` from this file for CopyBag validation.
- `endo--packages-patterns-src-keys-compareKeys-js--*` (cycle 104) — uses `getCopyBagEntries` via `bagCompare`.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.
