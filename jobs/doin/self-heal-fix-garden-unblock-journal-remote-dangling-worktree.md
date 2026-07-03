Harden `journal_remote()` in `scripts/jobs/common.sh` (currently lines ~489–494) so a dangling/broken `$GARDEN_ROOT/journal` worktree cannot take down the whole fleet.

Failure signature: `garden-unblock` (and any service that derives the remote via `ensure_clone`→`journal_remote` without a `JOURNAL_REMOTE` env override) exits 1 with two log lines:
```
fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal
[unblock] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal
```
Cause: `/home/kris/journal/.git` points at `gitdir: /home/kris/garden2/.git/worktrees/journal`, but `garden2` was removed by a deploy, so `git -C $GARDEN_ROOT/journal config --get remote.origin.url` fails (rc 128) and `journal_remote` dies.

Change (primary): give `journal_remote()` a fallback chain before it dies:
  1. `$JOURNAL_REMOTE` if set (unchanged);
  2. `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url` (unchanged), BUT on failure/empty don't die yet;
  3. fall back to `git -C "$GARDEN_ROOT" config --get remote.origin.url` (the garden repo's own origin — same GitHub repo as the journal remote, verified identical: `git@github.com:kriskowal/garden.git`; clones already pin `--branch $JOURNAL_BRANCH`, so only the URL matters);
  4. only then `die`. Log a one-line WARN when the fallback is used so the dangling worktree is still visible.

Change (complementary, so the dangling worktree self-heals instead of merely being routed around): in `scripts/jobs/journal-worktree-keeper.sh` (the `rev-parse --git-dir` guard at ~line 234, which today just logs "missing or not a git repo … skipping"), when `$GARDEN_ROOT/journal` is a *dangling* worktree (a `.git` file whose `gitdir:` target no longer exists) and `$GARDEN_ROOT` is a valid garden repo, REPAIR it: remove the stale `.git` pointer / prune the stale registration and `git -C "$GARDEN_ROOT" worktree add --force "$GARDEN_ROOT/journal" "$JOURNAL_BRANCH"` (tracking `origin/$JOURNAL_BRANCH`). Guard the repair behind the same no-active-writer probe the keeper already uses so a live agent's WIP is never clobbered; leave the plain "missing" (never-created) case as the existing skip.

Add a regression test for the `journal_remote` fallback: with `JOURNAL_REMOTE` unset and a `$GARDEN_ROOT/journal` whose `.git` points to a nonexistent gitdir, assert `journal_remote` returns the `$GARDEN_ROOT` origin URL and does not `die`.

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-03T16:23:33Z
