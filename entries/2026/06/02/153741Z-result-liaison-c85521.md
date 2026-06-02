---
host: endolin
role: liaison
dispatch_id: c85521
date: 2026-06-02
kind: result
---

# result(librarian, cycle 115): copyBag.js — bag entry validation + per-entry shape + positive count (1 section)

**Cycle**: 115 (pivoted from chat-lane to comments-lane for variety after a long run of design-lane cycles).
**Source**: `endojs/endo` `packages/patterns/src/keys/copyBag.js` (136 lines), last touched 2025-10-09 by Kris Kowal.

## What

Ingested the Kris Kowal-authored *copyBag entry-validation + factory* surface — the **sister file** to cycle 110's `copySet.js` (same author, same commit `e56bf00f`). The 136-line file is the canonical *internal-form validation + factory* for copyBags. Single-section cohesion-honest ingest, mirroring cycle 110's pattern.

### Section drafted

1. **Bag entry validation with per-entry shape and positive count** (full file, lines 1-137) — single cohesive ingest. The §`confirmNoDuplicateKeys` private predicate is the centerpiece — sister to cycle 110's `confirmNoDuplicates` but compares *keys only* (entry[0]) on `[key, count]` tuples. The §*key-significance-over-value* comment encodes the fullOrder's lexicographic-key-first composite-key behavior: *Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts*. The §**five-layer** `confirmBagEntries` predicate (vs cycle 110's three-layer `confirmElements`): (1) is-copyArray; (2) reverse-rank-sorted via `compareAntiRank`; (3) per-entry-shape (each entry must be a 2-element copyArray with bigint count); (4) per-entry-positive-count (entry[1] >= 1n; absent keys mean count-zero); (5) delegates to `confirmNoDuplicateKeys`. The §`coerceToBagEntries` sorts iterable into reverse-rank order + validates. The §`makeBagOfEntries` wraps with `makeTagged('copyBag', ...)`. The canonical copyBag internal form: `tagged: 'copyBag'` whose payload is a copyArray of `[key, count: bigint]` 2-tuples, rank-sorted in reverse order, no duplicate keys, every count >= 1n.

### Library state after this cycle

- **616 sections** (was 615) / **160 sources** (was 159) / **44 concepts** (unchanged).
- Topic pages updated: `hardened-javascript.md` (+1 row), `patterns.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~23 copyBag keywords (key-significance-over-value / fullOrder lexicographic-key-first composite-key sort / five-layer confirmBagEntries / per-entry-shape 2-element copyArray bigint count / per-entry-positive-count >= 1n / absent keys mean count-zero / bigint count arbitrary-large multiplicity / canonical copyBag internal form / bag-analog of set validation / sister-file design discipline / additive-validation-layers richer-payload-more-layers / positive count discipline / no zero entries multi-set invariant).

## Notes

- The §*key-significance-over-value* comment is structurally important: it documents *why* the fullOrder antiComparator works as a duplicate-key detector for `[key, count]` tuples. The §rationale: rank order on copyArrays is *lexicographic by element-wise rank order*, so sorting `[[k1, c1], [k2, c2], ...]` sorts primarily by `k_i` regardless of `c_i`. Duplicate keys land adjacent. Reusable for any *composite-key-tuple-sort with key-significance* situation.
- The §five-layer `confirmBagEntries` (vs cycle 110's three-layer `confirmElements`) is a worked example of the *additive-validation-layers* discipline: richer payload shape requires more layers. CopySet payloads are *just keys*; CopyBag payloads are *[key, count] tuples* requiring per-entry shape + per-entry positive count.
- The §*positive-count* discipline (entry[1] >= 1n) encodes the *no-zero-entries multi-set invariant*: a bag entry with count 0 should not exist (it would mean *zero copies of the key* which is *no entry at all*); negative counts make no semantic sense. The validation enforces the *materialized counts* convention.
- The §sister-file design discipline — copyBag.js *systematically parallels* cycle 110's copySet.js with same author + same commit + same idioms (history-dependent-state-call-local + reverse-rank-sorted invariant + Rejector dual-mode + hideAndHardenFunction + parallel TODOs). The *one-discipline-shared-across-implementations* pattern is the structural takeaway.
- The two parallel TODOs (deferred `&&=` once-tooling-ready + memoize-no-duplicate-finding) reflect that *if a maintainer addresses one file, they likely address the other*. The shared discipline keeps the sister-files in sync.

## Library-position context

This file completes the @endo/patterns + marshal Keys + Collections substrate:

- **Cycle 71** `passStyleOf.js` — provides `passStyleOf` consumed by `confirmBagEntries`.
- **Cycle 81** `encodePassable.js` — rank-order-preserving encoder.
- **Cycle 84** `rankOrder.js` — provides `compareAntiRank`, `sortByRank`, `isRankSorted`, `makeFullOrderComparatorKit`.
- **Cycle 102** `checkKey.js` — uses both this file's `confirmBagEntries` + `makeBagOfEntries` *and* `confirmElements` + `makeSetOfElements` (cycle 110).
- **Cycle 104** `compareKeys.js` — uses `getCopyBagEntries` via bagCompare.
- **Cycle 110** `copySet.js` — set-sibling of this file.
- **Cycle 115** (this ingest) `copyBag.js` — the canonical internal form + validation + factory for CopyBag.

Together seven cycles describe the *full @endo/patterns + marshal Keys + Collections substrate* including both CopySet and CopyBag.

## Next

- Cycle 116 (papers-lane): the persistent papers-lane block (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110 / 112 / 113-implicit / 114) — consider whether infrastructure available.
- Cycle 117 (chat-lane → broader endo-but-for-bots designs): remaining endopi-* (8 Proposed); daemon-form-request (Implemented; 435 lines); daemon-capability-bus (In Progress; 526 lines); daemon-mount (In Progress; 718 lines, 3+ sections); daemon-checkin-checkout (Complete; 578 lines); OCapN-Noise designs (named as dependencies in cycle 114).
- Cycle 118 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines).

ScheduleWakeup 1500s for cycle 116.
