---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `This fullOrder contains history dependent state ... does not survive it` | The *transient-call-local-comparator* discipline; rebuild fresh per call. |
| `&&= once all our tooling is ready` TODO | The *deferred-modern-syntax-with-named-trigger* TODO pattern. |
| `If doing this redundantly turns out to be expensive ... memoize independent of fullOrder` TODO | The *honest-known-perf-limit-with-named-mitigation* TODO pattern. |
| `compareAntiRank` for copySet keys | The *reverse-rank-sorted invariant* — ties cluster for downstream scan-based algorithms. |
| Three-layer `confirmElements`: copyArray + rank-sorted + no-duplicates | The *most-specific-diagnostic-first via `&&` short-circuit* layered-predicate pattern. |
| `The keys of a copySet or copyMap must be ...` shared error message | The *one-validation-serves-multiple-consumers* discipline; copySet and copyMap share internal form. |
| `hideAndHardenFunction(assertElements)` | The *public-function-name-hiding* discipline; prevents `.name` leak as authority discriminator. |
| `makeTagged('copySet', coercedElements)` | The *canonical-internal-form via factory function* — `makeSetOfElements` is *the* construction path. |
| `sort-then-adjacent-duplicate-scan` | The *duplicate-detection in a passable collection* algorithm; works under any rank-tiebreaking fullOrder. |
