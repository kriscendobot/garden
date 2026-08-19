---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: job_in_lifecycle() conflates "completed" with "still live," blocking legitimate re-directives

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions).

## What happened (the grounding incident)

Posting `endojs-endo-but-for-bots-pr475-reply-humans-resolve-policy` (a new,
legitimate directive replying to a maintainer decision on PR #475 comment
5333026938) was refused: `post-job.sh` derived the same directive identity as
an EARLIER, already-completed job on that comment
(`endojs-endo-but-for-bots-pr475-e3925eb5`, sitting in `jobs/tada/`), and
logged "directive '...' already owns live job '...'; not minting" — even
though the "owning" job was fully done, not live.

Root cause: `job_in_lifecycle()` (`scripts/jobs/common.sh`) checks
`plan|todo|doin` **and also `tada_exists`**, i.e. it treats a *completed* job
as still "in lifecycle" for the directive-identity dedup check in
`post-job.sh`. But `post-job.sh`'s own comment directly above that check says
the opposite is supposed to happen: "A stale entry — the owning base has
drained out of the lifecycle — is re-pointed below, so a genuinely new
directive is never blocked by a completed one." That re-point path is
unreachable as written: `job_in_lifecycle` returning true for a tada-complete
owner means the `elif ... job_in_lifecycle ...` branch always fires first and
`exit 0`s before the re-point logic below it ever runs.

I unblocked this instance by hand — verified the owning job
(`endojs-endo-but-for-bots-pr475-e3925eb5`) was genuinely complete, then
removed its stale `jobs/index/9d1b37bae6c5083a` entry directly (a directive
index is a mutable pointer meant to be re-pointed, not append-only journal
history, so this is a maintenance edit, not a history rewrite) and reposted.
This job is the actual fix so the next occurrence doesn't need a human to
notice and hand-edit an index file.

## The fix

`job_in_lifecycle()` is used in (at least) two places with two DIFFERENT
correct meanings — check both call sites before changing anything, don't
assume:

1. **The directive-identity dedup in `post-job.sh`** (and its analog in
   `post-plan.sh`/wherever else identity dedup is checked) wants "is the
   owning base still ACTIONABLE" — i.e. `plan|todo|doin` only, tada excluded.
   A completed owner should always let a fresh directive on the same
   comment/identity mint its own new job, per the re-point comment that's
   already there but currently dead code.
2. **The base-level (non-identity) lifecycle check** a few lines above in
   `post-job.sh` (`if [ -e plan ] || [ -e todo ] || [ -e doin ]`) already
   correctly excludes tada and handles the tada-collision case SEPARATELY
   with its own WARN (the basename-isodate fix from earlier today). Do not
   collapse this into `job_in_lifecycle` or you'll lose that distinct WARN
   behavior.
3. Grep every other call site of `job_in_lifecycle` (`common.sh`,
   `orchestrate.sh`, watchers) before changing its behavior — the doc
   comment on the neighboring `gauntlet_record_for_pr`-style helper
   (`scripts/jobs/common.sh:4785`, "the same set job_in_lifecycle checks, or
   the watchers would misread a dedup against a plan-parked owner as a lost
   push") suggests at least one OTHER caller may genuinely need the
   tada-inclusive behavior for a different reason. If so, **do not change
   `job_in_lifecycle` itself** — instead give the identity-dedup check in
   `post-job.sh` its own narrower predicate (e.g. `job_is_active` =
   `plan|todo|doin` only) and use that at the one call site that needs it,
   leaving `job_in_lifecycle` and its other callers untouched.

## Acceptance

- A regression test: post a directive identity whose owning base has
  completed (moved to `tada/`), and assert a fresh directive on the same
  identity is NOT refused — it mints its own new job and the identity index
  is re-pointed to the new base.
- Existing tests for the live-owner-blocks-dedup case (a genuinely
  still-active owner) and the bare-basename tada-collision WARN (today's
  earlier fix) still pass unchanged.
- Report cites this incident (`endojs-endo-but-for-bots-pr475-reply-humans-resolve-policy`
  vs. the stale `endojs-endo-but-for-bots-pr475-e3925eb5` owner) as the
  grounding example.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-19T04:33:42Z
