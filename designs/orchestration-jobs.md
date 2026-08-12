---
created: 2026-07-01
updated: 2026-08-12
author: designer, builder
---

# Design: orchestration jobs (sequence a multi-part job's children and watch them)

Maintainer directive (kriskowal 2026-07-01): **for a multi-part job, always make an
orchestration job** that moves the planned sub-jobs off `plan/` into `todo/` **in
sequence (default) or parallel (as instructed)**, and the orchestrator **watches
the progress of the child jobs** so it is **less likely to forget to follow up with
the next job**.

## Problem

Before this, a multi-part task was handled by posting several sub-jobs and relying
on ad-hoc follow-ups (a gardener's `## Follow-ups` section drained by
`garden-follow-up`, or a human remembering). Two failure modes:

- **Forgotten follow-up.** Nothing owns "run part 2 after part 1 lands." The chain
  stalls silently when a follow-up is missed.
- **No failure handling.** If part 1 fails, nothing decides whether the rest should
  still run.

The garden already had **two** deterministic promotion substrates worth reusing:

- `promote-plan.sh` — moves a parked `plan/` job into `todo/`.
- `blocked_on` + `unblock.sh` — a `gate: blocked` plan carrying `blocked_on: <PR|job>`
  is promoted deterministically when its blocker completes (a PR merges/closes or a
  blocking job lands in `tada/`). This is already *serial promotion* for a linear
  chain.

## Decision

Build a first-class **orchestration** on the same "promote when the board reaches a
state" substrate, adding the three things `blocked_on` alone cannot express:
**parallel fan-out**, an **active progress report + single completion record**, and
a **failure policy** (halt vs continue — `unblock.sh` has no notion of a blocker
having *failed*, only of it *reaching* `tada/`).

### Mechanism

- **Children** are parked in `jobs/plan/` with a new gate **`orchestrated`**
  (`post-plan.sh --orchestrated --orchestrated-by <orch-base> <child>`). The gate is
  invisible to the foreman (auto-promotes only `deferred`) and to `unblock.sh`
  (promotes only `blocked`), so **only** the orchestrate watcher promotes a child —
  no other mover races it. The `orchestrated_by:` field records the owning
  orchestration for discovery/audit.
- **The orchestration record** `jobs/orch/<orch-base>.md` (`post-orchestration.sh`)
  names the children (run order), the `order` (`serial`|`parallel`), and the
  `on-child-failure` policy (`halt`|`continue`). `jobs/orch/` sits alongside the
  lifecycle like `plan/`/`index/`: never claimed, never reaped.
- **Optional serial budget.** `--budget-tokens N` declares a positive billable-
  token cap and uses the record's `created_at` as its accounting epoch. Before
  every parked-child promotion, `campaign-spend.sh` freshly folds the named
  children's matching CostRecord rows. At/over cap, `orchestrate.sh` finishes
  `budget-exhausted`; malformed or unmetered matching rows finish
  `budget-meter-incomplete`. Both outcomes keep and enumerate the unpromoted
  remainder in `plan/`. Parallel budgets are rejected. Full rationale and dollar
  reporting semantics are in [budgeted-campaign-dispatch.md](budgeted-campaign-dispatch.md).
- **Separate-budget resume.** `--resume-from <terminal-campaign>` verifies the
  terminal report's parked remainder, atomically retags those plan files to a new
  campaign, and creates a new record with a new budget epoch. It never mutates an
  old budget declaration or rolls unused permission forward automatically.
- **The watcher** `orchestrate.sh` — the leader-only `garden-orchestrate` timer,
  deterministic, **no `claude -p`**, modeled exactly on `unblock.sh` — advances
  every active orchestration ONE step per tick:
  - **serial:** promote child #1, watch it to `tada/`, then #2, … one at a time.
  - **parallel:** promote all children at once, then watch them all.
  - **child state** from the board: `done` (`tada/`), `active` (`todo`/`doin`),
    `parked` (`plan`), or `failed` (in NONE — promoted then vanished without a
    `tada/`: the reaper doomed it after repeated handler failures; or the report
    carries `orchestration-failed: true`).
  - **failure:** `halt` stops a serial run at the first failure, sweeps not-yet-run
    downstream children, surfaces to the maintainer inbox; `continue` proceeds.
  - **completion:** write `tada/<orch-base>` (outcome summary with an
    `orchestration-status:` marker) and remove the record.

### Why leader-only

Child promotion is CAS-deduped and safe on any host, but the maintainer failure
note is not (two hosts would double-post). So the unit carries the
`is-main-host.sh` `ExecCondition`, like the proxy/foreman/reaper singletons.

### Why deterministic, not an agent

The directive's own worry — "less likely to *forget* to follow up" — argues for a
deterministic engine over an agent holding a gardener slot and polling. The watcher
recomputes state from the board each tick, so a missed or duplicated tick
self-heals, and nothing can forget.

## Alternatives considered

- **Pure `blocked_on` chaining** (child B `blocked_on` A, C `blocked_on` B, driven
  only by `unblock.sh`). Rejected as the *sole* mechanism: it cannot express
  parallel fan-out, produces no single progress/completion record, and — critically
  — promotes the next child whenever the predecessor merely *reaches* `tada/`, so it
  cannot honor a halt-on-failure policy. It remains the right, lighter tool for a
  plain linear two-step dependency; the orchestration is for genuinely multi-part
  work. The two share `promote-plan.sh` and the tada-detection idiom.
- **A gardener claims the orchestration and spins**, promoting + polling inside one
  `claude -p`. Rejected: it holds a slot, burns tokens polling, and *can* forget
  (the exact failure the directive targets). The record-plus-deterministic-watcher
  shape is strictly more reliable.

## Tests

`scripts/jobs/test/orchestrate-test.sh` (hermetic, throwaway journal, no systemd):
serial promotes one child at a time and advances only after each reaches `tada/`;
parallel promotes all at once; a child failure halts a serial run (next child NOT
promoted, downstream swept, surfaced to maintainer) under `halt` and proceeds under
`continue`. Budget coverage adds under-cap promotion, exact-cap stop, overshoot,
epoch filtering, all-outcome aggregation, malformed/unmetered fail-closed,
non-sweeping remainder, visible unspent completion, parallel rejection, and
separately-budgeted resume. 25 assertions.

## Files

- `scripts/jobs/post-orchestration.sh` — record an orchestration over parked children.
- `scripts/jobs/orchestrate.sh` — the deterministic watcher.
- `scripts/jobs/campaign-spend.sh` — fresh CostRecord reducer and reporting snapshot.
- `scripts/jobs/post-plan.sh` — `--orchestrated` / `--orchestrated-by` gate.
- `scripts/jobs/common.sh` — `JOBS_ORCH`, `orch_*` frontmatter helpers.
- `scripts/systemd/garden-orchestrate.{service,timer}` — leader-only timer.
- `roles/orchestrator/AGENT.md`, `skills/orchestration/SKILL.md`.
