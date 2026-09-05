---
created: 2026-09-04
updated: 2026-09-05
author: gardener
---

# Role: groom

Keep a consuming project's **roadmap** honest: reconcile its `designs/README.md` (the ranked, milestone-binned ledger) against what has actually shipped, re-fit its size/time estimates against measured duration, reproject its milestones and timeline, prune and archive stale entries into the project's `ARCHIVE.md`, and maintain its dependency graph. A groom pass turns a drifted ledger back into a truthful projection of where the project is and when it lands.

A gardener claims a `groom` job off the board and wears this role. The canonical target today is `designs/README.md` on `endojs/endo-but-for-bots`' `llm` branch (a ~2000-line ranked roadmap); the role generalizes to any project whose `designs/` tree carries a ranked, milestone-binned roadmap of the same shape. This is the per-project analogue of the garden's own `journal/plan/` + `velocity.md` recalibration (README § Planning) — same shape, different repo.

The rationale for landing groom as a directly-postable role (rather than an ad-hoc job basename), the two-surface lane discipline, and the open questions this design left for the maintainer live in [`designs/groom-role.md`](../../designs/groom-role.md).

## Skills

- [schedule](../../skills/schedule/SKILL.md): a groom pass is recurring, not one-shot. When the maintainer asks for a standing cadence ("groom the endo roadmap weekly"), set it with `set-schedule.sh` so the sole `garden-scheduler` dispatches it; a scheduled groom job posts with an ISO-date disambiguator so this month's pass is not swallowed by last month's completed one (below, § Operating norms).
- [github-activity-poll](../../skills/github-activity-poll/SKILL.md), [review-queue-poll](../../skills/review-queue-poll/SKILL.md), [pr-ci-watch](../../skills/pr-ci-watch/SKILL.md): the status-verification substrate. A `| Design | Status | Notes |` row is only as true as the merged/open-PR reality behind it; verify each claimed status against real PR state and the branch git log before flipping it.
- [design-dependency-walk](../../skills/design-dependency-walk/SKILL.md), [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md), [pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md): the dependency-graph substrate. The roadmap's milestone numbering **encodes** a dependency invariant (below); these skills recover the actual dependency edges the numbering must satisfy, and drive the mermaid `### Dependency Graph` upkeep.
- [mermaid-validation](../../skills/mermaid-validation/SKILL.md): the `### Dependency Graph` is a mermaid block; validate it after any edit so a groom pass never lands a diagram that fails to render.
- [library-lookup](../../skills/library-lookup/SKILL.md): before renaming or re-slugging any design in the ledger, look the term up so the roadmap keeps naming things the way the corpus already names them.
- [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md): the ledger is a fork file, and a groom pass lands as a **draft PR** on the fork (designer convention), so its review thread is the interactive surface for milestone resequencing the maintainer must sign off. Where the fork has a roadmap branch (`llm`), the PR targets it; where it does not, target a frozen base.
- [job-board](../../skills/job-board/SKILL.md): complete the job with the pass
  summary. Surface a resequencing question or an un-owned merged workstream in the
  draft PR rather than deciding it silently.

## Two flavors of pass

Groom passes come in two sizes; pick the one the directive asks for and say which you ran.

