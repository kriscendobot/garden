---
host: endolin
role: liaison
dispatch_id: 77dac1
date: 2026-06-02
kind: result
---

# result(librarian, cycle 104): compareKeys.js — partial-order Key comparison + Pareto partial order (1 section)

**Cycle**: 104 (pivoted from papers-lane to comments-lane).
**Source**: `endojs/endo` `packages/patterns/src/keys/compareKeys.js` (264 lines / 74 comment lines / ~28% density), last touched 2026-03-26 by Turadg Aleahmad.
**Lane rotation**: cycle 104 was scheduled for papers-lane but pivoted to comments-lane after three consecutive papers-lane blocks (cycle 97 problematic-source skip; Stiegler-Miller HPL-2006-116 URLs 404; cycle 104 no fresh PDF access for retry).

## What

Ingested the sister file to cycle 102's `checkKey.js`. Where checkKey *defines* keys (Confirm/Is/Assert trio + CopySet/CopyBag/CopyMap structural validation), compareKeys *compares* them. The 264-line file is one cohesive comparison surface with specialized handling per passStyle, plus the five-predicate wrapper suite.

### Section drafted

1. **passStyle-dispatched key comparison + Pareto partial order** (full file, lines 1-264) — single cohesive ingest. The §central structural fact: *keys form a partial order, not a total order*. Some pairs are *incommensurate*, signaled by `NaN`. The §setCompare and §bagCompare collection-comparison factories use `makeCompareCollection(getEntries, defaultValue, compareValues)` from `keycollection-operators.js`. The §unused-but-preserved `_mapCompare` introduces the `ABSENT = Symbol('absent')` private sentinel (*not passable; exists only at the JS level of abstraction*) for the future copyMap-comparison decision, paired with a TODO naming the *endojs/endo#1737* review thread. The §compareKeys main function dispatches on passStyle: atomic types reuse `compareRank`; number is NaN-special-cased (NaN === NaN compares as 0 in *key* semantics, deviating from IEEE-754); remotable comparison is identity-only (non-identical remotables incommensurate); copyArray is lexicographic with prefix-shorter-is-smaller; copyRecord uses *Pareto partial order* (same property set required; mixed-direction values → NaN); tagged dispatches to setCompare/bagCompare/(unimplemented copyMap throw); the *unexpected-passStyle-throws* discipline matches checkKey.js's. The §key-order-is-a-refinement-of-rank-order invariant bridges the two orderings (*if compareKeys(X,Y) < 0 then compareRank(X,Y) < 0*) — key order is *more partial*; rank order is the *total-order completion*. The §five-comparator predicate suite `keyLT`/`keyLTE`/`keyEQ`/`keyGTE`/`keyGT` wraps compareKeys with `< 0` / `<= 0` / `=== 0` / `>= 0` / `> 0`; all return false for incommensurate pairs (partial-order-aware semantics).

### Library state after this cycle

- **605 sections** (was 604) / **149 sources** (was 148) / **44 concepts** (unchanged).
- Topic pages updated: `hardened-javascript.md` (+1 row), `patterns.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~28 compareKeys keywords (partial-order vs total-order / NaN as incommensurate signal / ABSENT Symbol private sentinel / Symbol vs Symbol.for / Pareto partial order / mixed-direction returns NaN / NaN-self-equal in key semantics / five-comparator suite / all-five-false-when-incommensurate / key-order-is-a-refinement-of-rank-order).

## checkKey ↔ compareKeys sister-cycle pairing

This cycle *pairs* with cycle 102's `checkKey.js`:

- **Cycle 102** `checkKey.js` (Turadg Aleahmad, 544 lines, 2 sections) — *defines* keys (Confirm/Is/Assert trio + CopySet/CopyBag/CopyMap).
- **Cycle 104** `compareKeys.js` (Turadg Aleahmad, 264 lines, 1 section) — *compares* keys (passStyle-dispatched partial-order comparison + collection-compare factories + five-predicate wrapper suite).

Together the two cycles describe the *full @endo/patterns Keys + Collections substrate* — validation + comparison.

## Rotation discipline

Cycle 104 was scheduled for papers-lane but pivoted to comments-lane after three consecutive papers-lane blocks. The §rotation discipline is *cohesion-honest* not *strict round-robin*; when a lane is repeatedly blocked, the rotation extends gracefully into adjacent lanes. Papers-lane has now been blocked for cycles 97, 100 (papers→comments), 102 (papers→comments), and 104 (papers→comments). Cycle 105 will rotate to chat-lane (broader endo-but-for-bots designs since chat-cluster is exhausted).

## Notes

- The §*partial-order vs total-order* distinction is structurally important. Keys form a *partial order*: some pairs are incommensurate (return NaN). Rank order forms a *total order*: every pair has a defined comparison. The two orderings are *consistent* (key-order-is-a-refinement-of-rank-order), so rank-sorting is a valid topological order for the key-partial-order.
- The §*Pareto-partial-order* algorithm for copyRecord comparison is the canonical *vector-typed-value-comparison-with-mixed-direction-detection* shape. Required: same property set. Element-wise: all-go-same-direction-or-be-equal. Mixed: NaN.
- The §*ABSENT private-sentinel pattern* — `Symbol('absent')` (constructor, unique-per-construction) not `Symbol.for(...)` (global registry, shared-across-compartments) — is the canonical *guaranteed-not-to-collide-with-inbound-data* idiom. The §discipline: *not passable; exists only at the JS level of abstraction*.
- The §NaN-self-equal-in-key-semantics deviates from IEEE-754. The §rationale: keys must support reflexive equality for use in sets/maps; NaN-self-inequality would make NaN unusable as a key.
- The §five-comparator suite (keyLT/keyLTE/keyEQ/keyGTE/keyGT) all return false for incommensurate pairs. The discipline preserves partial-order semantics: incommensurability is *not equality* and is *not ordering*; all five predicates report "no" for incommensurate pairs. Callers wanting *equivalent OR incommensurate* should use `!keyLT && !keyGT`.
- The §unused-but-preserved `_mapCompare` is structurally documented future-work: the algorithm is *prepared* (with ABSENT sentinel + recursive value comparison) but *unused* because the semantics is still being decided. The §TODO names the cross-reference to PR #1737 review thread.

## Next

- Cycle 105 (chat-lane): chat-cluster exhausted. Pivot to broader endo-but-for-bots designs. Candidates remaining: daemon-form-request (Implemented; 435 lines); daemon-agent-tools (Not Started; 350 lines); daemon-capability-bank (Not Started; 159 lines); daemon-mount (In Progress; 718 lines — would need 3+ sections); familiar-* (10 designs); endopi-* (12 designs); ocapn-* (7 designs).
- Cycle 106 (papers-lane): consider trying *Saltzer-Schroeder 1975 Principle of Least Privilege* (canonical); *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999); or fresh URL search for Stiegler-Miller HPL-2006-116. The repeated papers-lane block (4 cycles) suggests this lane is structurally hard without PDF-fetching infrastructure.
- Cycle 107 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24%); `packages/exo/src/exo-makers.js` (242 lines); `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines / ~17%).

ScheduleWakeup 1500s for cycle 105.
