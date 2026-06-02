---
host: endolin
role: liaison
dispatch_id: 81d400
date: 2026-06-02
kind: result
---

# result(librarian, cycle 102): checkKey.js — @endo/patterns Keys + Collections validation (2 sections)

**Cycle**: 102 (pivoted from papers-lane to comments-lane).
**Source**: `endojs/endo` `packages/patterns/src/keys/checkKey.js` (544 lines / 176 comment lines / ~32% density), last touched 2026-04-22 by Turadg Aleahmad.
**Lane rotation**: cycle 102 was scheduled for papers-lane but pivoted to comments-lane (papers-lane has had two consecutive blocks: cycle 97 problematic-source skip, Stiegler-Miller 404).

## What

Ingested @endo/patterns's *Keys-and-Collections validation surface* — *the* file that defines the Confirm/Is/Assert trio pattern and applies it to ScalarKey, Key, CopySet, CopyBag, CopyMap. The 544-line file decomposes into two argument-cluster sections.

### Sections drafted

1. **Keys foundation: Confirm/Is/Assert trio + recursion** (lines 1-103 + 483-544) — the *Confirm/Is/Assert trio* pattern definition: one internal predicate (`confirmX(val, reject)`) exposes three external entry points sharing a `Rejector` parameter that doubles as `false` (silent) or `Fail` (throw). The §`hideAndHardenFunction` discipline on is/assert exports so `.name` doesn't leak as a privileged identifier. The §`keyMemo` WeakSet caches positive judgements; the *don't memoize negatives* discipline preserves the diagnostic on a later `assertX` retry. The §`confirmKeyInternal` recursion-on-passStyle dispatches across `remotable`/`copyRecord`/`copyArray`/`tagged` (with sub-dispatch to `copySet`/`copyBag`/`copyMap`), rejects `error`/`promise` with named diagnostic, and *throws on unexpected passStyle* (the *unexpected-state-is-bug* trichotomy: expected positive / expected negative / unexpected-state-throws).

2. **CopySet/CopyBag/CopyMap extensions + special-case algorithms** (lines 105-481) — the uniform Confirm/Is/Assert trio applied three more times, each with own memo WeakSet + structural-payload validation. CopyMap has a 5-layer check (tag + payload-is-record + only-keys-and-values invariant + keys-are-keys + values-shape-and-length). The §`makeCopyBagFromElements` algorithm is *sort-then-adjacent-counting*: builds a fullOrder antiComparator via `makeFullOrderComparatorKit().antiComparator`, sorts, then scans adjacent-equal runs counting them into `[key, BigInt(count)]` entries; the comment names the *history-dependent state ... does not survive* warning. The §`makeCopyMap` algorithm uses *reverse rank sorting* via `compareAntiRank` to colocate keys with values rank-sorted; the §honest TODO names the *patternMatchers.js copyMap cover issue* as future work that depends on additional validation. The §`getCopyMapEntries` returns a `Far('CopyMap entries iterable', ...)` exotic for lazy iteration, while §`getCopyMapEntryArray` returns a hardened array — the *offer-both-shapes* dual API. The §`copyMapKeySet` shortcut exploits the *shared-internal-form* between copyMap.keys and copySet.payload for a tag-rewrite-only conversion.

### Library state after this cycle

- **603 sections** (was 601) / **147 sources** (was 146) / **44 concepts** (unchanged).
- Topic pages updated: `hardened-javascript.md` (+2 rows), `patterns.md` (+2 rows).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~40 patterns keywords (Confirm/Is/Assert trio / Rejector dual-mode / hideAndHardenFunction / keyMemo / don't-memoize-negatives / recursion-on-passStyle / unexpected-passStyle-throws / 5-layer copyMap validation / sort-then-adjacent-counting / history-dependent-state / reverse-rank-sort / Far iterable / copyMap cover issue / shared-internal-form-tag-rewrite).

## @endo/patterns + marshal sister-cycle complementarity

This cycle *complements* the marshal-side cycles:

- **Cycle 71** `passStyleOf.js` — provides the `passStyle` discriminator this module dispatches on.
- **Cycle 81** `encodePassable.js` — uses these collection shapes for keyed-store byte encoding.
- **Cycle 84** `rankOrder.js` — provides `sortByRank`, `compareAntiRank`, `makeFullOrderComparatorKit` consumed here.
- **Cycle 87** `pass-style/error.js` — pass-style's error-validation surface; this module's `error` rejection case is the gate.
- **Cycle 102** (this ingest) `checkKey.js` — the Keys + Collections validation surface that consumes all of the above.

Together the five cycles describe the *full @endo/patterns + marshal Keys + Collections + validation pipeline*.

## Rotation discipline

Cycle 102 was scheduled for papers-lane but pivoted to comments-lane after two consecutive papers-lane blocks (cycle 97 *problematic source* per user instruction; Stiegler-Miller HPL-2006-116 URLs 404). The §rotation discipline is *cohesion-honest* not *strict round-robin*; when a lane is repeatedly blocked, the rotation extends gracefully into adjacent lanes. Papers-lane will retry in cycle 104 or 105 with fresh candidates (Saltzer-Schroeder 1975 / KeyKOS / EROS / etc.).

## Notes

- The §*Confirm/Is/Assert trio* pattern (one internal predicate / three external entry points / `Rejector` parameter) is the cleanest expression of *judgement-logic vs reporting-logic separation* I've seen in this corpus. The pattern is reusable for any *check-with-optional-diagnostic* surface.
- The §*don't memoize negatives* discipline is structurally important: it trades repeated-failure performance for *diagnostic preservation*. Positives are stable and common; negatives often want the diagnostic on a later `assertX` retry. The trade-off is *intentional and named*.
- The §*unexpected passStyle throws* discipline is a worked example of the *expected-vs-unexpected-state* trichotomy. Expected positives get the standard predicate; expected negatives reject with diagnostic; unexpected state *always throws* to surface the gap immediately. Silent-skip would mask a missing case in the dispatch table.
- The §`makeCopyBagFromElements` *sort-then-adjacent-counting* algorithm is a worked example of how to handle multiplicity counting under rank-equivalence — the fullOrder antiComparator with adjacent-counting handles rank-tied values as distinct bag entries, which a plain Map would mishandle.
- The §`makeCopyMap` *honest TODO* discipline names a dependency (`patternMatchers.js copyMap cover issue`) and explains *why the gap exists* (validation doesn't enforce the criterion). Future-work-TODOs that name their dependency are the canonical shape.
- The §`copyMapKeySet` *shared-internal-form-tag-rewrite* shortcut is a O(1) conversion exploiting that copyMap.keys and copySet.payload are the *same data shape*. Reusable for any *shared-internal-form* between two related types.

## Next

- Cycle 103 (chat-lane): chat-cluster exhausted. Pivot to broader endo-but-for-bots designs corpus — many candidates remain (daemon-form-request, daemon-value-message, daemon-agent-tools, daemon-capability-bank, daemon-capability-bus, daemon-mount, daemon-checkin-checkout, familiar-*, endopi-*, ocapn-*).
- Cycle 104 (papers-lane): retry with fresh candidates — *Saltzer-Schroeder 1975 Principle of Least Privilege* (canonical, well-known); *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999); fresh URL search for Stiegler-Miller HPL-2006-116.
- Cycle 105 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24% density); `packages/exo/src/exo-makers.js`; `packages/marshal/src/marshal-justin.js`; `packages/patterns/src/keys/compareKeys.js` (264 lines, sister file to checkKey.js).

ScheduleWakeup 1500s for cycle 103.
