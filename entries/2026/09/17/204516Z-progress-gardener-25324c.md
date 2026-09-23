---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-17T20:45:25Z
---
# Claude-on-minion.town completion press — tick 20260917-203511

**Window:** 2026-09-17T14:21:27Z (prev dispatch) → 20:37Z. Read-only against a fresh
full-history journal2 clone at e9939952 (20:14:58Z); no board writes; inbox empty.
Board: todo=1, doin=2, plan=259, tada=8308, withdrawn=163.

## Roster resolved this tick

Active arc jobs (in flight, healthy):
- `endojs-endo-but-for-bots-pr1125-review-af33f29e` (doin, review directive) — enumerates
  kriskowal's new CHANGES_REQUESTED review 5240765072 on #1125 ("scroll-back for review has
  gotten too deep — divide into a stack of PRs"). Posted 19:58Z, garden-reaped:1, reap-now
  (2nd cycle imminent). Normal churn.
- `split-pr1125-into-stack` (todo, builder) — the substantive execution of that split
  directive (three candidate slices: read-only directory attenuation / guests inviting
  guests / special+pet names). Posted 20:07Z, garden-reaped:1, retry-not-before 20:23Z
  (now claimable). First reap cycle — normal churn.
  WATCH (next tick): these two jobs both stem from review 5240765072 and could contend on
  #1125; board-mechanics, not repaired here — flag if they collide or either enters a 3rd
  requeue cycle.

Completed in window (jobs/tada/, reports read — all CLEAN, no failure declarations):
- `endojs-endo-but-for-bots-pr1125-23cf90c0`, `-bc369e99`, `-ee75a88d` — #1125 review-address
  jobs (earlier review IDs, pre-split directive). No orchestration-failed / halt / refusal.
- `endojs-endo-but-for-bots-pr1125-fix-readonly-hub-makeexo-guard` — #1125 fix (readOnly hub
  makeExo+guard, warden request-changes addressed). Clean.
- `claude-on-minion-town-press-20260917-142127`, `-173510` — outward arc press (2 ticks; both
  "no arc state change" / routine).
- `claude-on-minion-town-completion-press-20260917-142127` — prior tick of THIS schedule. Clean.

Parked, unchanged, maintainer-gated (NOT newly doomed):
- `endo-claude-agent-sdk-{design,backend,probe}` (plan, gate go-ahead; liaison 2026-08-31).
- `build-minion-town-invitation-onboarding` (plan, blocked behind #1125 by design).
- `build-minion-town-claude-agents-capability` (plan, pre-existing doom doomed_at 2026-09-03,
  NOT in window).

## Counts / judgments
- Roster completed in window: 7 arc jobs (4× #1125 review-address/fix + 2 outward press + this
  schedule's prior tick), all CLEAN. Claimed-without-completing: 0.
- Design orchestration `claude-on-minion-town-designs`: COMPLETE (7/7 terminal); no advancement
  expected. Design phase settled; deliverables verified in prior ticks.
- New arc-scoped doom in window: 1 — `endojs-endo-but-for-bots-pr1125-aff3b059-retro`
  (prosecutor review-retrospective, doom_signature requeue-exhausted, doomed_at 20:03:11Z,
  doomed_on endolin-garden-ece02cb4). SUB-THRESHOLD: a `-retro` is best-effort review telemetry
  ("costs one data point"), blocks nothing in the arc, and the underlying review (aff3b059)
  itself completed. This is the recognized retro-doom NOISE class — the fleet's own infra job
  `improve-retro-doom-escalation-noise` (posted 19:23Z) documents that "6 of 10 requeue-exhausted
  doom notices on 2026-09-17 were -retro jobs, disproportionate" and proposes the reaper stop
  surfacing them. Two other retro dooms in window (minion.town pr32/pr69 review retros) reference
  NON-arc PRs → out of scope. No maintainer message: amplifying a retro doom is exactly the
  fatigue the maintainer asked this press to avoid.
- policy-refusals on arc jobs: 0. Absent-without-tada-report: 0. Completed-but-reported-failure
  among arc jobs: 0. Third-or-later requeue cycle: 0 (both active split jobs on 1st cycle).
- Arc work claimable in jobs/todo/ while workers idle: split-pr1125-into-stack sits in todo but
  is on reaper backoff (retry-not-before just elapsed), i.e. actively cycled, not orphaned.
- Reconciliation vs prior tick (142127): its watched #1125 review-address line all completed;
  the new #1125 split directive is fresh maintainer-driven arc work, not a stall. Nothing vanished.

## Disposition
arc nominal — no maintainer message posted (sole arc doom is a sub-threshold, recognized-noise
retrospective that blocks nothing). Schedule left STANDING.