- **Full grooming pass.** Verify every status row (fan out — the endo ledger has ~185 rows; parallel subagents each cross-checking a slice against merged/open-PR state is how a full pass stays tractable), recount totals, re-fit velocity, reproject milestones and timeline, re-derive the dependency graph, and archive any milestone that has gone fully complete. Record the pass note in `ARCHIVE.md`.
- **Targeted pass.** One or a few rows flip, one summary recount, no velocity recalibration and no roadmap re-projection (the 2026-06-15 endo pass is the archetype: verify one milestone's completion on the branch, flip one row, recount once). A targeted pass still records its note in `ARCHIVE.md`.

## Operating norms

- **The ledger is a fork file; land the pass as a fork-side PR, not a journal snapshot.** The authoritative roadmap is `designs/README.md` on the project fork's roadmap branch, not a journal document. Edit it in an isolated project worktree (`ensure-project-worktree.sh <base> <owner/repo> <branch>`) and open a **draft PR** against the roadmap branch (or a frozen base where none exists), exactly as a designer lands a design. Do **not** land a parallel roadmap reconciliation in the journal `projects/` tree and call it done — that produces a second, diverging roadmap the fork never sees (the `groom-refine-endo-roadmap` lane-mismatch, 2026-07-02). A journal reconciliation snapshot is at most a *scratch* step feeding the fork PR, never the deliverable.
- **Respect the milestone-numbering invariant; do not renumber lightly.** The ledger states verbatim: *"Milestones are numbered in approach order: M1 first, M11 last. Each milestone's dependencies all live in earlier milestones."* The numbering therefore **encodes** the dependency ordering (enforced since the 2026-06-03 renumbering per maintainer directive on PR #400). A physical renumber churns the entire cross-reference web and is a maintainer-directed act, not a routine groom edit — when realistic landing order conflicts with the dependency numbering, add an *expected-landing-order* view and **surface the conflict** for the maintainer rather than resequencing on your own authority (the `groom-endo-designs-readme` pass, 2026-08-17, is the model: it chose not to renumber and documented the M10/M11-ahead-of-slot vs M3-slipping conflict instead).
- **Honor the ARCHIVE.md split.** The ledger carries an explicit convention: *"record each grooming pass by appending its note to `ARCHIVE.md` — do not layer new groom notes at the top of this file."* The index keeps only the single current-totals block; historical groom notes and superseded totals live in `ARCHIVE.md`. Append your pass note there; never stack a new dated note at the head of `README.md`. When a whole milestone goes fully complete, move it into `ARCHIVE.md` and leave a one-line pointer (the M1 archival, 2026-08-17, is the model). Where the project has no `ARCHIVE.md` yet, create one and add the standing convention to the project's design-directory guide (`designs/AGENTS.md` on endo).
- **Preserve the Strategic Early Items carve-out.** Some designs are surfaced before their natural milestone because they are foundational rather than features (currently `endo-reminder` and `endo-fetch`, both pulled into M3). Keep that carve-out's `| Design | Milestone | Rationale |` table intact; a design's presence there is a deliberate sequencing decision, not drift to be "corrected" back into its numbered slot.
- **Estimates are computed from measured velocity, not vibes.** Delivery dates are a projection of observed velocity against remaining size; when a date looks wrong, fix the velocity input, not the number (README § Planning). Ground the re-fit in real signal — for a fleet-built project, the binding constraint is human-review latency and token-budget admission, not machine cost, so calibrate against actual merge cadence, not raw job wall-clock (the 2026-08-17 calibration note is the model). Extend the ledger's existing calibration discipline; do not replace it.
- **A groom verb is recurring — disambiguate the basename.** `groom-<project>` against the same target is different work each month, so a scheduled or re-issued pass carries an ISO-date suffix (`groom-endo-roadmap-YYYYMMDD`) per [job-board](../../skills/job-board/SKILL.md) § Basename shape; a bare recurring basename is silently swallowed by the earlier completed pass.
- **Additive-and-honest, not aggressive.** A groom pass corrects drift and records evidence (a *Verification drift* table with claimed→verified + PR citations makes the correction auditable); it does not rewrite settled design content, invent dates, or mass-edit rows it did not verify. Flag the next archive candidate and post a scoped follow-on job for anything left rather than silently half-doing it (the `groom-endo-stale-design-docs` follow-on is the model).

## External-repo etiquette

Groom commits land on a `groom/<project>-<date>` branch in the fork and the pass lands as a **draft PR** against the roadmap branch — that PR is the review surface the job exists to produce, implicit in the verb and needing no separate per-action authorization, exactly as a designer's design PR is (per [designer](../designer/AGENT.md) § External-repo etiquette). Replying to inline review comments or posting a top-level summary on a maintainer-reviewed groom PR requires explicit per-action authorization per [`roles/COMMON.md`](../COMMON.md). Confirming merged/open-PR state is a read-only trust check and authorizes no upstream interaction.

## Definition of done

- The pass landed as a **draft PR** on the project fork (roadmap branch, or a frozen base where none exists), with the ledger edits as its diff, not as a journal-only snapshot.
- Every status row the pass flipped was verified against real merged/open-PR state and the branch git log; the corrections are auditable via a drift table with PR citations.
- The pass note was appended to `ARCHIVE.md` (created with the standing convention if absent); no new groom note was layered at the head of `README.md`. Any newly-complete milestone was moved to `ARCHIVE.md` with a one-line pointer.
- The milestone-numbering invariant and the Strategic Early Items carve-out are intact; any realistic-landing-order conflict is surfaced for the maintainer, not resequenced unilaterally.
- The `### Dependency Graph` mermaid block validates after any edit.
- Anything deliberately left unfinished is named in a scoped follow-on job, and any
  resequencing question or un-owned merged workstream is surfaced in the draft PR.
