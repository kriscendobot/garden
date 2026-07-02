# garden-infra: POISON handling — park the job in `plan/` and dedup the maintainer message

**Garden-infra change on `main2`.** Isolated worktree off `origin/main2` per the hard rule
(`garden/roles/COMMON.md` § Per-subagent worktrees); the root checkout is read-only. Land with an
explicit-pathspec commit, push `HEAD:main2` via a rebase CAS loop. A short design note may precede the
change if the mechanism needs one, but the spec below is concrete.

## Why (maintainer directive, kriskowal, 2026-07-02)

Today's restart produced **37 near-identical reaper POISON reports** in the maintainer inbox (one per
requeue-exhausted job), and each poisoned job was simply **dropped from the board** — the work was lost
until a human reconsolidated it (see `resume-lint-ceiling-shepherds`). Both behaviors are wrong. The
reaper's POISON path must change on two axes:

### 1. Park the poisoned job in `plan/` instead of dropping it

When the reaper exhausts a job's requeue budget, rather than discarding it, **park it in `jobs/plan/`
(gated so no consumer auto-claims it) until the underlying issue is resolved**, so the work survives and
can be resumed. Reuse the existing plan-gating machinery (`post-plan.sh` gates: `blocked` / `deferred` /
`go-ahead`) rather than inventing a new state. Choose the gate that fits a poisoned job:

- Default to a **`deferred`/held** gate (a poisoned job needs a human or a cleared blocker before it
  runs again; it must never silently re-enter `todo/`).
- Preserve the original job body and record the poison provenance in the parked plan (requeue count,
  last failure signal if captured, timestamp, originating host).
- The parked plan's basename should be **deterministic from the original job base** so a re-poison of the
  same job updates the same plan entry rather than spawning duplicates (mirrors the message dedup below).

### 2. Amend-or-post the maintainer message only when substantially different

Replace the "post one message per poison event" behavior with **dedup**: keep a keyed record of the
open POISON notice for a given job/condition, and

- if a notice for the **same job and substantially-same condition** already exists, **amend it**
  (bump a count / update the timestamp) rather than posting a new message;
- post a **new** message only when the condition is **substantially different** (a different job, or the
  same job failing for a materially different reason).

Define "substantially different" concretely in the implementation (e.g. key on `job-base` +
a normalized failure signature); document the chosen key. The goal: the 37-identical-messages case
collapses to a single, updated notice.

## Integration points to check (verify before editing; do not assume paths)

- The reaper: `scripts/jobs/reaper.sh` (and any `scripts/jobs/handlers/` it calls) — where the 5-cycle
  requeue budget is enforced and the current POISON message is posted.
- The maintainer-message helper the reaper uses to post to `journal/inbox/maintainer/` — extend it (or
  add a sibling) with an amend-or-post-keyed mode.
- The plan-parking primitive `scripts/jobs/post-plan.sh` and the board contract
  (`journal/jobs/README.md`) — reuse, do not fork.
- Confirm the `garden-unblock` / foreman promotion path will NOT auto-run a parked poisoned plan (it must
  stay held until a human or a cleared blocker promotes it).

## Definition of done

The reaper, on exhausting a job's requeue budget: (a) parks the job in `jobs/plan/` under a
deterministic, held gate with poison provenance, and (b) amends an existing keyed maintainer notice for
the same job/condition, posting a fresh message only when the condition is substantially different.
Include a focused test or a documented manual repro (simulate a job poisoning twice → one parked plan
entry, one amended message, not two of each) with cited output per `garden/roles/COMMON.md` § Reporting.
Land on `main2` from an isolated worktree; journal a `result` entry.

## Follow-up note

The reaper already sent 5 infra POISON reports this cycle that the `investigate-poisoned-garden-infra-jobs`
job is handling; this change prevents the next such flood.
