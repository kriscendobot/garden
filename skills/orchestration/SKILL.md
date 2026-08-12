---
created: 2026-07-01
updated: 2026-08-12
author: gardener, builder
---

# Skill: orchestration

Decompose a **multi-part job** into planned child sub-jobs plus one **orchestration
job** that sequences the children into `todo/` (serial by default, or parallel) and
**watches them to completion** — so the garden is less likely to forget to follow
up with the next child. Architecture in
[`designs/orchestration-jobs.md`](../../designs/orchestration-jobs.md).

## Purpose

The maintainer's standing directive (kriskowal 2026-07-01): **for a multi-part job,
always make an orchestration job.** Instead of posting a loose pile of sub-jobs and
hoping the follow-ups happen, post the sub-jobs *parked* and one orchestration
record that drives them in order, watches each reach `jobs/tada/`, reports
progress, and applies a failure policy rather than silently stalling.

## Inputs / state

- **Child sub-jobs**, parked in `jobs/plan/` with gate `orchestrated`
  (`post-plan.sh --orchestrated --orchestrated-by <orch-base> <child> [body]`).
  This gate is invisible to the foreman (which auto-promotes only `deferred`) and
  to the unblock watcher (which promotes only `blocked`), so **only** the
  orchestrate watcher ever promotes a child.
- **An orchestration record** `jobs/orch/<orch-base>.md`
  (`post-orchestration.sh`), leading YAML frontmatter:

  ```
  ---
  order: serial | parallel           # sequencing (default serial)
  children: child-a child-b child-c  # space-separated, in run order
  on-child-failure: halt | continue  # policy on a child failure (default halt)
  state: pending | running | done | halted   # managed by orchestrate.sh
  budget_tokens: 2080000             # optional; positive integer, serial only
  resume_from: prior-campaign        # optional; adopts its parked remainder
  created_by: <role>
  created_at: <iso8601>
  ---
  <human description of the multi-part work>
  ```

  `jobs/orch/` sits alongside `todo/doin/tada` but **outside** the claim lifecycle
  (like `plan/` and `index/`): never claimed, never reaped.

## Procedure

1. **Decompose** the multi-part work into ordered child sub-jobs. Each child is a
   normal, independently-claimable job — its body is the work a gardener does.
2. **Park the children** (in run order):
   `post-plan.sh --orchestrated --orchestrated-by <orch-base> <child> [body-file]`.
3. **Record the orchestration:**
   `post-orchestration.sh [--serial|--parallel] [--on-child-failure halt|continue]
   [--budget-tokens N] [--resume-from terminal-campaign]
   <orch-base> <child>...`. It validates each child is parked, then writes the
   record. Serial is the default; `--parallel` promotes all children at once. A
   token budget is serial-only because parallel promotion admits every child
   before actual spend exists.
4. **The deterministic watcher drives it.** `orchestrate.sh` (the leader-only
   `garden-orchestrate` timer, ~3m cadence, **no `claude -p`**) advances every
   active orchestration ONE step per tick against the board state:
   - **serial** — promote child #1 (`promote-plan.sh`), WATCH it reach
     `jobs/tada/`, then promote #2, … one at a time, in order. Immediately before
     each budgeted promotion, freshly sum billable tokens (input + output + cache
     creation; cache reads excluded) from the named children's ledgers at or
     after `created_at`. At/over the cap, finish `budget-exhausted` and leave the
     remainder parked. A malformed/unmetered matching row finishes
     `budget-meter-incomplete`, also without promotion or sweeping.
   - **parallel** — promote ALL children at once, then watch them all.
   - **child state** is read purely from the board: `done` (in `tada/`), `active`
     (in `todo/`/`doin/`), `parked` (in `plan/`), or `failed` (in NONE of them —
     it was promoted but vanished without a `tada/` report; its report carries
     `orchestration-failed: true`; or the watcher observes a requeue rise, an
     excessive requeue count, or time in flight beyond its handler budget).
   - **on a child failure** it applies the policy — **halt** stops a serial run at
     the first failure (sweeping not-yet-run downstream children) and **surfaces
     the failure to the maintainer inbox**; **continue** proceeds to the next
     child. Never a silent stall.
5. **Completion.** When every child is terminal the watcher writes
   `jobs/tada/<orch-base>.md` (an outcome summary carrying an
   `orchestration-status:` marker) and removes the record, so the orchestration
   shows as done on the board and stops being scanned. Any failures surface to the
   maintainer. Budgeted completion includes budget, spend, non-negative unspent,
   and overshoot quantities in the report and sends the unused remainder to the
   maintainer inbox as a visible permission-not-exercised event.

## Resume a budget-stopped remainder

Start a new campaign with a new explicit budget and accounting epoch:

```sh
post-orchestration.sh --serial --budget-tokens <new-cap> \
  --resume-from <budget-terminal-campaign> <new-campaign> <full-child-list>
```

The terminal report's `campaign-parked-children:` field is authoritative.
Posting verifies those children are still parked and owned by the terminal
campaign, then retags them and creates the new record in one journal commit.
Completed children may remain in the full list and are skipped normally. Never
edit or replenish an old campaign's budget in place.

## Why not just `blocked_on` + unblock

The `blocked_on` + `unblock.sh` chain is the OTHER deterministic serial primitive
(child B `blocked_on` A → promoted when A lands in `tada/`). The orchestrator is
built on that same **"promote when the board reaches a state"** substrate, but
**owns** promotion of its children so it can express three things a pure
`blocked_on` edge cannot:

- **parallel** fan-out (promote all at once), not just a linear chain;
- an **active progress report** and a single completion record for the whole unit;
- a **failure policy** (halt vs continue) — `unblock.sh` promotes the next child
  whenever the blocker merely *reaches* `tada/`, with no notion of the blocker
  having *failed*.

For a plain two-step linear dependency with no parallelism, progress, or failure
policy, `post-plan.sh --blocked --blocked-on <predecessor>` remains the lighter
tool. Reach for an orchestration when the work is genuinely multi-part.

## Output

`jobs/tada/<orch-base>.md` (the outcome summary) once all children are terminal;
each child leaves its own `tada/<child>.md`. A halt or a completion-with-failures
also leaves a maintainer-inbox note.

## Notes

- **Serial preserves order strictly:** a tick promotes the next child only after
  the current one is in `tada/`; while a child is `active`, the tick waits.
- **Idempotent + restart-safe:** promotion (`promote-plan.sh`) and the record
  writes are basename-idempotent and CAS-retried; a re-post of an existing
  orchestration is a no-op. The watcher recomputes state from the board each tick,
  so a missed or duplicated tick self-heals.
- **Leader-only** so a child failure surfaces to the maintainer exactly once
  (child promotion itself is CAS-deduped and safe on any host).
- **Children must be parked before the orchestration is recorded** —
  `post-orchestration.sh` enforces this; a child that never existed reads as
  `failed` (there is no way to distinguish "never posted" from "vanished").
- **Budgets gate admission, not execution:** an already-promoted child is never
  killed. Its actual cost may overshoot the declaration; the watcher reports the
  overshoot and stops before the next promotion.
