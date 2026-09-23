---
kind: result
role: gardener
host: endolinbot
at: 2026-06-27T14:55:34Z
---
---
role: scholar
job: scholar-ingest-passable-equality
host: endolinbot
---

# result: scholar-ingest-passable-equality

Deepened **pass-invariant equality** beyond its Handle-side framing by
authoring the sibling concept page `library/concepts/passable-equality.md`,
the marshalling-level equality invariant the job requested.

## Idempotency check (no source re-ingest)

The equality machinery the job named is already in-corpus; the cycle wrote no
new section/source files. Checked the four primary sources against upstream
`endojs/endo@master`:

- `packages/patterns/src/keys/compareKeys.js` — recorded `c63b8b7` == upstream
  `c63b8b7` → **current**, no re-ingest.
- `packages/patterns/src/keys/checkKey.js` — recorded `beab789` == upstream
  `beab789` → **current**, no re-ingest.
- `packages/marshal/src/rankOrder.js` — recorded `e619205` ≠ upstream `337d16a`
  → **drifted** (out of this job's scope; feeds `rank-order-preserving-encoding`).
- `packages/marshal/src/encodePassable.js` — recorded `2e93330` ≠ upstream
  `c423ed3` → **drifted** (same).

## Concept page authored

`concepts/passable-equality.md` (`topics: [patterns, marshal, pass-style]`) is a
synthesis page; every claim is grounded in already-ingested sections. It covers:

- `keyEQ(k1,k2) === (compareKeys(k1,k2) === 0)` as the application-level
  (`kindOf`) equality predicate; the three-level (`kindOf`/`passStyleOf`/JS)
  table from `marshal-vs-patterns-level.md`, where the transport level has *no*
  equivalence cell and the JS level is `===`/`Object.is`/`sameValueZero`.
- Key order is a **partial** order (incommensurate pairs return `NaN`), not the
  total order the patterns README loosely calls it; the five-predicate suite
  `keyLT/keyLTE/keyEQ/keyGTE/keyGT` returns `false` on incommensurate pairs.
- Key order **refines** rank order (`compareKeys(X,Y)<0 ⟹ compareRank(X,Y)<0`);
  rank order is the total-order completion. `keyEQ` implies rank-equal but not
  conversely (deep-tied remotables).
- How `sameValueZero` at atomic leaves composes up through structural recursion
  over `CopyArray`/`CopyRecord`/`CopySet`/`CopyBag`/`CopyMap` (remotables by
  identity only; copyRecord Pareto; copyMap comparison still unimplemented per
  endojs/endo#1737); the canonical rank-sorted internal form of the copy
  collections is what carries equality across the deterministic encoders.
- `isKey` gates the equality domain (errors/promises/non-frozen are Passables
  but not Keys).

Ten section links in its *Sections that touch this concept* table, plus
*Common confusions* disambiguating it from rank order, from
`pass-invariant-handle-equality`, and from `===`.

Note: `sameKey` (named speculatively in the job) is **not** an upstream symbol;
the canonical equality predicate is `keyEQ`. Curated to what exists.

## Indexes and cross-links touched (all via land-journal-edit.sh)

- `concepts/passable-equality.md` — new (landed, then re-landed to correct the
  See-also once `object-sameness`/`grant-matcher-puzzle` were found to already
  exist in-corpus as of today's `scholar-ingest-e-equality-taxonomy-adjacent`).
- `keywords.md` — 13 new keyword lines resolving to `passable-equality`.
- `concepts/README.md` — new seed-inventory row.
- `concepts/pass-invariant-handle-equality.md` — added a `[[passable-equality]]`
  See-also (the value-level counterpart of the Handle-side guarantee).
- `concepts/rank-order-preserving-encoding.md` — added a `[[passable-equality]]`
  See-also (key order is the partial order this total order completes).

Cross-linked as the job asked: `[[grant-matcher-puzzle]]` (motivation),
`[[pass-invariant-handle-equality]]` (Handle-side instance), `[[smallcaps-encoding]]`,
`[[rank-order-preserving-encoding]]`, and additionally `[[object-sameness]]`
(the E-language identity-taxonomy ancestor, ingested earlier today).

## Integrity gate (step 8)

`library-link-check.sh --nav` → exit 0 (10,716 links ok); `--files
concepts/passable-equality.md` → exit 0 (all 10 section targets + the
`concepts/README.md -> passable-equality.md` row resolve to committed files).

## Follow-on posted

`scholar-refresh-marshal-rankorder-encodepassable` (todo/, priority low) —
re-ingest the two drifted `@endo/marshal` sources at their current `master`
shas.

Self-improvement: the job spec named `sameKey` as a member of the equality
family, but no such symbol exists upstream — the predicate is `keyEQ`. Worth a
norm reminder that a job's named symbols are a hint, not ground truth: verify
each against source before ingesting, and curate to what exists rather than
inventing a page section around a phantom API. The idempotency-check-as-survey
also surfaced two drifted neighbors for free; running the check even when not
re-ingesting is cheap insurance worth keeping as a habit.
