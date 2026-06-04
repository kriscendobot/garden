---
created: 2026-06-04
updated: 2026-06-04
author: gardener
---

# Skill: driver-gardener-workflow

The gardener lane's state machine. A gardener lane is a single-instance per-host autonomous driver bound to the `gardener` role: it claims jobs from `journal/jobs/gardener/open/`, drains messages from `journal/inboxes/<host>/gardener.md`, and runs the engagement to completion. The interactive `gardener` posture (the one the maintainer enters in their `claude` session) continues to operate in parallel; the two coordinate via the shared journal and the lane's `paused:` flag.

The workflow is much simpler than the PR-creation flow: there is no chain to advance, no panel to dispatch, no CI to drive to green. The lane wakes, finds work or doesn't, runs it, and idles. Most of the complexity is in the engagement itself, which is the gardener subagent's job rather than the workflow's.

## States

- `[idle]` — no in-flight work. Sleep until the next cadence tick or an event surfaces (a watcher-routed inbox notification, a job-board poll surfacing a new job).
- `[draining-inbox]` — pulling addressed-to-`gardener` entries via `skills/inbox-drain/inbox-drain.sh gardener`. Each emitted line names a journal entry that potentially requires action.
- `[scanning-board]` — listing `journal/jobs/gardener/open/`. Eligible jobs match `eligible_roles: [gardener]` or `eligible_roles: ["*"]`.
- `[classifying]` — for each emitted message or scanned job, the lane decides whether the item is gardener-actionable and what *engagement shape* it requires. Five engagement shapes are recognized:
  - **encode-proposed-rule**: a panel `[proposed-rule]` note forwarded by a judge or a barrister's cite-or-propose discipline. The shape is well-defined; the engagement runs to a small skill / role edit.
  - **library-gap**: a researcher's *Open questions* output names a load-bearing term absent from `journal/library/keywords.md`. The shape routes either to a self-handled gardener engagement (when the gap is small and inside garden-meta) or to a `librarian-task` job posted forward.
  - **role-file-scrub**: a returning subagent reports stale references in a role or skill file (a deleted role still cited, a renamed skill still linked). The shape runs a focused edit.
  - **inventory-drift**: `CLAUDE.md` § Current inventory has drifted from the actual `roles/` and `skills/` directories. The shape reconciles.
  - **routine-meta-edit**: any other small role / skill / top-level edit the maintainer or a subagent has flagged. The shape runs the edit and surfaces.
- `[engaging]` — the lane invokes a gardener subagent with the engagement brief. The subagent reads `roles/COMMON.md`, `roles/gardener/AGENT.md`, and the engagement's specific skill (e.g., `skills/self-improvement/SKILL.md` for proposed-rule encodings), then runs the edit, commits to `main`, pushes, and returns.
- `[reporting]` — the lane writes a `result: gardener` entry naming the engagement, the commit SHA, and the affected files. The result entry ends with `Self-improvement: ...` per the standing skill.
- `[idle]` — return to the top, sleep until the next tick.

## Transition predicates

- `[idle] → [draining-inbox]` on every cadence tick (regardless of whether the inbox has new lines).
- `[draining-inbox] → [scanning-board]` after the drain returns (empty or not).
- `[scanning-board] → [classifying]` when either the drain emitted lines or the board scan found eligible jobs.
- `[scanning-board] → [idle]` when both surfaces returned nothing.
- `[classifying] → [engaging]` when the classified shape names a gardener-handleable engagement.
- `[classifying] → [idle]` when the surfaced item is not gardener-actionable (informational broadcast, FYI, message addressed to another role that incidentally hit the gardener inbox). The lane does not re-emit; the item drains as a no-op.
- `[classifying] → [routed-forward]` when the classified shape names a different role's work (e.g., a library-gap that warrants a `librarian-task` post). The lane posts the job, writes a routing message, and returns to `[idle]`.
- `[engaging] → [reporting]` when the gardener subagent returns successfully.
- `[engaging] → [parked]` when the subagent returns an impasse the lane cannot resolve. The parked engagement surfaces to the maintainer via a gardener-inbox message and the lane returns to `[idle]` after writing the park record.
- `[reporting] → [idle]` after the result entry commits.

