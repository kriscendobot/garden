Fix round 5 for endojs/endo-but-for-bots PR #1595 is pushed, and CI is green (36 checks, 0 failed).

**What I fixed.** The two failing checks from the style pre-pass are fixed in one follow-up commit, `f59e241fa`. It goes on top of `dbcb13fc9` on `kriscendobot/endo-but-for-bots:build-daemon-git-remotes-interactive-provisioning` and was pushed with `safe-push-pr-head.sh`.
- **prefer-endo-primitives:** in `packages/cli/test/git-remote-command.test.js`, the two bare `Far` test doubles (`GitRemoteController`, `GitRemote`) are now `makeExo` objects. Each has an `M.interface` guard declaring that its method returns a promise. The import of `Far` from `@endo/far` is replaced with `@endo/exo` and `@endo/patterns`, which `packages/cli/package.json` already lists.
- **spell-out-identifiers:**
  - **`u061c`:** the check was reading the `\u061c` escapes inside regex literals as an identifier. I rewrote both spots so it no longer sees them: the control-character check is now `new RegExp('[...]')`, and the escaped credential-line assertion is now `t.true(output.includes(...))`. Both test the same thing as before.
  - **`numRuns`:** this is fast-check's own option name, so it can't be renamed. I added a `spell-out-exempt` marker with that reason to `packages/cli/test/git-remote-command.test.js` and `packages/daemon/test/formula-record.test.js`. Other files in the repo use the same marker for outside field names (for example `num_turns`).
- **Comment-length advisory:** this one was non-blocking and I left it alone. The 10-line block it flags in `packages/cli/src/commands/git-remote.js` is the JSDoc `@import` type list, not prose.

**Checks.**
- Both style checks now print `pass` on the diff.
- `git-remote-command.test.js`: 30 tests pass. `formula-record.test.js`: 15 tests pass.
- eslint reports nothing on either file.

**CI.** The final `ci-wait-merge.sh ... --no-merge` returned rc 0 at about 02:58Z. The full wait couldn't run as one command: twice the process was killed with SIGTERM (rc 143) partway through. I watched the rest with bounded foreground loops on `gh pr checks`, then ran a short `ci-wait-merge` at the end. Total wait was about 64 minutes, a little over the 3600s deadline, because the `test (22.x, macos-15)` job was slow.

**Follow-ups.**
- The first project checkout died at the 120s git limit. It worked with `GARDEN_REPO_GIT_TIMEOUT=900`, which is the known problem on oros-studio.
- The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1886269 cached reads)
- Output: 9848 tokens
- Cost: $1.0893658
- Wall-clock: 5320s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
