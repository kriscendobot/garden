---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: kriskowal/garden (main2, direct push; no PR)

**A serial orchestration dispatched its second child while its first was still
parked, and the second child was the destructive one.** Only a hand-written
precondition in the job body prevented irreversible data loss. Fix the ordering
guarantee.

## What happened (2026-08-13)

Orchestration `genie-docs-to-journal-orchestration-r2`, posted at 21:58:01Z with
`order: serial`, `on-child-failure: halt`, children in order:

1. `genie-docs-r2-01-migrate-into-journal` — copy 184 documents from
   endojs/endo-but-for-bots `llm` into the journal.
2. `genie-docs-r2-02-delete-from-llm` — DELETE those directories from the branch.

At 22:08:48Z the stage-2 gardener reported it had been promoted and claimed while:

- stage 1 was still parked in `jobs/plan/` (gate=orchestrated),
- the orchestration record was `state: pending`,
- no stage-1 `tada` report existed,
- `library/endo-but-for-bots/` did not exist in the journal.

It refused and deleted nothing, solely because the job body carried an explicit
"verify stage 1 completed, else STOP" precondition. **Had that precondition not
been written by hand, the job would have deleted the only copy of 184 documents.**

The orchestration record (`jobs/orch/genie-docs-to-journal-orchestration-r2.md`)
corroborates: `order: serial` with dispatch metadata present for BOTH children
(`child-genie-docs-r2-02-delete-from-llm-reap-count: 0` alongside stage 1's).

## What to fix

1. **Enforce the serial invariant in the watcher, not in job bodies.** In a
   serial orchestration, child N+1 must not leave `plan/` until child N is in
   `tada/`. Find why `orchestrate.sh` promoted child 2 with child 1 parked and
   the record `pending`. Suspects worth checking first: promotion racing the
   record's own state transition; a newly-created orchestration whose children
   are promoted before `state` is written; the `pending` -> `running` transition
   not being atomic with the first promotion.
2. **Consider whether recent changes are implicated.** `df2226c2b8` (atomic board
   snapshots) and `9393c3ce6d` (re-sync before trusting a `gone` verdict) both
   touched this area within the last day. Determine whether this is a regression
   from either, a pre-existing bug they did not cover, or independent. Say which.
3. **Add a regression test that reproduces the violation deterministically** and
   fails without the fix, in the style of `orchestrate-test.sh` SUBTEST 20: post a
   serial orchestration, assert child 2 is NOT dispatchable while child 1 is
   parked, across the pending-to-running transition.
4. **Fail safe on ambiguity.** If the watcher cannot establish that child N
   completed, it must not promote child N+1. A serial chain that stalls is
   recoverable; one that runs a destructive stage early is not.

## Why this is high priority

Serial ordering is the ONLY thing protecting destructive stages in every
migration, deletion, and deploy chain the fleet runs. The standing decomposition
pattern in CLAUDE.md tells producers to express exactly this dependency as a
serial orchestration. If serial does not hold, that guidance is actively
dangerous, and the next chain may not have a defensive precondition written into
its body.
