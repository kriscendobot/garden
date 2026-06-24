---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent` | The *composite-key-tuple-sort with key-significance* discipline; lexicographic-key-first sort. |
| `confirmNoDuplicateKeys` (vs copySet's `confirmNoDuplicates`) | The *sister-file-with-renamed-predicate* pattern; bag entries use `[key, count]` tuples. |
| Five-layer `confirmBagEntries` (copyArray + sorted + entry-shape + positive-count + no-duplicate-keys) | The *additive-validation-layers* discipline; richer payload → more layers. |
| `Each entry of a copyBag must be pair of a key and a bigint representing a count` | The *per-entry-shape* validation; 2-element copyArray + bigint count. |
| `Each entry of a copyBag must have a positive count` (`entry[1] < 1`) | The *positive-count* invariant for multi-set entries; count-0 means absent-entry. |
| `bigint` count vs number | The *arbitrary-large-multiplicity* discipline; supports counts beyond `Number.MAX_SAFE_INTEGER`. |
| `confirmNoDuplicateKeys(bagEntries, undefined, reject)` delegation | The *layer-5-delegates-to-sibling-predicate* shape. |
| `hideAndHardenFunction(assertBagEntries)` | Same as cycle 110 + checkKey.js + compareKeys.js. |
| Parallel TODOs (`&&=` + memoize-no-duplicate-finding) | The *one-discipline-shared-across-implementations* pattern. |
