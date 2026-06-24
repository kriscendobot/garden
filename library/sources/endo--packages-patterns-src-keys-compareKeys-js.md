---
source: packages/patterns/src/keys/compareKeys.js
source_repo: endojs/endo
source_branch: master
source_commit: c63b8b709ecb25a32469f5eae1003a719c7f3608
source_date: 2026-03-26
source_authors: [Turadg Aleahmad]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Fourteenth comment-fragment ingest. Sister file to cycle 102's
  checkKey.js (same author, same package; checkKey *defines* keys,
  compareKeys *compares* them). Where checkKey.js defines the
  Confirm/Is/Assert trio validation pattern, this file defines the
  *partial-order comparison* surface for keys + collections. Four
  structurally interesting moves: (1) the *partial-order vs total-
  order* distinction — keys form a partial order (some pairs are
  incommensurate, signaled by `NaN`) unlike rank order which is a
  total order (every pair has a defined comparison); (2) the
  *Pareto-partial-order* algorithm for copyRecord comparison —
  same property set required; element-wise comparison must
  all-go-the-same-direction-or-be-equal else NaN; (3) the *ABSENT
  Symbol sentinel* unused-but-preserved scaffolding for the future
  copyMap-comparison decision, with a TODO that *names the
  cross-reference* (endo PR #1737 review thread); (4) the *number
  NaN special case* — NaN === NaN compares as 0 in this module
  (NaN is equal to itself for key semantics) but NaN vs any
  non-NaN number returns NaN (incommensurate). Single-section
  cohesion-honest ingest — the 264-line file is one comparison
  surface with specialized handling per passStyle, plus the
  five-predicate wrapper suite (keyLT/keyLTE/keyEQ/keyGTE/keyGT).
---

> Abstract: `packages/patterns/src/keys/compareKeys.js` is the sister
> file to cycle 102's `checkKey.js`. Where checkKey defines the
> *Confirm/Is/Assert trio* validation pattern, this file defines
> the *partial-order comparison* surface for keys + collections.
> The §central structural fact: *keys form a partial order, not a
> total order* — some pairs are *incommensurate*, signaled by
> `NaN`. The §setCompare and §bagCompare collection-comparison
> factories use `makeCompareCollection(getEntries, defaultValue,
> compareValues)` from `keycollection-operators.js`. The §unused-
> but-preserved `_mapCompare` introduces the `ABSENT` Symbol
> sentinel (`Symbol('absent')` not `Symbol.for`; not passable;
> *exists only at the JS level of abstraction, not pass-style*)
> and recursive value comparison, paired with a TODO citing the
> *endojs/endo#1737* review thread for the undecided CopyMap-
> comparison semantics. The §compareKeys main function dispatches
> on passStyle: atomic types reuse `compareRank` (key order
> matches rank order); number is NaN-special-cased (NaN === NaN
> compares as 0 in key semantics; NaN vs non-NaN returns NaN);
> remotable comparison is identity-only (non-identical remotables
> incommensurate); copyArray is lexicographic with prefix-shorter-
> is-smaller; copyRecord uses *Pareto partial order* (same
> property set required; mixed-direction returns NaN); tagged
> dispatches into setCompare/bagCompare/(unimplemented copyMap
> throw); the *unexpected-passStyle-throws* discipline matches
> checkKey.js's. The §key-order-is-a-refinement-of-rank-order
> invariant (*if compareKeys(X,Y) < 0 then compareRank(X,Y) < 0*)
> bridges the two orderings — rank order is consistent with key
> order and serves as the total-order completion via first-seen-
> position tiebreakers. The §five-comparator predicate suite
> `keyLT`/`keyLTE`/`keyEQ`/`keyGTE`/`keyGT` wraps compareKeys with
> `< 0` / `<= 0` / `=== 0` / `>= 0` / `> 0`, all returning false
> for incommensurate pairs (partial-order-aware predicate semantics).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [passstyle-dispatched-key-comparison-with-pareto-partial-order](../sections/endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order.md) | hardened-javascript, patterns | current |

The 264-line file is honestly one cohesive argument-cluster — *one comparison surface* with specialized handling per passStyle, plus the five-predicate wrapper suite. Single-section ingest preserves the document's unified structure; forcing a multi-section split would create artificial divisions between the collection-compare factories (setCompare/bagCompare/_mapCompare) and the main compareKeys function that consumes them.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@c63b8b709ecb25a32469f5eae1003a719c7f3608` via the local bare-clone.
- Last touched 2026-03-26 by Turadg Aleahmad. Same author as cycle 102's `checkKey.js`; sister-file dating reflects the file's natural pairing as the *comparison* side of the *validation* surface.
- Verified file existence via the local bare-clone listing: 264 lines / 74 comment lines (~28% comment density).
- **Fourteenth comment-fragment ingest**. Pairs structurally with cycle 102's `checkKey.js`:
  - **Cycle 102** `checkKey.js` — defines keys (Confirm/Is/Assert trio + CopySet/CopyBag/CopyMap structural validation).
  - **Cycle 104** `compareKeys.js` (this ingest) — compares keys (passStyle-dispatched partial-order comparison + collection-compare factories + five-predicate wrapper suite).
- Cycle 104 was scheduled for papers-lane but pivoted to comments-lane (papers-lane has been blocked three consecutive times: cycle 97 problematic-source skip; Stiegler-Miller URLs 404; no fresh PDF access for cycle 104 retry).
- Single-section cohesion-honest count. The 264-line file is *one comparison surface* with specialized handling per passStyle. The 14-line atomic-types case + 14-line number case + 8-line remotable case + 19-line copyArray case + 48-line copyRecord case + 28-line tagged case + 14-line five-predicate suite all *cluster around the central compareKeys function*; forcing a 2-section split would create an artificial divide.
