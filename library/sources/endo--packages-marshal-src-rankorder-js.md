---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "19-642"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Rank-order regime for marshal: per-PassStyle rank rules, passStyleRanks derivation from the canonical passStylePrefixes table, RankCover overestimates filterable by per-value PassStyle checks, sortByRank's reverse-direction undefined-quirk fixup linked to the passStylePrefixes MUST-NOT-sort-after-undefined invariant, the strict full-order alternative with its observable-mutable-state hazard, and the compareRankRemotablesTied remotables-tied comparator that became the default for the sort/search/cover API"
source_authors: [Mark S. Miller, Kris Kowal, Richard Gibson, Turadg Aleahmad, Michael FIG]
ingested: 2026-05-29
ingested_by: scholar
section_count: 6
status: current
notes: |
  Sixth comment-fragment ingest (cycle 84), sister to cycle 81's
  `encodePassable.js`. Where `encodePassable.js` is the bytes-on-
  the-wire form of rank-order-preserving encoding, `rankOrder.js`
  is the in-memory comparator and sort regime that consumes the
  same `passStylePrefixes` canonical table. Five sections distilled
  from the longform comments throughout `rankOrder.js`:
  `sameValueZero` (Map/Set-style equality used as the rank-tie
  predicate) and `compareNumerics` (NaN last and self-equal,
  +0/-0 tied) plus the three string-comparison modes selectable
  via `ENDO_RANK_STRINGS`; the derivation of `passStyleRanks`
  (per-PassStyle index and cover) from `passStylePrefixes`,
  including the BMP/printable-ASCII assumption, the multi-character-
  prefix sortedness assertion, and `getPassStyleCover`'s
  overestimate disclaimer; the inner comparator's per-PassStyle
  rules (tied-by-PassStyle for undefined / null / error / promise;
  trivial less-than for boolean / bigint; symbol-via-name-string;
  per-style numeric for number; copyRecord's lexicographic-inverse-
  property-names that produces subset-ranks-earlier; copyArray's
  lexicographic-with-prefix; byteArray's shortlex with the
  immutable-arraybuffer-shim workaround; tagged's tag-then-payload;
  and the NaN-default compareRemotables that produces deep-tied
  pairs like `[r1, 0]` and `[r2, "x"]`); `sortByRank`'s manual
  fixup for the `Array.prototype.sort` `undefined` quirk under the
  reverse comparator, the linked invariant that `passStylePrefixes`
  MUST NOT sort any category after `undefined`, and the
  WeakMap-keyed-by-comparator memoization pattern that powers the
  already-sorted shortcut; and `makeFullOrderComparatorKit`'s
  strict refinement of rank order via first-seen-ordering of
  remotables, the BEWARE clause on observable mutable state, the
  scalars-cross-fresh-comparators invariant, the no-store-ordering
  caveat, and the longLived parameter's WeakMap vs Map trade-off.

  Refreshed 2026-06-27 (job
  `scholar-refresh-marshal-rankorder-encodepassable`) from
  `2e933309` to `337d16a8`. The five original sections' backing
  comment clusters were unchanged (only function signatures gained
  optional `compare` defaults and the file grew by 34 lines, so
  their `source_line_range` snapshots were re-pinned). One new
  comment cluster appeared: the `compareRankRemotablesTied` /
  `compareAntiRankRemotablesTied` comparator that ties all
  remotables and does not short-circuit on encountering them, and
  which became the default `compare` argument for `isRankSorted`,
  `assertRankSorted`, `sortByRank`, `rankSearch`, `getIndexCover`,
  `unionRankCovers`, and `intersectRankCovers`. Captured as the
  sixth section (`compare-rank-remotables-tied-default-comparator`);
  it supersedes nothing.
---

## Abstract

`packages/marshal/src/rankOrder.js` is the **in-memory rank-order
regime** for `@endo/marshal`'s keyed-store substrate. Where
`encodePassable.js` (cycle 81) targets *bytes-on-the-wire so that
lexicographic byte order matches PassStyle rank order*, this file
targets *the comparator function and sort routine that take any
two passables and decide their relative position* in the same
rank order. Both files share the canonical `passStylePrefixes`
table from `encodePassable.js`: this file imports the table to
derive a per-PassStyle integer rank and a `RankCover` bracket
pair. The longform comments document five non-obvious decisions
the implementation rests on: the **`sameValueZero` predicate**
(JavaScript's `Map`/`Set` equality, where `NaN === NaN` and
`-0 === 0`) used as the rank-tie indicator, plus the
**`compareNumerics` rule** that places `NaN` self-equal and last
and ties `+0`/`-0`, plus the **three-mode `ENDO_RANK_STRINGS`
env-option** that selects UTF-16-code-unit vs Unicode-code-point
vs diagnostic-error string comparison; the **`passStyleRanks`
derivation** by sort-of-prefixes plus the multi-character-prefix
sortedness assertion plus the `getPassStyleCover` overestimate
disclaimer (no smallest/biggest bigint means the cover must
extend beyond the strict style bounds); the **inner comparator's
per-PassStyle rules** covering all 14 PassStyles, with the
copyRecord rule's *inverse-sorted-property-names* trick that
makes subsets rank earlier than supersets, the copyArray rule's
*prefix-ranks-earlier* property, the byteArray *shortlex* rule
with the immutable-arraybuffer-shim workaround, and the
remotable-default `NaN` that produces deep-tied pairs like
`[r1, 0]` and `[r2, "x"]`; the **`sortByRank` manual fixup**
for `Array.prototype.sort`'s `undefined`-at-end quirk under the
reverse comparator, linked to the `passStylePrefixes` invariant
that no category sorts after `undefined`; and
**`makeFullOrderComparatorKit`**, the strict alternative
comparator that assigns remotables an ordinal by first-seen
order, with the canonical `BEWARE` clause naming the covert-
channel hazard of sharing such a comparator across mutually-
distrusting subsystems. A sixth section, added in the 2026-06-27
refresh, covers the later-added **`compareRankRemotablesTied`**
comparator — the rank comparator that ties *all* remotables for
the same rank and does not short-circuit on encountering them,
sitting between short-circuiting `compareRank` and the fully-
ordering `fullCompare`, and now the default `compare` argument
across the sort / search / cover API.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [same-value-zero-and-numeric-rank-semantics](../sections/endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) | marshal, pass-style | current |
| [pass-style-rank-derivation-and-rank-covers](../sections/endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers.md) | marshal, pass-style | current |
| [inner-comparator-per-pass-style-rules](../sections/endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) | marshal, pass-style | current |
| [sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant](../sections/endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant.md) | marshal, pass-style | current |
| [full-order-comparator-kit-observable-mutable-state](../sections/endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state.md) | marshal, pass-style | current |
| [compare-rank-remotables-tied-default-comparator](../sections/endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator.md) | marshal, pass-style | current |

## Provenance

- File last modified 2026-04-14 by Turadg Aleahmad.
- File-specific commit `337d16a895066a66e7c92d716449273d337dceb9`
  (captured 2026-05-29 by `git --git-dir=worktrees/endojs-endo.git
  log -1 --format=%H master -- packages/marshal/src/rankOrder.js`).
- Comments authored across the file's history primarily by Mark
  S. Miller and Kris Kowal, with substantial contributions from
  Richard Gibson, Turadg Aleahmad, and Michael FIG. The file has
  long-lived comment material going back to the
  `@agoric/marshal`-era; the rank-order regime predates the
  compactOrdered encoding (which encodePassable.js documents) and
  is one of marshal's load-bearing invariants.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js) at commit `337d16a8`.
