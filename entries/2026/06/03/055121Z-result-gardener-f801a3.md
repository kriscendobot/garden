---
ts: 2026-06-03T05:51:21Z
kind: result
role: gardener
refs:
  - entries/2026/06/03/053540Z-dispatch-liaison-04ea20.md
---

Encoded the dispatch-prepare branch-resolution fix that the #411 fixer provisioning surfaced. Commit `35db5e47` on `main`.

**Root cause.** The 2026-06-02 frozen-base-branch encode (`81fb2f56`) added `remote.origin.fetch = +refs/heads/*:refs/remotes/origin/*` to bare clones so `origin/master` tracks live master. That same refspec routes every branch created *after* the clone into `refs/remotes/origin/*`, not `refs/heads/*`. `dispatch-prepare.sh` passed the bare branch name to `git worktree add --detach <path> <BRANCH>`, which does not resolve against a remote-tracking-only ref, so provisioning any post-clone PR branch failed and left an empty `DISPATCH_ROOT` (silent failure). Original-clone branches like `master` kept a `refs/heads/` head and still worked, so only new PR branches hit it. Hit live provisioning the #411 fixer against `ci/cache-playwright-browsers`.

**Changes (1 commit, 3 files):**

- `skills/dispatch-worktree/dispatch-prepare.sh` — added an explicit fetch into `refs/heads/` immediately before the project `worktree add`:
  ```sh
  git --git-dir="$BARE" fetch --quiet origin \
    "+refs/heads/${BRANCH}:refs/heads/${BRANCH}" 2>/dev/null || true
  ```
  preceded by a comment explaining the refspec interaction. The `+` forces update of an existing local head (original-clone branches); a non-existent branch makes the fetch a no-op and the existing `worktree add` error path surfaces the clear "invalid reference" failure. The bare-clone-not-found rollback and identity pinning are untouched. `bash -n` passes.
- `WORKTREES.md` — § Adding a fork worktree now states the consequence of the fetch refspec (post-clone branches land in `refs/remotes/origin/*`) and that dispatch-prepare fetches the target into `refs/heads/` at prepare time; § Per-dispatch worktree triple's lifecycle summary names the fetch step. `updated: 2026-06-03`.
- `skills/dispatch-worktree/SKILL.md` — dated *Notes from the field* line citing the 2026-06-03 #411 provisioning failure and the diagnosis entry. `updated: 2026-06-03`.

No role/skill added/renamed/retired, so `CLAUDE.md` § Current inventory unchanged. Swept other refspec references (`pr-handoff`, `frozen-base-branch`, `journal-sync`, `worktree-per-pr`): all consistent, none described dispatch-prepare's branch resolution in a way that now needed updating. Push was rejected once by a concurrent advance; fetched, rebased cleanly, re-pushed.

Self-improvement: skills/dispatch-worktree/dispatch-prepare.sh, WORKTREES.md, skills/dispatch-worktree/SKILL.md; reconciled dispatch-prepare's bare-branch resolution with the frozen-base fetch refspec so post-clone PR branches provision without a silent empty DISPATCH_ROOT.
