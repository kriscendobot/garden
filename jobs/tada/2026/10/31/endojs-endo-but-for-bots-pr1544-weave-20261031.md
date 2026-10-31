I wove PR #1544 onto `llm-9a14ddf`, which is the current `llm` tip. The new head is `e67a802d9b`, pushed with `--force-with-lease`, and the PR's base field now points at `llm-9a14ddf`. GitHub reports it MERGEABLE and `assert-pinned-base.sh` passes. I did not wait for CI on the new head; that is left to whatever job is meant to fix the CI failures.

**What changed**
- **The dependency moved.** #1504 is still open and has been rewoven from `ee79556` to `17c61dd`, also on `llm-9a14ddf`. I rebuilt the stack the same way as before: a no-fast-forward merge of #1504's new head onto the new base (commit `34bac7ecea`), with this PR's own commits replayed on top.
- **Diff scope.** Compared with #1504's head, the PR now changes only its own 11 files: the `packages/claude` acceptance loop and provisioner, a changeset, `packages/daemon/test/shell.test.js`, and one line of `yarn.lock`.
- **PR body.** I updated the Stack section and the Phase 2 ledger line to point at `17c61dd8e409e4a8aba931b54ea6292b631c1c66`. I posted no comments.

**Two commits were dropped because #1504 now contains the same changes**
- `cf8c31960d` "fix(daemon): report sandbox environment shells" conflicted with #1504's `2f7d654166`. Both make the environment Shell's `inspect()` report `engine: 'sandbox'`. I kept #1504's version, so this PR doesn't re-edit #1504's files, and removed the extra `shellPolicy` constants. The commit was then empty and skipped.
- `93b2582e4a` "fix(shell): preserve timeout rejection across sandbox engine" ended up empty during the replay. #1504's new head already passes the caller's exact `timeoutMs` to the spawner and expects the rejection, using a `rejects` regex instead of `expectedError` in its tests. A reviewer may want to confirm this one.

**Tests (run locally)**
- `packages/claude`: all 181 tests pass, including both `git-tool-acceptance` tests (the full scripted Git loop and the refusal of a host-engine Shell). `yarn lint` shows 0 errors and 36 warnings.
- `packages/exo-shell`: 25 tests pass. `packages/daemon` `shell.test.js` and `environment.test.js`: 27 tests pass.
- The first run of the daemon-backed acceptance test failed for a reason in the worker setup, not in the PR. The warm cache gave the worktree a `better-sqlite3` compiled for Node ABI 137, but the only `node` on this host is v22 (ABI 127), and the native-module check had wrongly reported "ok". I copied the package to separate it from the shared cache, rebuilt it in this worktree only, and the tests then passed.

**Follow-ups**
- Fix the PR's CI failures on the new head; that was the purpose of this weave and is not done.
- The native-module check in `ensure-project-worktree.sh` passed a build that this host's node cannot load. It is worth investigating so other workers don't hit the same daemon startup failure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1544-weave-20261031.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1828207 cached reads)
- Output: 9771 tokens
- Cost: $1.1406854
- Wall-clock: 170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
