---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the live-budget-admission enforcement (design landed, nothing built)

Repository: this repo (garden). Garden-infra work -- edit and push directly
to `main2`, no PR (CLAUDE.md § Conventions).

## Why now

While budgeting a resumed autonomous loop (`minion-town-agenda-review`),
found that `designs/live-budget-admission.md` -- despite its name and
despite landing this week -- has **zero enforcement code**: `config/budget-pools`
was never seeded, and none of `pool_admits`, the claim-gate check, the
direct-post routing, or the promotion gate exist anywhere in
`scripts/jobs/`. The design is real and detailed; only the build never
happened. The resumed schedule above is running on a per-job
`token-budget:`/`handler-timeout:` guardrail alone because this is the only
thing that actually works today -- exactly the gap the design exists to
close.

## Read first

`designs/live-budget-admission.md` in full, especially **§8 "Build slice"**
-- it already specifies the ordered steps; this job executes them, it does
not redesign anything. If reality has drifted from the design since it was
written (check for related landed work first -- `budgeted-campaign-dispatch.md`,
`recurring-budget-calibration.md`, and the `garden-budget-attribution`
orchestration all landed budget-adjacent pieces recently and may already
cover part of this), reconcile against what's actually landed rather than
assuming the design doc's snapshot is still accurate, and note any drift
explicitly in your report.

## What to build, in order (per §8)

1. **Turn the meter on.** Seed `config/budget-pools` with the two Anthropic
   accounts (`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`) and a
   weekly-token cap per account. **No calibrated number exists yet** --
   use a conservative placeholder (the liaison proposed 100000 as a
   per-job reference point today; scale sensibly for a WEEKLY fleet-wide
   figure, not a per-job one -- do not just reuse that number verbatim) and
   say explicitly in your report that it's a placeholder pending a real
   `/usage`-derived figure from the maintainer, not a calibrated cap. Wire
   `GARDEN_TOKEN_WEEKLY_QUOTA` per host from it. Align the window to the
   Friday 21:00 PT anchor the design specifies.
2. **`pool_admits <pool>`** in `common.sh`/`usage-meter.sh` -- generalize
   `meter_quota_status` to a pool argument, reusing the `off/unknown/ok/backoff`
   verdict and the 0.85 high-water mark, fail-open unchanged (a budget
   mechanism that fails closed on its own bugs is worse than none).
3. **Claim gate** in `claim-job.sh` -- decline-and-back-off when the
   claiming host's pool is in `backoff`.
4. **Direct-post routing** in `post-job.sh` -- route to `plan/ --budget-hold`
   instead of `todo/` when the fleet-level check is `backoff`.
5. **Promotion gate** in `foreman.sh` step 1 -- stop batch-promoting when
   all relevant pools are in `backoff`.
6. **`budget-level.sh`** -- the leader-only, no-LLM leveling controller
   the design names, on the scheduler substrate.

## Constraints

- **Fail-open, always**, per the design's own stated doctrine -- an
  unknown/unreadable budget state must never block work; only a confirmed
  `backoff` verdict does.
- **This governs admission, not the per-job `token-budget:`/`handler-timeout:`
  mechanism** -- those already work (confirmed live in `reaper.sh`) and stay
  as-is; this is the separate, currently-missing fleet-wide layer.
- Don't retrofit `minion-town-agenda-review` or any other specific schedule
  to depend on this landing -- they already have their own per-job budget
  as a standalone guardrail regardless of whether this build succeeds.

## Deliverable

The six numbered pieces landed and wired, `config/budget-pools` seeded
with an explicitly-flagged placeholder cap, and a report naming what
changed, what (if anything) was already covered by other recently-landed
budget work, and the placeholder-cap caveat.

<!-- garden-reaped: 1 -->
