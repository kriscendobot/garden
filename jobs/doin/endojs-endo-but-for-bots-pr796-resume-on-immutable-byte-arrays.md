---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-22T13:57:34Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Park PR #796 (hashline core + @endo/crc32) until immutable byte arrays land

Maintainer directive on endojs/endo-but-for-bots#796 (review
https://github.com/endojs/endo-but-for-bots/pull/796#pullrequestreview-4999289266,
@kriskowal, CHANGES_REQUESTED):

> Note to self: resume this on a rebase when immutable byte arrays merge.

Inline on `packages/crc32/src/crc32.js:56` (the intrinsic-`%TypedArray%`-length
Proxy guard):

> This is excess ceremony but also highlights that we should park this work until
> the work on byte arrays lands, since it will influence this such that it favors
> using `.at` as a protocol on immutable/mutable genuine/emulated ArrayBuffer views.

## State at park

- PR #796 is OPEN and DRAFT, head `2f355bb1b6ec94cbf5e656466c065046fecc8aeb`.
- The feature gauntlet `endojs-endo-but-for-bots-pr796-gauntlet-resume-20260821`
  is already **halted** (fix-1 doomed / requeue-exhausted), so nothing is driving
  the PR toward merge — the park is consistent with the current board state.
- No PR branch changes are made by this park; the crc32 length-guard "excess
  ceremony" is intentionally left in place, to be reworked toward a `.at` protocol
  over immutable/mutable (genuine/emulated) ArrayBuffer views when byte arrays land.

## Resume trigger (maintainer-gated `--deferred`)

Promote this plan (and re-open the gauntlet) once **immutable byte arrays merge**
into the `llm` line — the byte-arrays arc tracked by the `endo-byte-array-press-*`
schedule and `endojs-ebfb-*` / `registry-immutable-byte-array-*` jobs. On resume:
rebase #796 onto the byte-arrays-bearing `llm`, revisit the crc32 range API to use
`.at` over ArrayBuffer views, then re-run the feature gauntlet.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T14:31:03Z
