---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-11T01:54:03Z
---
role: prosecutor
job: endojs-endo-but-for-bots-pr609-review-4a711718-retro
refs: endojs/endo-but-for-bots#609:review:4675177693:retro

# Review retrospective — #609 review 4675177693 (miss; cluster tripped)

Second loop on kriskowal's CHANGES_REQUESTED review of endojs/endo-but-for-bots
PR #609 (`feat(daemon): interval-scheduler formula`). Idempotency pre-check clean
(no prior `misses/`|`dismissed/` record for the primary base).

## Discrimination

The review mixed a **design pivot** (reframe as a "message scheduler", push
persistence to the platform, make it an unconfined `@endo/reminder` plugin — new
direction, correctly routed to a designer by the primary loop, NOT a miss) with two
inline nits. One nit is a genuine **panel miss**: `makeIntervalSchedulerCmd` →
`makeIntervalScheduler` ("Avoid abbreviations… it isn't making a command"). The
endoclaw-timer gauntlet ran a full 10-seat code panel over host.js yet let the
`Cmd` abbreviation through. The third nit (omit a redundant `@module` JSDoc tag) is
trivial style, not clustered.

## Recorded

`review-misses/misses/endojs-endo-but-for-bots-pr609-review-4a711718.md`,
`verdict=miss category=naming missed_by=stylist severity=minor`, joining cluster
**`avoid-name-abbreviations`** → count=3, prs={650, 609}, recurrence=0.

## Threshold — floor met, dispatched

This is the exact trip-wire both #650 members named: a second panelled abbreviation
miss on a DIFFERENT PR. Floor now met (K≥3 across ≥2 distinct PRs) with no severity
bypass needed; the two-PR guard that held #650 is cleared. The maintainer's
spell-out preference spans five asks over three PRs (`Arg` #592, `subDir` #127,
`dir`/`Temp` #650, `Cmd` #609), no fix is in flight for the sensing gap (no seat,
skill, or gate encodes identifier-abbreviation avoidance), and the signal is
mechanically detectable — so dispatch, not hold.

Posted builder job **`review-improve-avoid-name-abbreviations`** (identity
`review-cluster:avoid-name-abbreviations`) with the two-part contract: (a)
prevention via a never-abbreviate directive in the builder/fixer briefs, and (b)
sensing via a tier-1 deterministic abbreviation-blocklist pre-push gate (modeled on
the `typedefs-belong-in-dts.sh` sibling), falling back to a stylist-seat amendment
plus a panel-hints probe. Re-litigation test required per member (#650 `dir` +
`makeTempRoot`, #609 `makeIntervalSchedulerCmd`), firing on the historical diffs and
abstaining on a legitimate control. Cluster marked `improvement-dispatched`.

Self-improvement: nothing this time.
