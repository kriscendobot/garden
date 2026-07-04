Root cause: the standing `$GARDEN_ROOT/journal` worktree has stale two-way git links from a `/home/kris/garden2` → `/home/kris` relocation/deploy. `/home/kris/journal/.git` points at the nonexistent `gitdir: /home/kris/garden2/.git/worktrees/journal`, and `/home/kris/.git/worktrees/journal/gitdir` points at nonexistent `/home/kris/garden2/journal/.git`. Any service reading the journal worktree fails; observed signature is `fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal` followed by `[orchestrate] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal` (from `journal_remote()` in `scripts/jobs/common.sh:490-494`, which `|| die`s when `git -C $GARDEN_ROOT/journal config --get remote.origin.url` fails).

Two scoped changes:

1. `scripts/jobs/journal-worktree-keeper.sh`, `keep_journal_worktree()` (the `rev-parse --git-dir` guard at lines 234–237): instead of only `log "WARN … skipping"; return 0`, when the worktree is unreadable AND `$JW/.git` is a gitfile whose recorded `gitdir:` target does not exist (a stale relocation link), attempt `git -C "$GARDEN_ROOT" worktree repair "$JW"` then `git -C "$GARDEN_ROOT" worktree prune`, and re-test `git -C "$JW" rev-parse --git-dir`. On success, `log "SELF-HEALED: relinked $JW after relocation"` and continue the normal fetch/reconcile path; on continued failure, `alert_maintainer "journal-worktree-unrepairable-$GARDEN"` with the recorded-vs-actual gitdir paths. Keep the change idempotent (repair on an already-healthy link is a no-op) and quiet on the healthy path.

2. Defense in depth in `scripts/jobs/common.sh` `journal_remote()` (lines 490–494): the journal worktree is a worktree of the *same* garden repo, so when `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url` fails, fall back to `git -C "$GARDEN_ROOT" config --get remote.origin.url` before `die`. This keeps orchestrate (and other `journal_remote()` callers) resilient to a transiently-broken standing worktree rather than FATAL-ing.

Verify: with a worktree whose `.git` points at a nonexistent gitdir, a keeper tick relinks it and a subsequent `orchestrate.sh` tick resolves the journal remote and no longer FATALs.

---
claim:
  host: endolinbot2
  gardener: 10
  claimed_at: 2026-07-04T03:04:03Z
