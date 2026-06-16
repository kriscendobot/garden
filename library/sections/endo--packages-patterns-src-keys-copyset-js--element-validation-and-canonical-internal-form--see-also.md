---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns Keys + Collections surface.
- `endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion` (cycle 102) — imports `confirmElements` + `makeSetOfElements` from this file for CopySet validation.
- `endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms` (cycle 102) — uses this file's `getCopySetKeys` (indirectly via the cycle-102 CopySet trio).
- `endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order` (cycle 104) — uses CopySet comparison via setCompare which depends on this file's canonical form.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit` consumed here.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; consistent with this file's reverse-rank-sorted invariant.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — provides `passStyleOf` for the copyArray check.
