---
ts: 2026-05-29T12:20:15Z
kind: result
role: scholar
host: endolin
project: endo
refs:
  - inboxes/endolin/scholar.md
  - entries/2026/05/29/043207Z-result-scholar-10a6f1.md
---

# scholar cycle 84 result

Comment-fragment ingest (cycle 84, **sixth comment-fragment
ingest**, per the three-lane rotation following cycle 83's chat
lane). Ingested `endojs/endo: packages/marshal/src/rankOrder.js`
at file-specific commit `2e9333096fc82fabc9a3c1f6d3e268336e7df943`
(last touched 2026-04-14 by Turadg Aleahmad). Five sections
distilled from the longform comments throughout the file,
together covering the **in-memory rank-order regime** that is
the sister to cycle 81's `encodePassable.js` (bytes-on-the-wire
form). The two files share the canonical `passStylePrefixes`
table; `rankOrder.js` imports it from `encodePassable.js` and
derives a per-PassStyle integer rank and a half-open
`RankCover` from it.

## Pick rationale

The dispatch prompt named `marshal/src/rankOrder.js` as the
strongest candidate per cycle-83 result, complementing cycle
81's `encodePassable.js`. Verified the fit per the cycle-71
cohesion-over-density discipline + cycle-73 verify-bare-clone
discipline: the file carries multiple multi-paragraph cohesive
arguments (`sameValueZero` rationale, `compareNumerics` rank
rule, `passStyleRanks` derivation, `getPassStyleCover`
overestimate disclaimer, the per-PassStyle case rules,
`sortByRank`'s undefined-quirk fixup, and the
`makeFullOrderComparatorKit` BEWARE clause), not scattered
short comments. The file is ~610 lines with comment density
high enough for five well-bounded sections at the cycle's
~25-section budget.

The sister-to-encodePassable.js relationship is the second
rationale: the two files coordinate through the
`passStylePrefixes` table, and a reader looking up rank-order
semantics ought to find both sides in one concept-page lookup.
Cycle 81 cataloged the encoder; this cycle catalogs the
comparator and sort routines. Both now thread into the
`rank-order-preserving-encoding` concept.

## Sections

1. **same-value-zero-and-numeric-rank-semantics** — `sameValueZero`
   as marshal's rank-tie predicate (Map/Set's equality with
   NaN-equal-NaN and -0-equal-+0); the TODO API-naming
   acknowledgment; `compareNumerics` placing NaN self-equal and
   last and tying +0/-0; the three-mode `ENDO_RANK_STRINGS`
   env-option selecting between UTF-16 code-unit order (default,
   backward-compatible), Unicode code-point order (more
   linguistically-correct), and the diagnostic
   `error-if-order-choice-matters` mode for migration testing.
2. **pass-style-rank-derivation-and-rank-covers** — How
   `passStyleRanks` is derived from `passStylePrefixes` (sort
   by prefix, assign monotone index, compute `[low, high)`
   cover); the BMP / printable-ASCII assumption that licenses
   the trivial-comparator sort; the multi-character-prefix
   sortedness assertion that catches an out-of-order prefix
   before it silently produces an empty or wrong cover; the
   `getPassStyleCover` overestimate disclaimer (no smallest /
   biggest bigint forces the bigint cover into adjacent style
   ranges; the `[NaN, '']` example; callers filter the
   overestimate by per-value PassStyle check).
3. **inner-comparator-per-pass-style-rules** — The per-PassStyle
   rank rules covering all 14 styles: tied-for-rank for
   `undefined` / `null` / `error` / `promise`; trivial less-than
   for `boolean` / `bigint`; `compareByCodePoints` /
   `trivialComparator` switch for `string`; symbol-via-
   `nameForPassableSymbol` recursion; per-style `compareNumerics`
   for `number`; **copyRecord's lexicographic-inverse-sorted-
   property-names** that produces the subset-ranks-earlier
   property; **copyArray's lexicographic-with-prefix** that
   produces the prefix-ranks-earlier property; **byteArray's
   shortlex** with the `@endo/immutable-arraybuffer` shim
   prototype-check workaround; tagged's lexicographic-by-tag-
   then-payload; and the **NaN-default `compareRemotables`**
   that short-circuits the comparator chain and produces
   deep-tied pairs like `[r1, 0]` and `[r2, "x"]`.
