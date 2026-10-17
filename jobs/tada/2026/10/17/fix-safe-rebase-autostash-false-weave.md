## Completion report: fix-safe-rebase-autostash-false-weave

`safe-rebase.sh` no longer lets the host's inherited git config change its result, and a rebase that stops without any conflicted paths is now reported as a tooling error instead of needs-weave. The fix is on `main2` as b28049245bb; the new tests pass, and both new cases fail against the old script.

**Root cause.** I could not get `rebase.autostash=true` by itself to fail this rebase. Using the real #194 commits (`bf3d844` onto `3d161b9ef1f`) and the host's full inherited config, the rebase is clean whenever a committer identity is set. With **no `user.email`**, it stops after the first pick, leaves those changes staged, and lists **zero conflicted paths**. That matches the evidence: the paths named in the "would be overwritten" error belong to the first commit. The script then reported "non-deterministic conflict" with an empty list, and ci-wait-merge called it needs-weave. The fix covers both causes.

**Changes to `scripts/jobs/gardening/safe-rebase.sh`:**
- **Hermetic git:** every rebase-side git command runs with the global and system config ignored, plus `-c rebase.autostash=false -c rebase.autosquash=false -c rerere.enabled=false`. The committer identity is read from the inherited config first and passed with `-c`, so it isn't lost. The base `fetch` still uses the inherited config, because remote auth and URL rewrites can live there. `GARDEN_INHERIT_GITCONFIG=1` turns this off, matching `hermetic_gitconfig`.
- **Rebase stopped with zero conflicted paths:** the script aborts and exits 1 (operational error), never 3 (needs-weave). Callers already map exit 1 to `reason=operational-error`.
- **A second bug found while fixing this:** a `git rebase` that failed without leaving a rebase in progress used to fall through and print "rebased" with exit 0. It now exits 1.

**Changes to `scripts/jobs/test/safe-rebase-test.sh`:**
- **Case 6:** a `GIT_CONFIG_GLOBAL` with autostash, autosquash, rerere, `backend=apply` and `apply.whitespace=error`. That combination reliably breaks a bare rebase of the fixture, and the test checks this. `safe-rebase.sh` must still rebase cleanly and keep the identity, which is set only in that global file.
- **Case 7:** no committer identity anywhere must give exit 1, not "non-deterministic". It skips itself on a host that detects an identity automatically.

**Verification:**
- `safe-rebase-test.sh`: all 7 checks pass.
- `rebase-pr-before-merge-test.sh`: passes.
- `ci-wait-merge-test.sh`: 105 pass, 2 fail (T8). T8 fails the same way with the old `safe-rebase.sh`, so it was already failing before this change.

**Follow-ups:**
- Someone should look at the failing ci-wait-merge test T8 ("got rc=1 want 0, merge NOT called").
- minion.town#194's head has since moved to `f07b965`. The screener should re-post the conductor job, or `ci-wait-merge --screened-delegated-merge` can be re-run once this deploys. If that worktree really has no bot identity, it will now fail as `operational-error` rather than needs-weave.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-safe-rebase-autostash-false-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1633887 cached reads)
- Output: 13965 tokens
- Cost: $1.1770534000000001
- Wall-clock: 209s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
