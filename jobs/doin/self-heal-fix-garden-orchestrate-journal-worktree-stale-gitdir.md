Harden `scripts/jobs/journal-worktree-keeper.sh` to REBUILD a broken/missing journal worktree instead of skipping it, then let it repair this host.

Failure signature: journal-touching services (garden-orchestrate first, but foreman/scheduler/etc. share the path) fail exit 1 with `[orchestrate] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal` preceded by `fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal`. Cause: `$GARDEN_ROOT/journal` (`/home/kris/journal`) is a stale worktree whose `.git` points at the removed `/home/kris/garden2/.git`, and the root repo's registered journal worktree (`/home/kris/garden2/journal`) is `prunable`. `journal_remote()` in `common.sh` then dies because `git -C $GARDEN_ROOT/journal config remote.origin.url` errors.

Change: in `keep_journal_worktree()`, replace the current `rev-parse --git-dir` guard that logs `WARN … skipping` with a repair branch. When `$JW` is missing OR its `git -C "$JW" rev-parse --git-dir` fails (broken gitdir), AND no live writer holds `$JW` as a cwd (reuse `jw_active_writer`, treat a missing dir as no writer), rebuild it safely:
  1. `git -C "$GARDEN_ROOT" worktree prune` to clear the stale/prunable registration.
  2. `rm -rf "$JW"` only if it exists and `git -C "$JW" rev-parse --git-dir` fails (never remove a valid worktree).
  3. Ensure a local `$JOURNAL_BRANCH` exists tracking `origin/$JOURNAL_BRANCH` (fetch first via the existing `journal_fetch`/bounded-fetch helper), then `git -C "$GARDEN_ROOT" worktree add "$JW" "$JOURNAL_BRANCH"` (or `--track -b "$JOURNAL_BRANCH" "origin/$JOURNAL_BRANCH"` if the local branch is absent). If `$JOURNAL_BRANCH` is still checked out at a stale prunable path, the prune in step 1 frees it.
  4. Log a one-line `REBUILT: $JW recreated as worktree of $GARDEN_ROOT on $JOURNAL_BRANCH` and return 0. Page the maintainer only if the rebuild command itself fails.
Keep the existing diverged/clean reconciliation for the healthy case unchanged. Add a test in `scripts/jobs/test/journal-worktree-keeper-test.sh` covering the broken-gitdir case (worktree `.git` pointing at a non-existent parent) asserting the keeper rebuilds it. This both repairs `/home/kris` now (the timer will rebuild `/home/kris/journal`) and prevents recurrence for every journal-touching service after a root/deploy relocation orphans the old worktree.

---
claim:
  host: endolinbot2
  gardener: 5
  claimed_at: 2026-07-03T16:24:20Z
