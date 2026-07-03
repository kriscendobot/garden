In `scripts/jobs/journal-worktree-keeper.sh`, upgrade the `keep_journal_worktree()` guard at lines 234-237 from WARN-and-skip into an autonomous, lossless gitdir repair, so a dangling `$GARDEN_ROOT/journal/.git` gitlink self-heals instead of wedging every journal consumer (issue-inbox, gardener, gardener-scaler).

Failure signature to match: `git -C $GARDEN_ROOT/journal rev-parse --git-dir` fails with `fatal: not a git repository: <path>/.git/worktrees/journal` because the gitlink in `$JW/.git` points at a garden checkout that was removed (observed: `/home/kris/journal/.git` → `gitdir: /home/kris/garden2/.git/worktrees/journal`, and `/home/kris/garden2` no longer exists). Downstream, `common.sh:490 journal_remote()` then dies with `no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal`.

Repair procedure (only when `$JW` == `$GARDEN_ROOT/journal`, `$GARDEN_ROOT` is a valid repo with an `origin` remote, and `git -C "$JW" rev-parse --git-dir` fails):
1. Try the cheap fix first: `git -C "$GARDEN_ROOT" worktree repair "$JW"` (re-points the gitlink when a matching admin entry exists).
2. If it still fails to resolve (the owning checkout is gone, so there is no admin entry — as here), `git -C "$GARDEN_ROOT" worktree prune`, back up any files present under `$JW` into `$GARDEN_STATE/journal-worktree-keeper/backups/<host>-<ts>` (reuse the existing lossless-backup helper), remove the stale `$JW` directory, then re-establish it: `git -C "$GARDEN_ROOT" worktree add --force "$JW" "$JOURNAL_BRANCH"` (checking out `origin/$JOURNAL_BRANCH` if the local branch is absent).
3. Re-run `rev-parse --git-dir`; on success fall through to the normal fetch/reconcile path, on failure log and page per the existing unpreservable-WIP path.

Guard hard against touching anything outside `$GARDEN_ROOT/journal`. Since this hardens the shared keeper for the whole recurring class, consolidate/close the two prior per-service jobs (`self-heal-fix-garden-gardener-journal-worktree-dangling-gitdir-repair`, `self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair`) into this one fix. Add a keeper test covering a dangling-gitdir worktree whose owning checkout was deleted.

---
claim:
  host: endolinbot2
  gardener: 4
  claimed_at: 2026-07-03T11:10:11Z
