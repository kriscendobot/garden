Repair the dangling `$GARDEN_ROOT/journal` worktree pointer that crash-loops every journal-touching service (comment-watcher, gardener, gardener-scaler, triager, cursor-get) on this host.

Failure signature (host endolinbot2, GARDEN_ROOT=/home/kris):
  fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal
  [cursor-get] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal
Both cross-pointers of the journal worktree dangle at a defunct prior checkout path (`/home/kris/garden2`):
  - /home/kris/journal/.git            → "gitdir: /home/kris/garden2/.git/worktrees/journal"
  - /home/kris/.git/worktrees/journal/gitdir → "/home/kris/garden2/journal/.git"
The backing entry (/home/kris/.git/worktrees/journal, commondir ../.., HEAD ref journal2) is intact, so `git -C /home/kris worktree repair /home/kris/journal` rewrites both pointers to the correct current paths and restores the worktree (verified: corrected GIT_DIR yields branch journal2).

Two changes:
1. IMMEDIATE host-state repair: run `git -C "$GARDEN_ROOT" worktree repair "$GARDEN_ROOT/journal"` so the crash-loop stops now. (Idempotent; safe to re-run.)
2. DURABLE hardening in scripts/jobs/journal-worktree-keeper.sh: in `keep_journal_worktree()`, replace the current "not a git repo → WARN and skip" branch (the `if ! git -C "$JW" rev-parse --git-dir` guard, ~line 234) with a self-heal attempt: when `$JW` exists and `$GARDEN_ROOT/.git/worktrees/<basename $JW>` exists but the gitdir is dangling, run `git -C "$GARDEN_ROOT" worktree repair "$JW"` and re-check `rev-parse --git-dir`; only fall through to the WARN/skip (or alert_maintainer) if the repair does not restore it. This makes the keeper heal a post-deploy/relocated-checkout dangling gitdir the same way it already self-heals a diverged tree, so this class stops requiring a self-heal-fix job per service. Add a keeper test covering a journal worktree whose `.git` gitdir points at a nonexistent path, asserting the keeper repairs it and leaves HEAD on journal2.

---
claim:
  host: endolinbot2
  gardener: 13
  claimed_at: 2026-07-03T11:09:34Z
