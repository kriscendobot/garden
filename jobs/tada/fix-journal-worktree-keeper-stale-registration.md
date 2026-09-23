The work is complete and pushed. Both files are in the commit on `origin/main2`.

## Completion report

**Job:** Harden `journal-worktree-keeper.sh` against stale `garden2` worktree registrations.

**What I changed** (`scripts/jobs/journal-worktree-keeper.sh`):
- Added an **unconditional `git -C "$GARDEN_ROOT" worktree prune`** at the very top of `jw_repair_gitdir()`, **before** the early-return health check. This is the fix: previously a worktree whose gitdir *currently resolves* but has a lingering stale sibling registration (`prunable` in `git worktree list`) was declared "already healthy" and never pruned, so a later git op could re-latch onto the stale entry and re-break the linkage within the hour.
- The prune now also runs **before** `worktree repair`, giving the prune-then-relink-against-the-surviving-admin-entry order that empirically makes the fix stick. Removed the now-redundant post-repair prune.
- Updated the header comment block and inline comments to explain the resolving-gitdir-with-stale-sibling recurrence. Left the success gate (`rev-parse --git-dir` + `remote.origin.url`) and the STEP 2 rebuild path with all their active-writer/backup guards untouched.

**Regression test** (`scripts/jobs/test/journal-worktree-keeper-test.sh`):
- New case **"HEALTHY GITDIR + STALE SIBLING REGISTRATION — pruned on the healthy path"**: builds a real worktree whose gitdir resolves (old early-return fires) plus a manufactured `prunable` sibling registration for an absent path, then asserts the stale entry is gone after one tick while the live worktree stays clean and healthy. Verified it **FAILS against the pre-change script and passes after**. Full suite: **87 passed, 0 failed.**

**Commit / push:** `e307fa234` on `origin/main2` (2 files, +93/−9), authored as `endolinbot`.

**Follow-up for the maintainer:** This host (`endolinbot2`) is *actively* exhibiting the incident right now — `/home/kris/garden2/.git/worktrees/` admin entries are being pruned aggressively (sub-second), which orphaned my own job worktree mid-run. I had to build the commit's objects in the shared store via a `/tmp` worktree and push the resulting sha directly from the stable root repo. The root cause looks like a leftover `/home/kris/garden2` checkout being churned by a keeper whose real deployed root is `/home/kris`; worth a look independent of this code fix (which addresses the same failure class but not a runaway prune of *present* worktrees).
