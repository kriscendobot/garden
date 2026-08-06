---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-06T05:44:14Z cleared=none -->

# Plan: integrate @endo/reminder into Familiar

Parked in response to maintainer review
https://github.com/endojs/endo-but-for-bots/pull/721#pullrequestreview-4701251219
(kriskowal, 2026-07-15): *"Please post plans to follow-up with integration of this
plugin into Chat, Familiar, and minion.town."*

That directive was silently no-opped for two weeks on a false peer-resolution
signal; the defect itself is job `investigate-pr721-review-false-peer-resolution`.
This plan is one of the three the review actually asked for.

**Plan and propose. Do not implement the integration in this job.**

## The plugin being integrated

`@endo/reminder`, the message-scheduler plugin on
https://github.com/endojs/endo-but-for-bots/pull/721 (head
`build/endo-reminder-plugin`, base `llm-7d0d56c`). Note that PR is **open and
carries CHANGES_REQUESTED**, so the surface you are planning against is not final.
Read the PR and the design it came from before assuming an API. The maintainer's
standing direction is that this be an **unconfined plugin using vfs persistence**,
not daemon formulas (superseding the #609/#617/#619 shape).

## This target

**Familiar.** The `familiar` package in the fork (it has its own CI check,
`familiar-bundle`, so bundling is a live constraint on any integration).

Work out how a familiar schedules and receives reminders, how that composes with
its existing capabilities and its bundle, and whether the unconfined-plugin shape
fits the trust posture Familiar assumes.

## Deliver

A written plan concrete enough to execute without re-research: the integration
points, the API surface actually used, what persistence and lifetime look like,
what has to change on each side, the test strategy, and the ordering against the
other two integration plans and against #721 landing. Name what you could not
establish rather than guessing.

If the plan turns out to depend on #721 changing shape, say so plainly instead of
planning against an API that may not survive review.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T05:44:27Z
