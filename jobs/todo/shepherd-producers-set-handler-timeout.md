# Teach the shepherd producers to set a CI-sized handler-timeout

**Garden's own repo** (`kriskowal/garden`, `main2`): isolated worktree off
`origin/main2`, push directly, no PR (garden-infra convention).

## Why (maintainer directive, 2026-07-12: "teach the shepherd")

A shepherd drives CI to green — it **waits on CI**, which routinely exceeds the
default **2400s (40-min)** handler budget, so shepherd jobs **deterministically
overrun** (rc=124). The budget path now exists (a per-job `handler-timeout:` header,
honored up to the claim max ~14339s / ~3.98h since `GARDEN_CLAIM_TTL` was raised to
4h — `scripts/jobs/gardener.sh:341-370`), and the reaper explicitly says an overrun
is "for a human to re-post with a larger `handler-timeout:`" (`reaper.sh:84`). But
**there is no auto-classifier** — the producer must stamp it, and the shepherd
producers don't. Result: shepherds keep overrunning (now poison-after-1, so
contained, but they still never COMPLETE). Close that: make the shepherd producers
emit the header.

## What to change

Both producers mint the shepherd job with basename `<slug>-pr<N>-shepherd` via
`post-job.sh`; both must include a `handler-timeout:` header in the job body:

1. **`scripts/jobs/comment-watcher.sh`** — the manual `shepherd #N` directive path.
2. **`scripts/jobs/ci-watcher.sh`** — the auto-shepherd-on-red path (same basename,
   so they never double-post; keep the bodies consistent so an idempotent re-post
   doesn't flap the header).

Add a `handler-timeout: <seconds>` line to the shepherd job body these producers
post. **Pick a value sized for CI-wait with headroom for a couple of fix→CI cycles**,
strictly **≤ the claim max** so the gardener honors it in place of the default rather
than clamping+escalating (gardener.sh:368-370). A shepherd that blocks on
`endojs/endo-but-for-bots` CI typically needs well beyond 40 min but under the ~4h
claim ceiling — **~7200s (2h) is a reasonable default**; justify the exact number
against typical CI-run durations you can observe, and centralize it (a single
constant / one code path both producers share) so it does not drift between the two.

- If a shepherd genuinely needs **longer than one claim** (>~3.98h of CI-driving), a
  bigger header cannot help — it would clamp+escalate (gardener.sh:370). Note this
  boundary; the fix targets the common case (minutes-to-a-couple-hours), not the
  pathological one.

## Also

- **Document it** in `roles/shepherd/AGENT.md` (an operating note: a posted shepherd
  job carries a CI-sized `handler-timeout:`; the value and why).
- **The gauntlet-embedded shepherd** (run as a *stage* inside the gardener's
  supervised gauntlet, not a separate posted job) rides the *gauntlet* job's budget,
  not this header — note whether that path also overruns and, if so, flag it as a
  sibling follow-on (do not fix it here unless trivial).
- **Sibling producer gaps** (gauntlet jobs, docker-image builds) have the same
  no-auto-classifier gap — out of scope for "teach the shepherd," but note them in
  the `tada` report so the maintainer can decide on a follow-on.

## Verify
- `bash -n` + `shellcheck -S warning` clean on both scripts.
- A shepherd job minted by each producer carries the `handler-timeout:` header, and a
  gardener claiming it logs "honoring in place of default" at the chosen value (not
  "clamping"). Show the header in a minted body and the honor-path log line.
- The two producers emit an identical header (no idempotent-repost flap).

## Skills
- [self-improvement](../../skills/self-improvement/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md).

## Done
Both shepherd producers stamp a CI-sized `handler-timeout:` on the shepherd jobs they
post, so a shepherd waiting on CI now **completes** instead of overrunning; documented
in the shepherd role; verified honored-not-clamped. Committed and pushed to `main2`.
The `tada` report gives the SHA, the value chosen and its justification, and the
sibling gaps (gauntlet/docker) noted for a possible follow-on. Takes effect on this
host at the next deliberate deploy.
