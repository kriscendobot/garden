---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
CRITICAL: the host's filesystem hit 0 free inodes today (244,121,600 /
244,121,600 used) — not byte-space (756G free), pure inode exhaustion.
This broke git operations fleet-wide (partial/corrupted checkouts in
producer clones, matching the class of corruption that hit the root repo
a few days ago) and is why the fleet is currently DRAINED
(scripts/jobs/drain-fleet.sh on, reason recorded 2026-08-28). Emergency
relief already taken: cleared `.npm` cache (~30K inodes) and deleted the
stale `.garden-state/foreman/journal` clone, which had accumulated 2,675
loose git packs (~45K inodes) — both self-healing/regenerable, zero data
loss. Current headroom: ~75K free inodes, razor-thin against 244M total.
This is a stopgap, not a fix.

**Root cause, confirmed by sampling:** accumulated, never-cleaned per-job
worktrees under `worktrees/<owner>-<repo>/<job>/` and `scratch/`, each
carrying a full `node_modules` install (40,000-112,000 files apiece,
observed directly). 32 worktrees for `endojs-endo-but-for-bots` alone;
239 directories under `scratch/`. Multiplied across every repo the fleet
touches over months, this is the dominant inode consumer — worktrees are
created per WORKTREES.md's lifecycle but evidently never pruned after
their job completes.

**Ask:**
1. Systematically sweep `worktrees/*/*/` and `scratch/*` for directories
   whose owning job is DONE (in `jobs/tada/`) and whose associated PR is
   merged or closed — confirm each candidate against live GitHub state
   before deleting, the same care `groom-parked-job-queue-20260822`
   (job-board pruning) used for board entries, applied here to worktrees.
   Never delete a worktree for a job still in plan/todo/doin, or one
   whose PR is still open (even if merged locally, an open PR might still
   be actively reviewed/rebased there).
2. Since the fleet is drained, no new claims are racing you, but existing
   `doin/` jobs may still be running to completion — check for an active
   claim/lock on a worktree before removing it regardless of what its job
   status looked like a moment ago.
3. Quantify what you actually reclaimed (`df -i /` before/after) and
   report it plainly.
4. Recommend whether this needs to become a STANDING practice (a
   scheduled sweep, or a worktree-teardown step added to job completion
   itself — `complete-job.sh` or similar) rather than a one-time cleanup,
   given it clearly wasn't happening at all until it caused an outage.
5. Do NOT lift the fleet drain yourself — report readiness and let the
   maintainer/liaison decide when to lift it (scripts/jobs/drain-fleet.sh
   off).

Work carefully given the current inode scarcity — verify before batch
deleting, and prefer deleting the biggest/most-clearly-safe candidates
first to build headroom incrementally rather than attempting one giant
sweep that itself might fail partway through for lack of inodes to even
run `find`/`git` commands.
