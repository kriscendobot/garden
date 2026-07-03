This job is already fully satisfied in `origin/main2`; no code change is needed.

**Verification of both hardening points:**

**Primary** (`scripts/jobs/journal-worktree-keeper.sh`): The warn-and-skip guard the job targets (`if ! git -C "$JW" rev-parse --git-dir …; then log "WARN: … skipping"`) is now at lines 395–398, but it is preceded by `jw_repair_gitdir "$JW"` (line 390), which:
- Detects the dangling-gitfile case — `rev-parse --git-dir` failing or its resolved gitdir missing on disk (lines 269–272).
- Runs `git -C "$GARDEN_ROOT" worktree repair "$jw"` + `worktree prune` (lines 277–282).
- Re-checks `git -C "$jw" rev-parse --git-dir`; on success logs "repaired journal worktree gitdir" and returns (lines 283–286).
- Only if it still fails, falls through to `jw_rebuild_dangling_worktree`, which losslessly backs up the tree and recreates the worktree via `git worktree add --force` off `$JOURNAL_BRANCH`, paging the maintainer solely when backup or re-add fails (lines 300–364).

The warn-and-skip now fires only after repair *and* rebuild both fail — exactly the requested behavior.

**Secondary** (`scripts/jobs/common.sh:journal_remote`): After the cache/root-origin fallbacks, the final diagnostic (lines 724–729) distinguishes a broken worktree from a missing origin: it probes `git -C "$jw" rev-parse --git-dir` and, on failure, `die`s naming the dangling `gitdir:` target with a `worktree repair` remedy; only when the repo opens cleanly does it emit the plain "no origin" `die`.

Both landed in the prior commit series `430ac2b82 → cdd341056 → d4b231773` (plus `ce4b94831`, `b208fb932`, `53a062507`), all confirmed ancestors of `origin/main2`. My worktree sits at `origin/main2` (28bf014a3) with zero divergence.

**What I did:** Read the two target files, confirmed the described repair/rebuild path and the exit-128-vs-missing-origin diagnostic are both present and merged, verified the enabling commits are in `origin/main2`, and drained my (empty) inbox.

**What changed:** Nothing — no new commit; the fix was already deployed to main2. This job was a duplicate of already-completed self-heal work.

**Follow-ups:** None.
