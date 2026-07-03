Fix the stale journal worktree link and harden common.sh against its recurrence. The gardener-scaler (via ensure_clone → journal_remote in scripts/jobs/common.sh:490) dies "no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal" whenever the journal worktree's gitdir link is dangling. Root cause: after the garden moved from /home/kris to /home/kris/garden2, /home/kris/garden2/journal/.git still points to the nonexistent gitdir:/home/kris/.git/worktrees/journal, and the admin back-pointer /home/kris/garden2/.git/worktrees/journal/gitdir points to /home/kris/journal/.git. git exits 128 ("fatal: not a git repository: /home/kris/.git/worktrees/journal") and journal_remote()'s die() masks it as a missing-origin error.

1. Repair the live state once: `git -C /home/kris/garden2 worktree repair /home/kris/garden2/journal` (rewrites both the worktree .git file and the admin gitdir back-pointer; the admin dir already has origin=git@github.com:kriskowal/garden.git, so no re-clone is needed).

2. Harden journal_remote() in scripts/jobs/common.sh so this self-heals: before the `git config --get remote.origin.url` on $GARDEN_ROOT/journal, if `git -C "$GARDEN_ROOT/journal" rev-parse --git-dir` fails, run `git -C "$GARDEN_ROOT" worktree repair "$GARDEN_ROOT/journal"` once and retry. If it still fails, die with an accurate message that distinguishes a *broken* worktree (naming the dangling gitdir target from "$GARDEN_ROOT/journal/.git") from a genuinely *missing origin*, so the misleading "no origin" text stops sending recurrences down the wrong path.

---
claim:
  host: endolinbot2
  gardener: 9
  claimed_at: 2026-07-03T11:07:20Z
