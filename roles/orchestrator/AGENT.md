# Role: orchestrator

Purpose: decompose a **multi-part job** into ordered child sub-jobs plus one
**orchestration job** that sequences the children into the queue and watches them
to completion — so a follow-up is never forgotten.

## Skills

- [orchestration](../../skills/orchestration/SKILL.md) — the decompose → park
  children → record orchestration → deterministic-watch pattern (the whole job).
- [job-board](../../skills/job-board/SKILL.md) — the plan/promote/claim primitives
  the orchestration is built on.

## Operating norms

- **The maintainer directive (kriskowal 2026-07-01):** for a multi-part job,
  always make an orchestration job that moves the planned sub-jobs off `plan/` into
  `todo/` **in sequence (default) or parallel (as instructed)**, and **watches the
  progress of the children** so the garden is less likely to forget to follow up
  with the next one. This is the standing decomposition for multi-part work.
- **Two halves.** The orchestrator is mostly **producer + engine**:
  1. A producer (the liaison, a gardener, the steward posture) *sets up* an
     orchestration — decompose, park the children (`post-plan.sh --orchestrated
     --orchestrated-by <orch-base> <child>`), record it (`post-orchestration.sh`).
  2. The deterministic `orchestrate.sh` watcher (the leader-only
     `garden-orchestrate` timer, **no `claude -p`**) *drives* it: promote per
     order, watch each child reach `jobs/tada/`, report progress, apply the
     failure policy. The engine is deterministic on purpose — determinism, not an
     agent that could forget, is what makes the follow-up reliable.
- **Serial is the default; parallel only when the parts are independent.** Serial
  promotes child #1, watches it to `tada/`, then #2, … Parallel promotes them all
  at once. Choose parallel only when the children have no ordering dependency.
- **Failure policy is explicit.** `--on-child-failure halt` (default) stops a
  serial run at the first failed child, leaves the not-yet-run downstream
  children parked under their held `orchestrated` gate, and surfaces the failure
  to the maintainer; `continue` proceeds. A
  child "fails" when it vanishes from the board without reaching `tada/` (the
  reaper doomed it) or its report declares failure. The child emits the exact
  line `<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately before its final
  `<<<GARDEN-JOB-COMPLETE>>>` line; completion mechanically stamps
  `orchestration-failed: true` into leading report frontmatter. Do not instruct a
  child to free-type the parsed field into prose. **Never a silent stall** — that
  is the whole point of the watch. Board state is read from one committed Git
  tree; an unreadable or multiply-located child retries next tick rather than
  being guessed failed.
- **Relate to `blocked_on`, don't duplicate it.** For a plain linear two-step
  dependency with no parallelism, progress report, or failure policy,
  `post-plan.sh --blocked --blocked-on <predecessor>` + the unblock watcher is the
  lighter tool. Reach for an orchestration when the work is genuinely multi-part.
- **Children are ordinary jobs.** Each child body is the work a gardener claims and
  does normally; the orchestration adds only the sequencing, watch, and policy.
  Give each child a self-contained body — it runs in its own worktree, unaware of
  its siblings except through the board.

## Definition of done

The orchestration record `jobs/orch/<orch-base>.md` is written with its children
parked (gate `orchestrated`); or, once the watcher has driven it, every child has a
`tada/<child>` report and the orchestration has its own `tada/<orch-base>` outcome
summary with the record removed. A halt or a completion-with-failures has surfaced
to the maintainer inbox.
