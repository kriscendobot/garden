---
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
ingested: 2026-06-02
ingested_by: scholar
section_count: 2
status: current
notes: |
  Thirteenth comment-fragment ingest. Turadg Aleahmad-authored
  Keys-and-Collections validation surface of @endo/patterns. The
  544-line file decomposes into two argument-cluster sections:
  (1) the *Keys foundation* — Confirm/Is/Assert trio pattern,
  Atom/Scalar/Key with memoization and don't-memoize-negatives
  discipline, confirmKeyInternal recursion-on-passStyle; (2) the
  *Copy-collection extensions* — CopySet/CopyBag/CopyMap with the
  uniform trio applied to each, structural-payload validation, the
  makeCopyBagFromElements sort-then-adjacent-counting algorithm,
  the makeCopyMap reverse-rank-sort with TODO naming the
  *patternMatchers.js copyMap cover issue*, the Far iterator for
  getCopyMapEntries, and the copyMapKeySet internal-form-shortcut.
  Three structurally interesting ideas: the *Rejector-as-dual-mode
  parameter* (a callable doubling as `false` for silent or `Fail`
  for throw); the *don't memoize negatives* discipline (so a later
  `assertX` retry produces a diagnostic instead of a silent cache
  hit); the *unexpected passStyle throws* discipline (a new
  passStyle is *always* an error and surfaces immediately, vs
  unexpected tag which is *just non-key*). Pairs structurally with
  cycle 84 rankOrder.js (Mark Miller, in-memory rank-order regime;
  source of sortByRank + compareAntiRank consumed here) and cycle
  81 encodePassable.js (Mark Miller, rank-order-preserving
  encoder; uses these collection shapes for keyed-store bytes).
---

> Abstract: `packages/patterns/src/keys/checkKey.js` is @endo/patterns's
> *Keys-and-Collections validation surface* — *the* file that
> defines the Confirm/Is/Assert trio pattern and applies it to
> the four key/collection notions (ScalarKey, Key, CopySet, CopyBag,
> CopyMap). The 544-line file decomposes into two argument-cluster
> sections. The §Keys foundation defines the trio pattern (one
> internal predicate exposes three external entry points sharing a
> `Rejector` parameter that doubles as `false` or `Fail`); the
> `hideAndHardenFunction` discipline applied to all is/assert
> exports so `.name` doesn't leak; the `keyMemo` WeakSet with the
> *don't memoize negatives* discipline (positives speed up repeated
> checks; negatives are not cached so a later `Fail` retry produces
> a diagnostic); the `confirmKeyInternal` recursion-on-passStyle
> with the *unexpected passStyle throws* discipline (a new
> passStyle is always an error; unexpected tag is just non-key).
> The §Copy-collection extensions apply the same trio to CopySet,
> CopyBag, and CopyMap with each adding its own structural-payload
> validation (CopyMap has a 5-layer check: tag + payload-is-record
> + only-keys-and-values invariant + keys-are-keys + values-shape-
> and-length). The §makeCopyBagFromElements algorithm is a worked
> example of *sort-then-adjacent-counting* — sortByRank against a
> fullOrder antiComparator, then scan adjacent-equal runs counting
> them into `[key, BigInt(count)]` entries; the comment names the
> *history-dependent state ... does not survive* warning. The
> §makeCopyMap algorithm uses *reverse rank sorting* via
> compareAntiRank to colocate keys with their values rank-sorted,
> with an honest TODO naming the *copyMap cover issue explained in
> patternMatchers.js* as future work. The §`getCopyMapEntries`
> returns a `Far('CopyMap entries iterable', ...)` exotic for
> lazy iteration, while §`getCopyMapEntryArray` returns a hardened
> array for eager access — the *offer-both-shapes* dual API. The
> §`copyMapKeySet` shortcut exploits the *shared-internal-form*
> between copyMap.keys and copySet.payload for a tag-rewrite-only
> conversion.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [keys-foundation-confirm-is-assert-trio-and-recursion](../sections/endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion.md) | hardened-javascript, patterns | current |
| [copyset-copybag-copymap-extensions-and-special-case-algorithms](../sections/endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms.md) | hardened-javascript, patterns | current |

The 544-line file decomposes into two argument-cluster sections. Lines 1-103 are the Atom/Scalar/Key foundation (Confirm/Is/Assert trio + keyMemo + memoize-positives-only) plus lines 483-544 (confirmKeyInternal recursion-on-passStyle) → section 1. Lines 105-481 are the three copy-collection extensions (CopySet + CopyBag + CopyMap) including the makeCopyBagFromElements adjacent-counting algorithm, the makeCopyMap reverse-rank-sort with TODO, and the Far iterator/eager-array dual API → section 2.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@beab78998642c19d9420ec5bc819a6545327fa5e` via the local bare-clone.
- Last touched 2026-04-22 by Turadg Aleahmad. Turadg's authorship of the @endo/patterns module is consistent with his maintainer-role on the @endo/marshal+patterns surface.
- Verified file existence and structure via the local bare-clone: 544 lines / 176 comment lines (~32% comment density) / six structural sections (Atom-and-Scalar / Keys / CopySet / CopyBag / CopyMap / Keys-Recur).
- **Thirteenth comment-fragment ingest**. The chosen file *complements* the marshal-side cycles:
  - **Cycle 84** `rankOrder.js` (Mark Miller) — the rank-order regime; this module's `sortByRank`, `compareAntiRank`, `makeFullOrderComparatorKit` come from there.
  - **Cycle 81** `encodePassable.js` (Mark Miller) — the rank-order-preserving encoder; uses these collection shapes for keyed-store byte encoding.
  - **Cycle 71** `passStyleOf.js` (Mark Miller / Mathieu Hofman / Turadg) — the source of the `passStyle` discriminator this module dispatches on.
  - **Cycle 87** `pass-style/error.js` — pass-style's error-validation surface; this module's `error` rejection case is the gate.
- Two-section cohesion-honest count. The 544-line file *naturally* decomposes into the foundation/extensions split — the pattern is defined once in the foundation section and *applied three times* in the extensions section.
