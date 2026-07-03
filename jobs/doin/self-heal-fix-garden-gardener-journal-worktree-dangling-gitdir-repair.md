Harden the journal-worktree access path in `scripts/jobs/common.sh` so a dangling/mismatched worktree gitdir self-heals instead of crash-looping under a false "no origin" error.

Failure signature: `git -C "$GARDEN_ROOT/journal"` emits `fatal: not a git repository: <admin-dir>` (the worktree's `.git` gitdir points at a nonexistent/wrong admin dir — here `/home/kris/.git/worktrees/journal` instead of `/home/kris/garden2/.git/worktrees/journal`), causing `journal_remote()` (common.sh:490) to fire `|| die "no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal"` and `claim`/`monitor` to exit rc=1 forever under systemd Restart.

Change (both are needed):
1. Add a preflight — call it `ensure_journal_worktree_linked` — that runs before `journal_remote`/`ensure_clone` touch `$GARDEN_ROOT/journal`. When `git -C "$GARDEN_ROOT/journal" rev-parse --git-dir` fails but `$GARDEN_ROOT/journal/.git` exists and `$GARDEN_ROOT/.git/worktrees/journal` exists, run `git -C "$GARDEN_ROOT" worktree repair "$GARDEN_ROOT/journal"` (and `git -C "$GARDEN_ROOT" worktree prune`) to re-link the forward `.git` file and the admin `gitdir` back-pointer, then re-check. This quietly self-repairs the exact corruption above.
2. Fix the misdiagnosis in `journal_remote()` (common.sh:490-494): distinguish "journal is not a valid worktree" from "valid worktree, no origin remote." Gate on `git -C "$GARDEN_ROOT/journal" rev-parse --git-dir` first; if that fails, die with an accurate, actionable message naming the dangling gitdir (`journal worktree at $GARDEN_ROOT/journal is not a valid git repo; its .git points at <gitdir> — run 'git -C $GARDEN_ROOT worktree repair'`) rather than the false "no origin."

Immediate unstick for the live loop (also the repair the guard automates): `git -C /home/kris/garden2 worktree repair /home/kris/garden2/journal && git -C /home/kris/garden2 worktree prune`.

Add a regression test under `scripts/jobs/test/` that fabricates a journal worktree whose `.git` gitdir points at a nonexistent admin dir and asserts the preflight repairs it (or, when unrepairable, that the die message names the gitdir and does not say "no origin").

---
claim:
  host: endolinbot2
  gardener: 7
  claimed_at: 2026-07-03T11:06:44Z
