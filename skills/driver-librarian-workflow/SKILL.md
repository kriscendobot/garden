---
created: 2026-06-04
updated: 2026-06-04
author: gardener
---

# Skill: driver-librarian-workflow

The librarian lane's state machine. A librarian lane is an autonomous driver bound to the `librarian` role: it claims jobs from `journal/jobs/librarian/open/`, drains messages from `journal/inboxes/<host>/librarian.md`, and runs library-curation engagements (ingest, prune, shortcut, audit). The interactive `librarian` posture (the one the maintainer enters in their `claude` session) continues to operate in parallel; the two coordinate via the shared journal and the lane's `paused:` flag, identically to the gardener lane's coordination shape.

The workflow has more states than the gardener's because library work has well-defined phases (ingest is multi-step; an audit walks the full corpus); the lane is otherwise the same shape as the gardener lane.

## States

- `[idle]` — no in-flight work. Sleep until the next cadence tick or an event surfaces.
- `[draining-inbox]` — pulling addressed-to-`librarian` entries via `skills/inbox-drain/inbox-drain.sh librarian`. The drain emits researcher *Open questions* output, scholar-routed ingest requests, and direct maintainer asks.
- `[scanning-board]` — listing `journal/jobs/librarian/open/`. Eligible jobs match `eligible_roles: [librarian]` or `eligible_roles: ["*"]`.
- `[classifying]` — for each emitted message or scanned job, the lane decides the engagement shape:
  - **ingest-source**: a new source document (a paper, an RFC, a design doc) needs sections, a source page, and concept-page threading. The shape is the canonical library-ingest engagement.
  - **grow-shortcut**: a researcher's *Library writeback* notes a term that should be in `journal/library/keywords.md` but is not. The shape is a small keyword-index addition.
  - **prune-concept**: a concept page accumulated distractions (section files cited that are no longer the canonical answer for the concept). The shape is a focused edit.
  - **draft-missing-concept**: a load-bearing term appears repeatedly in source-page citations but has no concept page. The shape drafts a new concept page and re-threads existing citations.
  - **library-audit**: a structural audit (e.g., every source page's sections still exist; every keyword entry's concept page is non-empty). The shape is a sweep; its budget is larger than the per-engagement default.
- `[engaging]` — the lane invokes a librarian subagent with the engagement brief. The subagent reads `roles/COMMON.md`, `roles/librarian/AGENT.md`, the engagement-specific skill, and any source material the engagement names, then commits library edits to `journal/` and returns.
- `[reporting]` — the lane writes a `result: librarian` entry naming the engagement, the affected paths under `journal/library/`, and the cycle of source-ingest if applicable. The result entry ends with `Self-improvement: ...` per the standing skill.
- `[idle]` — return to the top.

## Transition predicates

Identical in shape to the gardener lane's:

- `[idle] → [draining-inbox]` on every cadence tick.
- `[draining-inbox] → [scanning-board]` after the drain returns.
- `[scanning-board] → [classifying]` when either surface yielded eligible work.
- `[scanning-board] → [idle]` when both surfaces returned nothing.
- `[classifying] → [engaging]` when the classified shape names a librarian-handleable engagement.
- `[classifying] → [idle]` when the surfaced item is not librarian-actionable.
- `[classifying] → [routed-forward]` when the classified shape names work that warrants a different role's engagement (e.g., a researcher's *Open question* that turns out to be a `gardener-task` proposed-rule rather than a library gap; the lane posts the job and returns).
- `[engaging] → [reporting]` on successful engagement.
- `[engaging] → [parked]` on impasse.
- `[reporting] → [idle]` after the result entry commits.

## Cadence

The librarian lane's default cadence is **300 seconds** (5 minutes). Library work is slow-changing; source-page ingest is the dominant load and arrives on the librarian inbox / job board rather than from external poll signals. A maintainer engagement that wants faster response edits the lane's state file to bump `cadence_seconds`.

The inbox-drain script's commit-on-emit discipline means quiet ticks produce zero commits. A librarian lane with no inbox traffic and no job-board postings is silent at the cadence's resolution.

## Coordination with the interactive librarian

Identical to the gardener-lane coordination shape:

1. **Pause via `paused: true`** on `journal/drivers/<host>/librarian-N.md` for substantive in-session engagements.
2. **Race on the inbox** for low-traffic periods; first to push wins.

The maintainer's standing practice is to pause the lane during in-session library-audit engagements (since those touch many concept pages and the race-cost is higher than the typical inbox-drain).

## Engagement budget

Per-engagement budget is **two to ten minutes wall time** by default, longer than the gardener's because ingest is multi-step (section files, source page, topic threading, keyword shortcuts). The exception is a `library-audit` engagement whose budget is *one hour wall time*; that engagement is bounded by an explicit checkpoint discipline (the audit commits intermediate state every ten minutes so a crash does not lose progress). The audit shape is the only one with this exception; everything else stays under the ten-minute soft cap.

Engagements exceeding the budget surface as *routed-forward* with `to: liaison` and a one-line rationale, the same shape as the gardener lane's overflow handling.

## Composition with neighbouring skills

- [`skills/inbox-drain/SKILL.md`](../inbox-drain/SKILL.md) — the inbox surface the lane drains every tick.
- [`skills/job-board/SKILL.md`](../job-board/SKILL.md) — the job-board surface the lane scans every tick.
- [`skills/library-lookup/SKILL.md`](../library-lookup/SKILL.md) — the canonical library-walk procedure; the lane invokes it during `ingest-source` and `draft-missing-concept` engagements.
- [`skills/context-library/SKILL.md`](../context-library/SKILL.md) — the agent-optimized hierarchical documentation conventions every library edit follows.
- [`skills/journal-sync/SKILL.md`](../journal-sync/SKILL.md) — the journal commit / push primitive.

## Notes

- **Lane cap.** The librarian role's initial per-host cap is **two** lanes (one primary, one for parallel walks during catch-up). The cap can grow as the library's ingest rate justifies it. The daemons-script's lane registry encodes the cap; growing it is a config edit.
- **Cross-host coordination.** Concurrent librarian lanes on different hosts share `journal/library/` and the journal branch; the first to push a curation edit wins, and the second's next tick re-reads the now-canonical state.
- **No `main` branch writes.** Unlike the gardener, the librarian operates entirely in `journal/`. The role does not write to `roles/`, `skills/`, or top-level docs on `main`. The two roles' authority bounds are disjoint, which is why the lane caps and coordination shapes are independent.

## Notes from the field

- _2026-06-04_: workflow landed by gardener alongside the gardener-lane workflow per the maintainer's 2026-06-04 directive. The skill is the lane's contract; the driver-script extension to load this workflow on a `librarian-N` lane lands in a separate builder dispatch.
