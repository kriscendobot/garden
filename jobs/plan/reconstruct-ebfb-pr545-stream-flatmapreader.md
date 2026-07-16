---
gate: orchestrated
orchestrated_by: reconstruct-ebfb-master-merged-prs
priority: normal
posted_by: producer
posted_at: 2026-07-16T23:00:41Z
---

---
role: builder
---
# Reconstruct endo-but-for-bots#545 (stream: add flatMapReader)

Reconstruct the **errantly-master-merged** PR endojs/endo-but-for-bots#545
("feat(stream): add flatMapReader for 1-to-many reader transforms", `@endo/stream`) as a fresh
DRAFT PR, **base `master`**.

- The head branch was deleted — **recover the diff from the merge commit `364d69ba1`**
  (`git show 364d69ba1`), apply onto a new branch off current `master`.
- No upstream `endojs/endo` PR exists (the body's `#486` is intra-fork) — invisible upstream.

## How to reconstruct
- Work in an ISOLATED worktree keyed by YOUR job base:
  `scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots <base-branch>`.
- Recover the change **faithfully** — do not re-derive or "improve" it. Verify the
  reconstructed diff matches the original merge's diff (`git show <merge-sha>`); note any
  unavoidable adaptation (e.g. a rebase conflict resolution) in the PR body.
- New branch `reconstruct/ebfb-pr<NN>-<slug>`; open a **DRAFT** PR.
- The PR body MUST explain the provenance: "Reconstructs endojs/endo-but-for-bots#<NN>,
  which was **errantly merged to `master`** — a `master`-based (upstream-destined) change
  should have been *closed* once its upstream `endojs/endo` equivalent merged (or closed
  explicitly), not merged into the fork's `master`. Fork `master` periodically hard-re-mirrors
  from upstream and silently drops fork merge-commits, so this change is on borrowed time and
  invisible upstream. Reopened here (as a fresh PR, since GitHub cannot reopen a merged PR) to
  surface it for maintainer attention — to ferry upstream to `endojs/endo` or close." Link the
  original PR and its merge commit.
- Fully-qualify all issue/PR references; ASCII prose (house style). Keep it DRAFT.

## Done
A fresh DRAFT PR carrying the reconstructed diff, base as stated, with the provenance
body above, linked to the original PR + merge commit. The `tada` report links the new PR
and confirms the reconstructed diff matches the original.
