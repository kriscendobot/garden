Pushed on the first attempt. Work is complete.

## Completion report

**Job:** fix `ensure-project-worktree.sh` hard-failing when the requested branch is held checked-out in a standing worktree.

**Root cause confirmed:** the script fetched `+refs/heads/$branch:refs/heads/$branch`. When a standing worktree (e.g. the endo-but-for-bots monitor) holds `refs/heads/$branch` checked out, git refuses with `fatal: refusing to fetch into branch '...' checked out at ...`. That error was swallowed by `2>/dev/null`, so the (correct) stale-tree guard from `5df0a675d` then saw the stale local head and died — a deterministic block on every job needing that branch on the host.

**What changed (`scripts/jobs/ensure-project-worktree.sh`):**
- Fetch into the remote-tracking ref (`+refs/heads/$branch:refs/remotes/origin/$branch`) instead of `refs/heads/$branch`. Remote-tracking refs are never checked out, so the force-update always succeeds.
- Stale-tree guard preserved and re-pointed at `refs/remotes/origin/$branch` (verified against `ls-remote`).
- `worktree add --detach` now checks out from `refs/remotes/origin/$branch` when the caller wants the branch (the default); an explicit ref/SHA argument keeps its existing resolution.
- The fetch's stderr is now captured and surfaced via `log()` instead of discarded, so the next failure mode is visible.

**Test (`scripts/jobs/test/project-worktree-isolation-test.sh`):** added case 7 — stands up a worktree holding `refs/heads/llm` checked out, then asserts the helper still delivers a detached checkout. Full suite: 16 passed, 0 failed. Separately verified that the *old* refspec dies with the exact "refusing to fetch" error under that condition while the new one succeeds.

**Commit:** pushed to `main2` (rebase-CAS, first attempt).

**Follow-ups:** none. The design-ebfb job that hit this can now get its `llm` checkout via the standard helper.
