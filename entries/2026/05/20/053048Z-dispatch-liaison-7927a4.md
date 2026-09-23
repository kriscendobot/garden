---
ts: 2026-05-20T05:30:48Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: groom
---

# Dispatch: groom does a full pass on designs/README.md — milestones, roadmap summary, dep graph

Dispatch root: `dispatches/groom--7927a4/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-20): *"Please add or update the milestones and roadmap summary on designs/README.md."*

## Why now

The designs/ tree has accumulated material since the last grooming pass, including (today alone):

- `designs/forge-gap-analysis.md` (just synced to README by designer 50e490 — PR #310, exploratory analysis design).
- `designs/patterns-diagnostic-feedback.md` (PR #307, three-axis split A/B/C — designer 3f4694).
- `designs/familiar-release.md` (PR #231 round-two pass — fixer + maintainer review iteration).
- `designs/chat-rename-dismiss-to-clear.md` flipped to **Complete** (PR #299).
- Various other recent landings (designer 8c11f7, designer f47931, builder 4a8df9's gap report, etc.) per recent bulletin rows.

The maintainer wants the **milestones and roadmap summary portion** of `designs/README.md` refreshed to reflect the current state — milestone totals, completion rates, velocity, and the Summary-table / Mermaid-Gantt / Progress-as-of-line that callers use to read the roadmap.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/groom/AGENT.md` first. Then read `designs/CLAUDE.md` from the project worktree (it carries the README's structural conventions). Then **read `designs/README.md` end-to-end** so you have the current shape in head before editing.

Then **run a full grooming pass** per `roles/groom/AGENT.md` § Sub-modes (the "Full grooming pass" option). The four-skill procedure:

1. **velocity-recalibration** (`skills/velocity-recalibration/SKILL.md`): observe completion durations since the last snapshot, recompute size buckets (S / M / L / XL) if the empirical durations have drifted, and update the velocity reference points the roadmap projection uses.
2. **roadmap-projection** (`skills/roadmap-projection/SKILL.md`): recompute Summary by Milestone (per-milestone counts of designs in each status), regenerate the Mermaid Gantt, and update the trailing "Progress as of YYYY-MM-DD" line. The maintainer's directive specifically names "milestones and roadmap summary"; this is the load-bearing step.
3. **dependency-graph-maintenance** (`skills/dependency-graph-maintenance/SKILL.md`): reconcile design files' edges against the README's dependency graph; surface any cycles introduced since the last pass.
4. **groom-open-questions** (`skills/groom-open-questions/SKILL.md`): append open-questions and answers as appropriate. May land as a separate journal `message` entry tagged `project: endo-but-for-bots` per the role's preference for this garden (process-documents-equivalent), rather than baking into the README.

If a sub-mode is empty (nothing to recalibrate, no dep cycles, no open questions), say so in the report rather than padding the work.

## Shape of the edit

The maintainer specifically asked for the **milestones and roadmap summary** — that's the Summary-by-Milestone table + the Mermaid Gantt + the Progress-as-of line. Treat the rest of the procedure (velocity recalibration, dep graph, open questions) as load-bearing context for those three but secondary outputs.

- The Summary-table milestone totals should reconcile with the **current count of design rows** in the README's main Summary table; mismatches are the most common surface-bug.
- The Mermaid Gantt should reflect any **status flips since the last snapshot** (e.g., `chat-rename-dismiss-to-clear` is now Complete, not In Progress).
- The "Progress as of" line should match today (2026-05-20).
- If you find new designs the README has not yet absorbed (the designer's earlier sync may have missed something), add the missing rows in the same pass.

## Commit shape

- One commit for the `designs/README.md` edit. Subject `docs(designs): groom roadmap — milestones + summary refresh (Progress as of 2026-05-20)`.
- Zero or one *journal* `message` entry for open-questions / observations the README is not the right home for. Don't open a separate process-docs commit; this garden routes those through the journal.

## PR shape

Open as **DRAFT** PR against `endojs/endo-but-for-bots@llm`. Branch: `groom/roadmap-2026-05-20`. Title: `docs(designs): groom roadmap (milestones + summary, 2026-05-20)`. Body cites the maintainer directive, lists the load-bearing deltas (status flips, milestone-total changes, new rows added, dep-graph cycles surfaced if any), and asks the maintainer to weigh in on any open questions before un-draft.

## Per-action authorization

Standing on endo-but-for-bots: push to `groom/roadmap-2026-05-20`, open draft PR. READ-ONLY on `endojs/endo` and elsewhere. Comment authority limited to the new PR's body.

## Out of scope

- No edits to the individual design files (`designs/foo.md`) except to fix obvious roadmap-summary discrepancies (e.g., a Status field that contradicts its row in the README — flag in the report rather than silent-fixing if uncertain).
- No implementation work.
- No un-draft of the PR — leave for the maintainer.
- No retro of older grooming snapshots; this is the next snapshot, not a redo.

## Report

≤ 400 words: PR URL + head SHA, the per-milestone totals (before → after), status flips since the prior snapshot, new rows added to README in this pass, dep-graph cycles surfaced (or "none"), open-questions count, the load-bearing recalibration deltas if any (e.g., "S bucket median dropped from 1.2 days → 0.8 days based on 7 observations since 2026-05-10"), one-line `Self-improvement: ...`.