4. **sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant**
   — Why `sortByRank` manually moves `undefined` from the end
   to the start under a reverse comparator: `Array.prototype.sort`
   has a JavaScript-language-imposed quirk that places
   `undefined` at the end regardless of the comparator's
   verdict. The detection check `compare(true, undefined) > 0`,
   the `copyWithin` + `fill` relocation algorithm, and the
   linked invariant `passStylePrefixes` MUST NOT sort any
   category after `undefined`. The cross-file dual enforcement
   (one site in `encodePassable.js`'s table-construction
   comment, one site in `rankOrder.js`'s `sortByRank` body).
   The `memoOfSorted` WeakMap-keyed-by-comparator caching
   pattern with the cross-comparator-inference optimization.
   The harden-then-sort-then-harden discipline.
5. **full-order-comparator-kit-observable-mutable-state** — The
   strict alternative to NaN-default rank order:
   `makeFullOrderComparatorKit` assigns remotables a
   monotonically-increasing ordinal on first encounter, then
   `compareRemotables` reduces to integer comparison.
   The strict-refinement property (any array sorted by full
   order also passes `isRankSorted` against the corresponding
   rank order). The canonical **BEWARE** clause on observable
   mutable state and the covert-channel hazard of sharing the
   kit across mutually-distrusting subsystems. The
   **scalars-cross-fresh-comparators invariant** (no-remotables
   arrays sorted by one fresh kit stay sorted under any
   other fresh kit). The **no-store-ordering caveat** (no
   memory of deleted keys; persistent stores must use rank
   order + a separate ordinal-mapping table). The
   `longLived` parameter's WeakMap (long-lived; GC-friendly)
   vs Map (default short-lived; bounded leak) trade-off.

## Indexing

- New source-index: `library/sources/endo--packages-marshal-src-rankorder-js.md`.
- Sources/README.md updated with a new row in the *External
  code-comment fragments* section.
- Sections/README.md updated with the new five-section block;
  total bumped to 561 sections / 130 source documents.
- Topics/README.md counts updated: `marshal` from 64 → 69;
  `pass-style` from 47 → 52.
- Topics/marshal.md and topics/pass-style.md each extended with
  five rows pointing at the new sections.
- Concept page `concepts/rank-order-preserving-encoding.md`:
  abstract expanded to cover both the bytes-on-the-wire form
  (encodePassable.js, cycle 81) and the in-memory comparator-
  and-sort form (rankOrder.js, this cycle) sharing the
  canonical `passStylePrefixes` table; aliases extended with
  the rankOrder-specific terms; sections-table extended with
  the five new rows; provenance note updated.
- Keywords block appended to `keywords.md` covering the
  rankOrder-specific lookup terms (`sameValueZero`,
  `compareNumerics`, `ENDO_RANK_STRINGS`, `passStyleRanks`,
  `RankCover`, `getPassStyleCover`, `sortByRank`, `isRankSorted`,
  `makeFullOrderComparatorKit`, `compareRank`, `antiComparator`,
  `comparatorMirrorImage`, `RankComparatorKit`, `FullComparatorKit`,
  `memoOfSorted`, shortlex, subset-ranks-earlier, prefix-ranks-
  earlier, deep-tied remotables, Array.prototype.sort undefined
  quirk, etc.). The block is appended at end-of-file; not
  alphabetized (keywords.md is grepped, not read).
- Inbox pointer advanced from `15789c38` (stale, predating
  CYCLE_HEAD) to CYCLE_HEAD `859c7070`.

## Library state

- **130 sources** (was 129).
- **561 sections** (was 556; +5 from this cycle).
- **27 topics** (unchanged).
- **44 concepts** (unchanged; cycle expanded existing
  `rank-order-preserving-encoding` rather than creating new).
- **~1156 keywords** (was ~1082; +74 in the cycle-84 block).
- **3 roles** (unchanged).

## Lane rotation

Three-lane rotation status (chat / papers / comments):
- Cycle 80: chat lane (chat-pending-commands).
- Cycle 81: comments lane (encodePassable.js).
- Cycle 82: papers lane (distributed-electronic-rights-2013).
- Cycle 83: chat lane (chat-slot-slash-commands).
- Cycle 84: comments lane (rankOrder.js). ← this cycle.
- **Cycle 85: papers lane** per dispatch prompt and rotation
  discipline.

## Notes for next cycle

**Cycle 85 picks papers lane.** Per the dispatch prompt's
post-Miller candidates from cycle-82 notes:

- **Robust Composition** (Mark Miller PhD thesis 2006). Multi-
  cycle ingest expected (~250 pages). Per conventions § Sources
  from external papers § Reading PDFs and § Per-cycle pacing:
  "plan multi-cycle ingest — one chapter or one cohesive
  argument cluster per cycle, not the whole document at once."
  This is the canonical capability-theory thesis; the library
  would benefit from at least the introduction + main results
  chapters even if late chapters defer to subsequent cycles.
- **Reasoning About Risk and Trust in an Open World** (Marc
  Stiegler 2006). One-cycle paper; companion to Stiegler's
  trademarks-2005 (queued earlier).
- **The Digital Path** (Stiegler + Miller 2002). Older paper
  in the lineage; possibly canonical citation for some
  earlier-than-Concurrency-Among-Strangers framing.

Pick the one that fits one cycle cleanly per the cycle-71
cohesion discipline. Robust Composition is the most ambitious
target (multi-cycle); if cycle 85 picks it, plan the chapter
boundary in advance.

## Comment-vs-code drift discipline

Per `conventions.md` § Sources from longform comments §
Notice / investigate / propose discipline. Reviewed
`rankOrder.js`'s comment claims against the surrounding code
during ingest; **no comment-vs-code drift surfaced**. The
file's comments are consistent with the implementation; in
particular the `sortByRank` undefined-fixup comment, the
`getPassStyleCover` overestimate disclaimer, the `compareRemotables`
default-NaN claim, and the `makeFullOrderComparatorKit` strict-
refinement claim are all faithfully implemented. The one TODO
the file flags (the `sameValueZero` API-naming concern) is an
acknowledged future-improvement point, not drift between
comment and code.

## Self-improvement

Self-improvement: nothing this time. The five-section ingest
followed the cycle-81 precedent cleanly; the concept-page
expansion-rather-than-new-creation discipline (when a sister
file extends an existing concept) is now a worked precedent for
future sister-file ingests.