## Inbox-drain pace

The gardener lane runs `inbox-drain.sh gardener` on every cadence tick. The cost is one `git fetch` plus a path-filtered diff; the lane's default cadence is 180 seconds. A maintainer engagement that wants faster response edits `journal/drivers/<host>/gardener-1.md` to bump `cadence_seconds: 60` (or lower); the next tick respects it.

The inbox-drain script's commit-on-emit discipline (per `skills/inbox-drain/SKILL.md` § Pitfalls) means the drain does not produce a journal commit on quiet ticks. A gardener lane with no inbox traffic and no job-board postings produces zero commits per cadence tick.

## Coordination with the interactive gardener

When the maintainer enters the `gardener` posture in their `claude` session and the autonomous `gardener-1` lane is running, the two share the inbox and the journal. Two coordination shapes work:

1. **The maintainer pauses the lane** by setting `paused: true` on `journal/drivers/<host>/gardener-1.md`. The lane's tick body short-circuits on the flag without exiting; the systemd service stays up but does nothing until the flag clears. This is the recommended shape for substantive in-session engagements where the maintainer wants exclusive ownership.
2. **Both stay active** and race on the inbox. The autonomous lane drains per its cadence; the interactive session drains on its own pace. The first to commit a `result` entry to `origin/journal` claims the engagement; the second sees the commit and stands down. This is fine for low-traffic periods but produces wasted setup on contention.

The maintainer's standing practice is to pause the lane before starting a substantive in-session gardener engagement, and clear the flag when done. The lane's state file's `paused_at:` timestamp records the most recent pause for the audit trail.

## Engagement budget

The lane's gardener subagent has a soft budget of **one to five minutes wall time per engagement**. Engagements that fan out wider (a multi-file refactor touching ten role files, a library audit across fifty concept pages) are out of scope for the lane and should be routed to an interactive gardener engagement via a maintainer message. The lane's classifier surfaces such items as *routed-forward* with `to: liaison` and a one-line "this exceeds the lane's budget; needs interactive engagement" rationale.

## Composition with neighbouring skills

- [`skills/inbox-drain/SKILL.md`](../inbox-drain/SKILL.md) — the inbox surface the lane drains every tick.
- [`skills/job-board/SKILL.md`](../job-board/SKILL.md) — the job-board surface the lane scans every tick.
- [`skills/self-improvement/SKILL.md`](../self-improvement/SKILL.md) — the canonical threshold-rule reference for *encode-proposed-rule* engagements.
- [`skills/journal-sync/SKILL.md`](../journal-sync/SKILL.md) — the journal commit / push primitive for the `result` entry.
- [`skills/prompt-on-failure-capture/SKILL.md`](../prompt-on-failure-capture/SKILL.md) — the lane's capture pattern when an engagement fails; the parked engagement's surface to the maintainer carries the capture SHA.

## Notes

- **Why single-instance per host.** The gardener writes to `roles/`, `skills/`, and top-level docs on `main`. Two concurrent gardener lanes would race on the same file edits; the contention recovery would land conflicting commits or lose one engagement's work. The daemons-script's lane registry enforces the cap; an attempt to launch `gardener-2` is refused.
- **Cross-host coordination.** Two gardener lanes on different hosts share the same `main` branch and the same `journal/`. The first to push a result entry claims the engagement; the second's drain sees the commit and stands down. The `inbox-drain.sh gardener` mechanism's state file commits-and-pushes per `skills/inbox-drain/SKILL.md` post-2026-06-02 so concurrent drains converge on the same `last_drained_commit` value.

## Notes from the field

- _2026-06-04_: workflow landed by gardener after the maintainer's 2026-06-04 directive *"add one lane for a gardener and one lane for a librarian. These should have an adjustable pace and respond to messages. We can continue to have one-off versions of these in interactive mode, but always one ready to respond, to receive messages from other lanes, and to be dispatched from a steward."* The skill is the lane's contract; the actual driver-script extension to parse the role prefix and load this workflow lands in a separate builder dispatch (parallel to the design-poller daemon dispatch).
