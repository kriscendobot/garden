Harden `scripts/jobs/journal-worktree-keeper.sh` to detect and repair a stale/dangling gitdir link on the shared `$GARDEN_ROOT/journal` worktree before its fetch/fast-forward logic.

Failure signature (garden-orchestrate, exit 1, and identically garden-gardener / garden-gardener-scaler):
```
fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal
[orchestrate] FATAL: no JOURNAL_REMOTE set and no origin on /home/kris/journal
```

Root cause: after the garden root moved from `/home/kris/garden2` to `/home/kris`, the `journal` worktree's two cross-pointers were never repaired. `journal/.git` still reads `gitdir: /home/kris/garden2/.git/worktrees/journal` and `.git/worktrees/journal/gitdir` still reads `/home/kris/garden2/journal/.git` — both under a nonexistent `garden2`. Consequently every `git -C $GARDEN_ROOT/journal …` fails, and `journal_remote()` (common.sh:490-493) hits its `die`, exiting 1 for any service that resolves the journal remote (orchestrate, gardener, gardener-scaler, …).

Fix: at the top of each keeper tick, verify the worktree's git linkage resolves (e.g. `git -C "$JW" rev-parse --git-dir` succeeds and the resolved gitdir exists). If it does not, run `git -C "$GARDEN_ROOT" worktree repair "$JW"` (idempotent — a no-op when already healthy) to rewrite both `$JW/.git` and `$GARDEN_ROOT/.git/worktrees/journal/gitdir` to correct absolute paths, then log a one-line "repaired journal worktree gitdir" and proceed to the normal fetch/ff. Do this guard BEFORE the fetch so the keeper's own git commands don't themselves fail on the broken link. This is lossless (repair only rewrites pointer files; it never touches the tree) so it needs none of the active-writer/backup gating the divergence path uses. The same repair retires the sibling garden-gardener and garden-gardener-scaler self-heal jobs for this signature.

---
claim:
  host: endolinbot2
  gardener: 2
  claimed_at: 2026-07-03T11:10:01Z
