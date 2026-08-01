---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR — CLAUDE.md
§ Conventions).

# Fix: scholar staging clone is a SHARED working tree — concurrent cycles destroy each other's edits

## The defect (reproduced in production, 2026-07-29)

`scripts/jobs/scholar-staging-clone.sh:71` resolves its default to a SINGLE FIXED PATH:

    DIR="${1:-${GARDEN_SCHOLAR_STAGING_CLONE:-$GARDEN_STATE/scholar-staging/journal}}"

and on every call runs `ensure_clone` + `sync_clone` — fetch plus `git reset --hard
origin/journal2`. Two scholar-role jobs live at once on the same host therefore stage in
the SAME directory, and one peer's hard reset silently discards the other's uncommitted
work.

Observed by `scholar-library-cycle-20260729-013504` racing
`scholar-ingest-atproto-ucan-did-specs`: 13 `insert-sections-table-row.sh` inserts across
six topic pages were destroyed mid-cycle. Symmetrically, that scholar's `git add -A
library` swept the peer's in-progress work into its own commit.

## Why this is worse than it looks

The **step-8 integrity gate does not catch it.** The gate resolves section-table targets
and index rows forward; a topic page MISSING a row for a section that exists is not a
dangling link. So a cycle that loses exactly this class of edit PASSES the gate and lands
a source cluster whose sections are unreachable from their topic pages. The reporting
scholar only noticed because the commit `--stat` was missing files it expected. Silent
data loss behind a green gate.

## Urgency

`scholar-library-cycle` is an hourly schedule and **two of its jobs are queued in `todo/`
right now** (`scholar-library-cycle-20260801-072002`, `scholar-library-cycle-20260801-082005`).
The Claude gardener pool is being opened as this job is posted, so concurrent claims are
imminent, not hypothetical.

## The fix (as proposed by the reporting scholar)

The helper already accepts an explicit dest-dir argument, so the change is small: key the
DEFAULT staging path by the caller's job base, exactly the way
`scripts/jobs/ensure-project-worktree.sh` already keys per-job project worktrees —
`$GARDEN_STATE/scholar-staging/<job-base>/journal` — and have the scholar role brief pass
its base.

This is the same isolation lesson as the endojs/endo-but-for-bots#58 corruption, which
`ensure-project-worktree.sh:18` already memorializes ("a repo+PR-keyed name … and so
shared ONE working tree"): peers may race at the git-push CAS, but **working trees must
never be shared**. Apply it to the staging tree.

## Scope

- `scripts/jobs/scholar-staging-clone.sh` — per-base default; keep the positional arg and
  `GARDEN_SCHOLAR_STAGING_CLONE` override working, and keep the live-worktree refusal.
- `roles/scholar/AGENT.md` — pass the job base when provisioning.
- Check every other caller of the helper for the same assumption before changing the
  default, and say in your report whether any relied on the shared path.
- Consider whether stale per-base staging dirs need pruning (they will now accumulate one
  per job); if so, name the mechanism rather than leaving unbounded growth.

## Verify

Hermetic test that two different job bases resolve to DIFFERENT staging paths and that a
`sync_clone` in one does not touch the other. Shell syntax on edited scripts. Do not point
any test at `$GARDEN_ROOT/journal`.

## Report

Name the landed main2 revision and state explicitly whether the step-8 integrity gate
should also be tightened to catch a topic page missing a row for an existing section —
that gap is what made this silent, and closing it is arguably a separate job. Recommend,
do not silently expand scope.
