Everything the job asks for is already in place. Here's my report.

---

**Job: self-heal-fix-garden-repo-watcher-dangling-journal-worktree-gitdir**

**Finding: both code changes and the live one-time repair are already complete. No new commits needed.**

**Change (1) — `scripts/jobs/common.sh` `journal_remote()` root-origin fallback:** Already landed on `origin/main2` (commit `cdd341056` "common.sh: fall back to root origin when the journal worktree is unrepairable", plus companion commits `a0ddbce44`, `556103da2`). The current `journal_remote()` (lines ~682–730) resolves in order: `$JOURNAL_REMOTE` → worktree `remote.origin.url` (healthy hosts still win here, so it's behavior-neutral) → per-host cache → **`git -C "$GARDEN_ROOT" config --get remote.origin.url`** with a single WARN → only then a `die` that distinguishes a broken worktree (names the dangling gitdir target) from a genuinely missing origin. This is the fallback the job specified, and then some (the cache layer is an extra safety net).

**Test coverage:** Already present in `scripts/jobs/test/journal-worktree-relink-test.sh`, case "SELF-HEAL — unrepairable gitdir but ROOT has origin: root fallback, no die" (lines 142–154): dangling worktree gitdir + garden-root origin present → `journal_remote` returns the root origin (`rc=0`, no die, WARN logged). Exactly the fallback line the spec asked to add.

**Change (2) — `scripts/jobs/journal-worktree-keeper.sh` dangling-gitdir self-heal:** Already landed (commits `d4b231773`, `b208fb932`, `ce4b94831`, `53a062507`). `keep_journal_worktree()` now calls `jw_repair_gitdir()` before any other git op, which: (a) returns early if healthy; (b) tries `git -C "$GARDEN_ROOT" worktree repair "$jw"` + `worktree prune`; (c) if still broken, calls `jw_rebuild_dangling_worktree()` — hard-guarded to only ever touch `$GARDEN_ROOT/journal`, requires `$GARDEN_ROOT` to be a valid repo with an origin, takes a **lossless raw-tree backup** (`jw_backup_raw_tree`) before removing the stale dir, then re-adds via `worktree add --force` off the local branch or `origin/$JOURNAL_BRANCH`, logging each step and **paging the maintainer only if recreation itself fails**. Matches the spec's requirements including the lossless/no-clobber constraint.

All four commits confirmed as ancestors of `origin/main2` HEAD (`28bf014a3`).

**Live operational repair (host `endolinbot2`):** Already healed. `/home/kris/journal/.git` now reads `gitdir: /home/kris/.git/worktrees/journal` and `git -C /home/kris/journal rev-parse --git-dir` resolves cleanly; `git -C /home/kris worktree list` shows `/home/kris/journal … [journal2]` as valid. The removed `/home/kris/garden2` is gone and no stale `garden2/*` worktree entries remain (prune already ran). The crash-loop signature the job targeted no longer reproduces.

**Changes this run:** none — worktree clean, nothing to commit or push. The work was completed by the commit chain above (and a peer/keeper tick performed the one-time live repair) before this job was claimed.

**Follow-ups:** none. Sibling self-heal jobs still on the board (`...foreman...`, `...issue-inbox-keeper...`, `...orchestrate...`) address the same class of dangling-gitdir failure in other units and are independent of this one.
