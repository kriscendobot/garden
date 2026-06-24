---
host: endolin
role: liaison
dispatch_id: 91af89
date: 2026-06-02
kind: result
---

# result(librarian, cycle 110): copySet.js — element validation + canonical internal form (1 section)

**Cycle**: 110 (pivoted from papers-lane to comments-lane after seventh consecutive papers-lane block — cycles 97/100/102/104/106/108/110).
**Source**: `endojs/endo` `packages/patterns/src/keys/copySet.js` (109 lines), last touched 2025-10-09 by Kris Kowal.

## What

Ingested the Kris Kowal-authored *copySet element-validation + factory* surface — the sibling that cycle 102's checkKey.js imports `confirmElements` and `makeSetOfElements` from. Single-section cohesion-honest ingest. The 109-line file is the canonical *internal-form validation* + *factory* for copySets.

### Section drafted

1. **Element validation + canonical internal form** (full file, lines 1-109) — single cohesive ingest. The §`confirmNoDuplicates` private predicate builds a fullOrder antiComparator (`makeFullOrderComparatorKit().antiComparator`) if not provided, with the explicit *this fullOrder contains history dependent state ... does not survive the call* discipline; sorts elements by rank; scans adjacent pairs for `fullCompare(k0, k1) === 0`; rejects duplicates. The §three-layer `confirmElements(elements, reject)` predicate: (1) `passStyleOf(elements) === 'copyArray'`; (2) `isRankSorted(elements, compareAntiRank)` reverse-rank-order required; (3) delegates to `confirmNoDuplicates`. The §`coerceToElements(elementsList)` sorts iterable into reverse-rank order + validates. The §`makeSetOfElements(elementIter)` wraps with `makeTagged('copySet', ...)`. The canonical copySet internal form: `tagged: 'copySet'` whose payload is a copyArray rank-sorted in *reverse* order (`compareAntiRank`) with no duplicates. Two named TODOs (deferred `&&=` syntax once tooling-ready; memoize no-duplicate finding independent of fullOrder use).

### Library state after this cycle

- **611 sections** (was 610) / **155 sources** (was 154) / **44 concepts** (unchanged).
- Topic pages updated: `hardened-javascript.md` (+1 row), `patterns.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~24 copySet keywords (history-dependent-state-call-local / fullOrder antiComparator / sort-then-adjacent-duplicate-scan / reverse-rank-sorted invariant / canonical copySet internal form / one-validation-serves-multiple-consumers / deferred optimization TODO with trigger / honest known perf limit with named mitigation).

## Notes

- The §*history-dependent-state-call-local* discipline (fullOrder antiComparator built fresh per call; comment names *this fullOrder contains history dependent state ... does not survive the call*) repeats the pattern introduced in cycle 102's `makeCopyBagFromElements`. The §reuse across files documents the *one-discipline-shared-across-implementations* pattern.
- The §reverse-rank-sorted invariant (`compareAntiRank` not `compareRank`) is consistent with cycle 84's rankOrder.js and cycle 102's `makeCopyBagFromElements` + `makeCopyMap`. The §rationale: *anti-rank order positions tied keys adjacently for downstream scan-based algorithms*.
- The §three-layer `confirmElements` predicate is a worked example of the *most-specific-diagnostic-first via `&&` short-circuit* pattern. Each layer has its own error message; the `&&` short-circuit reports the first failure layer reached.
- The §two TODOs (deferred `&&=` once-tooling-ready + memoize-no-duplicate-finding-independent-of-fullOrder) are worked examples of *named-trigger + named-action + named-rationale* TODO shapes. Reusable for any *deferred optimization* shape.
- The §`one-validation-serves-multiple-consumers` discipline — *The keys of a copySet or copyMap must be a copyArray* — names both consumers in the error message. The same validation surface serves both copySets and copyMaps because they share the same key-array discipline.

## Library-position context

The seventh-cycle pattern in the @endo/patterns + marshal Keys + Collections substrate:

- **Cycle 71** `passStyleOf.js` — provides `passStyleOf` consumed by `confirmElements`.
- **Cycle 81** `encodePassable.js` — rank-order-preserving encoder; consistent invariant.
- **Cycle 84** `rankOrder.js` — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit`.
- **Cycle 102** `checkKey.js` — *uses* this file's `confirmElements` + `makeSetOfElements` for CopySet validation.
- **Cycle 104** `compareKeys.js` — uses CopySet comparison indirectly via setCompare.
- **Cycle 110** `copySet.js` (this ingest) — the canonical internal form + validation + factory surface.

Together six cycles describe the *full @endo/patterns + marshal Keys + Collections substrate*.

## Rotation discipline

Cycle 110 was scheduled for papers-lane but pivoted to comments-lane after the *seventh consecutive papers-lane block* (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110). The §rotation discipline is *cohesion-honest* not *strict round-robin*; papers-lane has been structurally hard (PDF-fetching infrastructure) so the rotation continues into adjacent lanes.

## Next

- Cycle 111 (chat-lane): chat-cluster exhausted. Continue with broader endo-but-for-bots designs. Candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-mount (In Progress; 718 lines — 3+ sections); daemon-capability-bus (In Progress; 526 lines — 2 sections); familiar-gateway-migration / familiar-daemon-bundling / familiar-unified-weblet-server (cycle 109's three named dependencies); endopi-* (12 designs); ocapn-* (7 designs).
- Cycle 112 (papers-lane): the eight-cycle papers-lane block continues. If fresh PDF access becomes available, retry. Otherwise pivot.
- Cycle 113 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines — the file `exo-makers.js` imports `defendPrototype` from); `packages/patterns/src/keys/copyBag.js` (the sibling that the cycle 110 copySet.js comment hints at — *confirmBagEntries* + *makeBagOfEntries* presumably live there).

ScheduleWakeup 1500s for cycle 111.
