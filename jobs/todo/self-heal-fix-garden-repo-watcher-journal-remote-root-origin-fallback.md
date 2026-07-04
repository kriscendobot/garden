Harden `journal_remote()` in `scripts/jobs/common.sh` (lines 490-494) so a dangling/absent `$GARDEN_ROOT/journal` worktree no longer FATALs every job script that derives the journal remote.

Failure signature (repo-watcher and any `ensure_clone` caller):
  fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal
  [repo-watcher] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal
Cause: `/home/kris/journal/.git` points at `gitdir: /home/kris/garden2/.git/worktrees/journal`, but `/home/kris/garden2` was removed. `journal_remote()` reads `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url`, which fails, and `die`s. The root repo `$GARDEN_ROOT` (/home/kris) still has a valid `remote.origin.url` (git@github.com:kriskowal/garden.git); root and journal are worktrees of the same repo sharing one origin.

Change (common.sh, journal_remote): keep `JOURNAL_REMOTE` override first; then try `$GARDEN_ROOT/journal` origin as today; on failure, fall back to `git -C "$GARDEN_ROOT" config --get remote.origin.url`; only `die` if BOTH the journal-worktree and root-repo reads yield nothing. Suppress the sub-command's stderr on the first attempt so the raw `fatal: not a git repository` line no longer leaks to the service log when the fallback succeeds. Update the derivation comment at lines 19-21 to note the root-origin fallback.

One-time host repair (belongs in the same job, run on this host / any host showing the prunable garden2 worktree): `git -C /home/kris worktree prune` to drop the stale garden2 registrations, then recreate the canonical journal worktree — e.g. `git -C /home/kris worktree add /home/kris/journal journal2` (or re-point `/home/kris/journal/.git` at `/home/kris/.git/worktrees/journal`). Verify `git -C /home/kris/journal rev-parse --abbrev-ref HEAD` reports `journal2` afterward.

Add/extend a common.sh test that points `GARDEN_ROOT/journal` at a broken gitdir (or removes it) with a valid `$GARDEN_ROOT` origin and asserts `journal_remote` returns the root origin instead of dying.
