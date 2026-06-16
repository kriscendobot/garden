---
title: Common confusions
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

- **"`confirmBagEntries` could just delegate to `confirmElements` plus an entry-shape check."** It could not — `confirmElements` checks that *the array elements are themselves keys*, but bag entries are `[key, count]` tuples (not keys). The duplicate-check also differs: bag's `confirmNoDuplicateKeys` compares `entry[0]` (the key) only; set's `confirmNoDuplicates` compares the whole element.
- **"Count 0 entries should be allowed — they just mean zero copies."** They should *not* be present. The §discipline: *absent keys mean count-zero; materialized entries must have positive counts*. Including count-0 entries would be redundant and would invite ambiguity (is the entry there or not?).
- **"`entry[1] < 1` uses number comparison — but the count is bigint."** JavaScript's `<` works on bigints. The comparison `bigint < 1` returns true for `0n`, `-1n`, etc. The `1` literal is coerced to `1n` for the bigint comparison (or compared per JS bigint semantics; either way the check is correct).
- **"`fullCompare(k0, k1)` on the keys-only might miss duplicate entries with different counts."** It doesn't — *duplicate keys with different counts are still duplicates*. The §discipline: *the bag invariant is one entry per key*. An array containing `[k, 3n]` and `[k, 7n]` has duplicate keys (the count difference doesn't matter for the invariant).
- **"Sister-file copyBag.js is just copySet.js with tweaks."** It's *systematically parallel* — same author + same commit + same idioms. The differences are *bag-specific* (per-entry shape + positive-count + key-significance comment) but the overall structure is identical.
- **"Why `confirmBagEntries` not `confirmEntries`?"** Because *entries* is ambiguous (could be Map entries, Set entries, etc.). *BagEntries* is *the specific shape used by bags*: `[key, count]` 2-tuples. The §discipline: *name the predicate by its specific accepted-shape*.
- **"`makeBagOfEntries` is just a one-liner — why not inline it?"** Same rationale as cycle 110's `makeSetOfElements`: it's *the canonical construction path*. A user constructing `makeTagged('copyBag', [...])` directly might produce a malformed bag. The factory is the *blessed* path.
- **"The reverse-rank-sorted invariant is over-engineered for bags."** It serves the *adjacent-equality-scan* algorithm in `confirmNoDuplicateKeys`. Without sorting, duplicate-detection would be O(n²); with sort + adjacent-scan, it's O(n log n) plus O(n).
- **"`assertBagEntries` uses `asserts` TypeScript syntax — TS overhead."** The `asserts` annotation is purely *type-narrowing*; no runtime cost. It tells TypeScript that *after this call, the bag entries are validated*; the subsequent code can treat them as such.
- **"Two TODOs identical to copySet.js means copy-paste sloppiness."** It means *the same discipline applies to both files*. If the maintainer addresses the `&&=` future-work or the memoization optimization in one file, they likely address it in the other. The §one-discipline-shared-across-implementations pattern.
