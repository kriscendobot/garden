---
title: Connection to the wider library
source: packages/patterns/src/keys/copySet.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-109 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Seventeenth comment-fragment ingest. Kris Kowal-authored
  *copySet element-validation* file — the sibling that cycle 102's
  checkKey.js imports `confirmElements` and `makeSetOfElements`
  from. The 109-line file is the *internal-form-validation* and
  *factory* surface for copySets. Three structurally interesting
  moves: (1) the *history-dependent-state-call-local* discipline
  for the fullOrder antiComparator (built fresh per `confirmNo-
  Duplicates` call when no explicit comparator is provided; the
  comment repeats the discipline introduced in cycle 102's
  `makeCopyBagFromElements`); (2) the *reverse-rank-sorted invariant*
  for copySet keys — `compareAntiRank` not `compareRank`, consistent
  with cycle 84's rankOrder.js and cycle 102's makeCopyBagFromElements
  + makeCopyMap; (3) the *honest-known-perf-limit-with-named-mitigation*
  TODO at the top — *If doing this redundantly turns out to be
  expensive, we could memoize this no-duplicate finding as well,
  independent of the `fullOrder` use to reach this finding*.
  
  Pairs structurally with cycle 102's checkKey.js (which uses this
  file's exports to validate CopySet payloads) and cycle 104's
  compareKeys.js (which uses this file's `getCopySetKeys` indirectly
  via setCompare). Single-section cohesion-honest ingest.
parent: endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form
---

This section is the **canonical *internal-form-with-shared-validation* worked example**. Four threads:

1. **The history-dependent-state-call-local discipline** — fullOrder antiComparator built fresh per call; closure state discarded on return. Reusable for any *transient ordering with sub-rank tiebreakers* shape.

2. **The reverse-rank-sorted invariant for copySet keys** — `compareAntiRank` not `compareRank`. Consistent with cycle 84's rankOrder.js and cycle 102's makeCopyBagFromElements + makeCopyMap. The §discipline: *reverse-rank order positions tied keys adjacently for downstream scan-based algorithms*.

3. **The three-layer confirmElements predicate** — (1) is-copyArray; (2) is-reverse-rank-sorted; (3) no-duplicates. Most-specific-diagnostic-first via `&&` short-circuit. Each layer has its own error message.

4. **The sort-then-adjacent-duplicate-scan algorithm** — `confirmNoDuplicates`. Reusable for any *duplicate-detection in a passable collection* shape.

The §file is part of the @endo/patterns Keys + Collections substrate:

- **Cycle 71** `passStyleOf.js` — provides `passStyleOf` consumed by `confirmElements`.
- **Cycle 81** `encodePassable.js` — rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.
- **Cycle 84** `rankOrder.js` — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- **Cycle 102** `checkKey.js` — uses this file's `confirmElements` + `makeSetOfElements` for CopySet validation.
- **Cycle 104** `compareKeys.js` — uses this file's exports indirectly via `setCompare` (cycle 102's checkKey.js → setCompare).
- **Cycle 110** (this ingest) `copySet.js` — the canonical internal form + validation + factory.

Together cycles 71 + 81 + 84 + 102 + 104 + 110 describe the *full @endo/patterns + marshal Keys + Collections substrate*.
