---
role: builder
---

# Stagger the reaper's requeue so a burst of expiring claims does not land at once

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): when a large set of stale claims is reaped, make sure
the requeue is **staggered** rather than dumped into `todo/` in one tick.

## The evidence that prompted this

Observed on the board at 16:10 UTC today. Of 45 claims in `jobs/doin/`, **42 were
claimed within about five minutes of each other**, roughly 12:33 to 12:38 UTC,
spread across only 8 workers (`endolin-garden2-5bcdff64` gardeners 1 through 8).
Eight workers cannot concurrently work 42 jobs, so most were orphaned by a restart
cycle on that host. The leader's reaper was demonstrably healthy through this
(`requeue: reaped 12 stale claim(s)` at 12:43, `2` at 12:53, `1` at 13:03).

Because they were claimed in one burst they cross `GARDEN_CLAIM_TTL` (4h) in one
burst, so a single reaper tick around 16:33 to 16:38 requeues roughly 42 jobs into
`todo/` together. The board then re-synchronizes: a pool that picks them up
together tends to strand them together, so the herd re-forms on the next cycle.

## The invariant you must not break

**Stagger may only ever DELAY a reap. It must never shorten an effective TTL.**

The reaper already floors staleness at `reap_age_threshold`, the handler's maximum
possible lifetime, precisely so a `GARDEN_CLAIM_TTL` set below the handler wall
cannot requeue a still-running handler. That, plus the live-handler guard that
kills and defers one tick, is what preserves the single-owner-per-worktree
invariant. Any jitter or reordering you add must sit **on top of** that floor.
Reaping even one claim earlier than it would be reaped today is a correctness
regression, not a tuning trade-off.

## What to build

The stale set is assembled into the `STALE` array in `scripts/jobs/reaper.sh`
(section "detect the stale set"), after the reap-now hint check, the age floor, and
the live-handler guard, and is then batch-requeued. That boundary, between
detection and requeue, is the natural seam.

Primary mechanism, a **per-tick cap**:

- Bound how many claims one tick requeues, behind a named knob with a sane default
  (something like `GARDEN_REAP_MAX_PER_TICK`, defaulting to a handful). Pick and
  justify the default against the 10-minute timer cadence, so a 42-job backlog
  drains over a few ticks rather than a few hours.
- **Oldest first.** Sort the capped selection by claim age so nothing starves. A
  cap that leaves the same claims permanently deferred is worse than no cap.
- **Log what you deferred.** The garden's standing rule is no silent caps: a tick
  that reaps 6 of 42 must say so, otherwise the log reads as "reaped everything"
  when it did not.

Then consider, and make a recommendation on, a **deterministic per-base jitter**
added to the threshold to desynchronize permanently rather than merely smoothing
one burst. Derive it from a hash of the job basename so it is stable across ticks
and testable, never from randomness or wall-clock. Keep it bounded and strictly
additive, so it can only push a reap later. Say in your report whether you judged
it worth the complexity on top of the cap, and if you skip it, say why.

Two interactions to get right and state explicitly:

- **Reap-now hints.** A gardener that stamps a reap-now hint on its own claim
  KNOWS the claim is dead, so it deliberately bypasses the TTL. Jitter must not
  delay those. Decide whether the per-tick cap should still apply to them, and
  justify whichever way you go.
- **Poison accounting.** Requeue drives the poison counter that escalates a job
  past its requeue-cycle limit. Deferring a reap by a tick must not change poison
  semantics or let a poison job escape escalation.

## Verification

Add coverage alongside the existing `scripts/jobs/test/reaper-live-handler-guard-test.sh`,
`reaper-poison-park-test.sh`, and `handler-orphan-reap-test.sh`. At minimum, assert
that a set larger than the cap is drained across successive ticks oldest-first with
none dropped, and assert the invariant directly: no claim is ever requeued at an
age below what today's code would require. Run the repo's local checks before
pushing ([skills/local-verify](../../skills/local-verify/SKILL.md),
[skills/pre-push-gates](../../skills/pre-push-gates/SKILL.md)); a CI failure is an
automation defect, not something to discover downstream.

## Note on when this takes effect

The reaper is a leader-only singleton, so this changes nothing until the leader
host deploys the new `main2`. It will **not** be in place for today's roughly
16:35 expiry burst, which will land as one batch. That is expected; this job is
about the next one.

## Done when

`scripts/jobs/reaper.sh` staggers its requeue behind a documented knob, the
oldest-first and no-silent-caps properties are covered by passing tests, the
never-reap-earlier invariant is asserted rather than assumed, and the report states
the chosen default with its reasoning and the recommendation on per-base jitter.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-28T16:16:40Z
