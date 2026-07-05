In kriskowal/garden, investigate and fix a worktree-keeper defect surfaced on host endolinbot2: `garden-journal-worktree-keeper` logs a dangling gitdir reference to `/home/kris/garden2/.git/worktrees/journal` every tick, and per-job `gardener-wt-*` admin entries under `/home/kris/.git/worktrees/` are being pruned out from under live gardeners (corrupting any job that commits from its assigned worktree). Diagnose the keeper's prune logic and land a fix on main2 that excludes live per-job gardener worktrees from pruning.

---
claim:
  host: endolinbot
  gardener: 22
  claimed_at: 2026-07-05T17:38:56Z
