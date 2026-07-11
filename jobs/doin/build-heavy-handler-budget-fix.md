# Enable build-heavy jobs to succeed; poison deterministic overruns faster

**Garden's own repo** (`kriskowal/garden`, `main2`): isolated worktree off
`origin/main2`, push directly, no PR (garden-infra convention).

## Why (maintainer directive, 2026-07-11)

Two jobs (`ocapn-pet-daemon-dockerfile-minion`, `endojs-endo-but-for-bots-pr688-shepherd`)
**deterministically** hit the 2400 s (40-min) handler wall-budget (rc=124). A Docker
image build legitimately needs more than 40 min, so it overruns on **every**
requeue → the reaper poisons it after 5 cycles → **the docker build never
completes**, and each of those 5 cycles burns ~40 min of a gardener slot. The
maintainer wants: **(1) enable the docker build to succeed**, and **(2) notice the
burn faster**.

The mechanisms already exist and just need tuning — do NOT invent new machinery:

- **Per-job budget:** `scripts/jobs/gardener.sh` (~lines 330-358) already honors an
  optional `handler-timeout: <seconds>` job header, clamped to a MAX cap, in place
  of the default `GARDEN_HANDLER_TIMEOUT=2400`.
- **Deterministic-overrun signal:** the gardener stamps
  `<!-- garden-deadline-overrun: N -->` on an rc=124 wall-hit; the reaper
  (`scripts/jobs/reaper.sh`, `GARDEN_REAP_POISON_THRESHOLD=5`, the deadline-overrun
  branch ~lines 70-78) reads it.

## What to change

### 1. Enable the docker build to succeed (longer budget for build-heavy jobs)
- **Raise the MAX cap** on the per-job `handler-timeout:` in `gardener.sh` so a
  real Docker image build fits (inspect the current max; set a value that comfortably
  covers a cold `docker build` — on the order of a few hours — while keeping the
  `GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL` invariant,
  raising `GARDEN_CLAIM_TTL` if needed so the invariant still holds).
- **Give build-heavy jobs the longer budget.** Prefer the job carrying an explicit
  `handler-timeout:` header. Apply it to the **docker-build job class** — at minimum,
  ensure `ocapn-pet-daemon-dockerfile-minion` (re-posted after it poisons/requeues,
  or whatever producer emits it) carries a `handler-timeout:` sufficient for the
  build. If a producer/classifier can stamp docker/`build`-shaped jobs by pattern,
  do that; otherwise document the requirement where such jobs are posted so it isn't
  forgotten. The goal is concrete: the ocapn docker build actually completes.

### 2. Notice the burn faster (poison deterministic overruns sooner)
- In `reaper.sh`, a job carrying the `garden-deadline-overrun` marker is a
  **deterministic** wall-overrun that a requeue cannot fix (once it exceeds even its
  budget). Give it a **much lower poison threshold** than the general
  `GARDEN_REAP_POISON_THRESHOLD=5` — e.g. **1** (surface after the first deterministic
  overrun, not the fifth) — so it stops burning ~5× the budget before the maintainer
  hears about it. Keep the general threshold (for non-deterministic stale claims) as
  is; this lower threshold is specifically for the deadline-overrun-marked case.
- The interplay is the point: (1) lets a legitimately-long job finish under a bigger
  budget; (2) fast-surfaces a job that overruns **even its raised budget** (genuinely
  stuck/broken) instead of churning.

## Verify
- `bash -n` + `shellcheck -S warning` clean on both scripts.
- Show, by reading the code paths (or a focused harness), that: a job with a large
  `handler-timeout:` header is honored up to the new max; a deadline-overrun-marked
  job poisons at the new low threshold while an ordinary stale claim still uses the
  general threshold; the TTL invariant still holds at the new max.

## Skills
- [self-improvement](../../skills/self-improvement/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md).

## Done
Build-heavy jobs can carry a budget large enough to complete (docker build succeeds),
the max cap and TTL invariant accommodate it, and a deterministic wall-overrun is
poisoned after 1 cycle instead of 5. Committed and pushed to `main2`. The `tada`
report gives the SHA, the new max/threshold values chosen, how the docker job class
gets its budget, and the verification evidence. Note that the change takes effect on
this host at the next deliberate deploy.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  claimed_at: 2026-07-11T09:24:16Z
