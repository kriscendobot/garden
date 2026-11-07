## Completion report: fix-monk-sandbox-project-worktree-erofs

**The fix is pushed to main2 as `3c7f9ce045e`.** It completes `7fd074b62d5`, a "fix: allow sandboxed project worktrees" commit another worker landed minutes before I claimed this job. That earlier commit would not have fixed the problem in production, so the two commits together are the fix.

**Why the earlier commit fell short:** it bound `$GARDEN_ROOT/worktrees` and `$GARDEN_SCRATCH` read-write, but bound `$GARDEN_SCRATCH` only when that variable was set. `common.sh` sets a default for `GARDEN_SCRATCH` but never exports it, so the sandbox never sees it. In this monk sandbox `GARDEN_SCRATCH` was unset, which means the scratch bind would be skipped and `git worktree add` into `scratch/project-wt-*` would still fail with EROFS. Its test passed only because the test exported the variable.

**What `3c7f9ce045e` changes in `scripts/secrets/run-sandboxed.sh`:**
- **Scratch path:** it works out `GARDEN_SCRATCH` itself (`${GARDEN_SCRATCH:-$GARDEN_ROOT/scratch}`), binds it read-write, and sets it inside the sandbox.
- **Dependency cache:** it keeps `GARDEN_DEP_CACHE_ROOT` pointed at the host's shared cache (`$GARDEN_STATE/dep-cache`) and binds it read-write, the same way repo-locks are already handled. Without this, the per-job `GARDEN_STATE` would make every project job rebuild its dependencies from scratch, and the per-repo build lock would stop working across jobs.
- **Isolation after the scratch bind:** opening all of scratch would have exposed other jobs' `gardener-wt-*` worktrees and the shared TMPDIR parent (`scratch/tmpexec`, where other jobs' TMPDIRs live). Both are now re-mounted read-only after the scratch bind, which keeps the per-job TMPDIR isolation from `36f97ae8eff`.
- **Unchanged:** secret directories are still hidden behind tmpfs. The project-repo lock still serializes across jobs, because repo-locks link back to the host's shared directory.

**Tests:**
- `run-sandboxed-project-worktree-test.sh` has new cases for an unset `GARDEN_SCRATCH`, the shared dependency cache, and a peer worktree staying read-only.
- `run-sandboxed-state-test.sh` now uses its own fake garden root. Before that, it failed when its temp directory sat inside the real scratch directory, which is now bound read-write.
- All sandbox tests pass: project-worktree 6/0, state 4/0, tmpdir 1/0, monk-claude-tree-reap 20/0, secret-management 15/0.

**Remaining risk:** a peer gardener worktree created after a sandbox starts is not re-protected, so that sandbox could write to it. This is narrow and best-effort; closing it would mean moving project checkouts to their own parent directory.

**Next steps:**
- Once this host deploys `3c7f9ce045e`, the minion.town arc supervisor should re-arm the five parked jobs named in the spec. I have not re-armed them.
- I added a note with both fix commits to the `monk-sandbox-project-worktree-erofs` memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-monk-sandbox-project-worktree-erofs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 38 tokens (1320794 cached reads)
- Output: 12261 tokens
- Cost: $1.0824108 (1 engagement(s) unpriced)
- Wall-clock: 326s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
