Failure signature (garden-comment-watcher@* and every other journal poller, exit 1):
`fatal: not a git repository: <old-root>/.git/worktrees/journal` followed by
`[cursor-get] FATAL: no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal`.
Cause: `$GARDEN_ROOT/journal` is a dangling worktree whose `.git` gitdir points at a
now-removed sibling checkout (here `/home/kris/garden2/.git/worktrees/journal`), so
`journal_remote()` in `scripts/jobs/common.sh` dies deriving the remote.

Two scoped changes, both keyed to this signature:

1. `scripts/jobs/journal-worktree-keeper.sh` — in `keep_journal_worktree()` (the
   `rev-parse --git-dir` guard at ~line 234), turn warn-and-skip into REPAIR when
   `$GARDEN_ROOT/journal` is present-but-broken: it's a directory yet not a valid
   worktree of `$GARDEN_ROOT/.git`, or its `.git` gitdir resolves outside
   `$GARDEN_ROOT/.git/worktrees`. Repair = `git -C "$GARDEN_ROOT" worktree prune`,
   move the stale dir aside into `$GARDEN_JW_BACKUP_DIR` (lossless, never delete),
   then `git -C "$GARDEN_ROOT" worktree add --force "$GARDEN_ROOT/journal"
   "$JOURNAL_BRANCH"` (after a bounded `journal_fetch` of the garden-root repo).
   Gate the repair on the same no-active-writer probe already in the file; log a
   `REPAIRED:` line and page only if the add fails. Add a keeper test alongside
   `test/journal-worktree-keeper-test.sh` that stands up a worktree with a gitdir
   pointing at a removed repo and asserts it is re-created on journal2.

2. `scripts/jobs/common.sh` `journal_remote()` (line 490) — defensive fallback: when
   `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url` yields nothing,
   fall back to `git -C "$GARDEN_ROOT" config --get remote.origin.url` before
   `die`. This is safe because the journal (`journal2`) is an orphan branch on the
   SAME origin as the garden root; it keeps pollers alive through a transiently
   broken journal worktree instead of taking the whole watcher down.

---
claim:
  host: endolinbot2
  gardener: 12
  claimed_at: 2026-07-03T16:25:00Z
