Harden the garden against a dangling/stale `$GARDEN_ROOT/journal` worktree, which currently wedges `garden-foreman` (and every `journal_remote()` consumer) every tick.

Observed failure signature on host endolinbot2 (GARDEN_ROOT=/home/kris):
  `fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal`
  `[foreman] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal`
Cause: `/home/kris/journal/.git` points at `gitdir: /home/kris/garden2/.git/worktrees/journal`, a path removed when the garden was redeployed from `garden2` into `/home/kris`. `common.sh:journal_remote()` (line ~490-493) reads `remote.origin.url` from `$GARDEN_ROOT/journal`, git errors on the dangling gitdir, and it hits `die`. The registered journal worktree is also stale (`/home/kris/garden2/journal`, prunable) and holds the `journal2` branch, so a plain `worktree add` would refuse.

Two-part fix:

1. `scripts/jobs/common.sh` — `journal_remote()`: before `die`, fall back to the main worktree's origin. When `$JOURNAL_REMOTE` is unset AND `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url` fails (missing or dangling worktree), try `git -C "$GARDEN_ROOT" config --get remote.origin.url` (journal + main share one origin). Only `die` if both are absent. This is a zero-data-loss guard that immediately unwedges the foreman and every other `journal_remote()` caller even while the worktree is broken.

2. `scripts/jobs/journal-worktree-keeper.sh` — `keep_journal_worktree()`: replace the bare `WARN … skipping` at the `! git -C "$JW" rev-parse --git-dir` branch (lines 234-237) with a self-repair for the dangling-gitdir case, since the keeper is the component responsible for the shared worktree. When `$JW` exists but is not a valid repo: (a) `git -C "$GARDEN_ROOT" worktree prune` to drop the dead registration; (b) try `git -C "$GARDEN_ROOT" worktree repair "$JW"`; (c) if it's still invalid because the admin dir is gone, LOSSLESSLY back up any untracked/uncommitted content under `$JW` into `$GARDEN_JW_BACKUP_DIR/<host>-<ts>/` (reuse the existing backup discipline — the dangling gitdir means git can't classify dirtiness, so copy the tree wholesale), then remove `$JW` and `git -C "$GARDEN_ROOT" worktree add "$JW" "$JOURNAL_BRANCH"`. Gate the destructive path on the same no-active-writer probe (`jw_active_writer`) already in the file, and page the maintainer only if re-creation fails. Log the repair.

Note for whoever lands this: a one-time manual repair is also needed now to un-wedge this host — `git -C /home/kris worktree prune` then back up + remove `/home/kris/journal` and `git -C /home/kris worktree add /home/kris/journal journal2` — but the durable fix is the two script changes above so this can never recur silently on any host after a deploy-layout move.

---
claim:
  host: endolinbot2
  gardener: 10
  claimed_at: 2026-07-03T16:24:45Z
