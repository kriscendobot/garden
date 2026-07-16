---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T23:01:03Z -->

---
role: builder
---
# Reconstruct endo-but-for-bots#69 (pass-style: treat document.all-like values as objects)

Reconstruct the **errantly-master-merged** PR endojs/endo-but-for-bots#69
("fix(pass-style): treat document.all-like values as objects") as a fresh DRAFT PR,
**base `master`**.

- **Easiest case — the head branch still exists**: `design/issue-3156-pass-style-document-all`.
  Prefer opening the fresh PR directly from that branch to `master` (rebase it onto current
  `master` first if it has drifted). If the branch is unusable, recover the diff from the
  merge commit `eecc68394`.
- Upstream tracking: `endojs/endo` **issue #3156 is OPEN** and there is **no upstream endo PR**
  yet — this change is invisible upstream, which is why it must resurface.

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

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-16T23:01:06Z
