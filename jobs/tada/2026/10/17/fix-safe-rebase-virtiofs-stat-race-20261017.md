**Completion report: fix-safe-rebase-virtiofs-stat-race-20261017**

The fix is pushed to `main2` as commit c2f25a30601. It has not been tried on a real virtiofs mount: this host's scratch is ext4, so a simulated test stands in for the stat churn.

**What I did**
- **Fix:** `scripts/jobs/gardening/safe-rebase.sh` no longer rebases in the caller's worktree. It now:
  - adds a temporary detached worktree under `GARDEN_REBASE_SCRATCH`, which defaults to `/tmp` (local disk, not the virtiofs scratch mount);
  - runs the replay and the lockfile-only skip loop there;
  - moves the result back into the caller's worktree and branch with one `git reset --hard`, which does not run the check for local changes that was failing.

  If the replay is refused (rc 3) or fails (rc 1), the caller's worktree is untouched. An exit trap aborts any rebase still in progress in the temporary worktree, then removes and prunes it. Lockfile regeneration and its commit still run in the caller's worktree, as before. A new pre-check refuses a genuinely dirty caller tree (rc 1) before anything moves, because `reset --hard` would otherwise throw those edits away. `git status` compares file contents when the stat data differs, so stat churn alone does not trip this check.
- **Why this fix and not refresh-and-retry:** the job's own evidence showed the stat knobs only made the failure intermittent. A sleep-and-retry would still depend on timing; replaying on local disk does not.
- **Regression tests** in `scripts/jobs/test/safe-rebase-test.sh`:
  - Case 8 stands in for the churn with a post-checkout hook that dirties `code.txt` only in the caller's tree, which is where an in-place rebase checks out the base. The old script fails this case with the production message ("stopped with no conflicted paths; aborted as a tooling error"); the new one passes, and the test also checks that the branch was moved, the tree is clean and the temporary worktree is gone.
  - Case 9 checks that a really dirty tree gets rc 1, HEAD stays put and the edit is kept.

**Test results**
- `safe-rebase-test.sh`: 9/9 pass. `TMPDIR` was the scratch `tmpexec` directory; this host's `/tmp` is tmpfs and noexec, and noexec doesn't matter for the replay.
- `rebase-pr-before-merge-test.sh`: passes.
- `ci-wait-merge-test.sh`: 105 pass, 2 fail, both in T8 (stale `GARDEN_GH` falling back to the `gh` on PATH). T8 fails the same way with the old `safe-rebase.sh`, so it is not caused by this change and is still open.

**Follow-ups**
- Run `safe-rebase-test.sh` on oros-studio with `TMPDIR` on virtiofs once the fix deploys, to confirm it there.
- After deploy, re-conduct kriscendobot/minion.town#190. The proxy should re-screen it and post a fresh conductor; if it doesn't, the liaison can re-post the job.
- Worth knowing: every rebase now does a full checkout of the repo into `/tmp`, which costs a few seconds and some tmpfs space on large repos like endo.
- T8 in `ci-wait-merge-test.sh` needs its own fix job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `9ce81f8966ca40c5d1aca0fcf5fd485c21ba862b`; this job presented `f9a87fcfda07e2bac7e1186f809a6be8e42cb789`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-safe-rebase-virtiofs-stat-race-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (869969 cached reads)
- Output: 13652 tokens
- Cost: $0.9916738
- Wall-clock: 179s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
