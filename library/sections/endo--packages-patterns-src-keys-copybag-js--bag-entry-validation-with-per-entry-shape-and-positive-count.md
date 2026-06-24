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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--abstract.md)
- [Body](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--body.md)
- [Connection to the wider library](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--see-also.md)
- [Common confusions](endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--common-confusions.md)
