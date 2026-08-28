---
gate: deferred
priority: high
posted_by: producer
posted_at: 2026-08-28T14:18:40Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Root cause of the 2026-08-28 host inode-exhaustion outage (0 free inodes,
244M/244M) was that per-job worktrees are created keyed by job base but
NEVER torn down on completion. Confirmed in code: `complete-job.sh` has no
worktree-removal step; `ensure-project-worktree.sh` is deterministic-recreate
(intentional, so a reaper requeue resumes in place), and the reaper only
resets/increments doom counters. Every project worktree (each ~130K files
incl. node_modules) accumulates forever. A one-time manual sweep
(fix-worktree-scratch-inode-exhaustion-20260828) reclaimed ~719K inodes from
legacy orphans, but this must become a STANDING practice.

Implement BOTH, carefully:

1. Teardown on genuine completion/doom. When a job lands in `jobs/tada/`
   (complete-job.sh) or is doomed by the reaper, remove that base's project
   worktree via `git -C <bare> worktree remove --force <path>` (NOT rm -rf of
   a registered worktree, which strands git registration). Guard: only remove
   on TERMINAL states, never for a job that may requeue (the persisted-worktree
   resume path must survive a "hit the wall" cycle). A completed job's follow-up
   is a NEW base -> NEW worktree, so terminal-state teardown is safe.
   For gardener-wt (garden-ROOT) worktrees, teardown must use
   `git worktree remove/prune` against $GARDEN_ROOT/.git — but the worker spine
   forbids workers touching the root repo, so this likely belongs to a
   leader-only maintenance daemon or the root-repo-guard, not the worker.

2. Scheduled safety-net sweep (like groom-parked-job-queue). A leader-only
   timer that finds ORPHANED worktrees (dead gitdir / unregistered in any bare
   repo's `worktree list`, e.g. pre-path-move stragglers under
   worktrees/<owner>-<repo>/<name>/) and completed-job worktrees whose PR is
   merged/closed, verifies each against live GitHub state, and removes them.
   Must run even under drain (an inode outage is exactly when the fleet is
   drained). Prefer `git worktree remove` + `git worktree prune`.

Also add an inode-headroom alert (df -i threshold) so this is caught before
0 free, not after it corrupts checkouts fleet-wide.

Design refs: WORKTREES.md (lifecycle), designs/gardening-state-machine.md,
scripts/jobs/{complete-job,ensure-project-worktree,reaper}.sh.
