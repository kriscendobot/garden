PR #1542 fix round 3 is done: I applied the panel's must-fix items, pushed three commits to the PR head (`fc8aad7ddd` → `77845960f9`), and CI is green (34 checks, 0 failed). bwrap isn't installed on this host, so the tests that use real bwrap only ran in CI. Locally they skipped.

**Fixes in `packages/sandbox/src/drivers/bwrap.js`**
- **Killing a reused PID** (locksmith, breaker, purist, wire-watcher, engine-realist): before killing the sandbox init, the driver now pauses the bwrap launcher with SIGSTOP. The launcher is the only process that can reap the init, so while it is paused the init's PID can't be freed and reused. The driver waits until `/proc` shows the launcher stopped (state `T`, capped at 100ms). It sends SIGKILL to the init only if the init is still that launcher's child. Otherwise it falls back to signalling the process group only. The launcher always gets SIGCONT afterwards. Kill attempts run one at a time, and the init is killed at most once.
- **Close deadline vs. info wait** (breaker, engine-realist, corner-prober): `stop()` now waits for the init report before starting the close grace. A launcher that never reports can no longer use up teardown's grace before the group signal is sent.
- **Over-wide catch** (saboteur): only `JSON.parse` is inside the `try`, and the record is validated outside it.

**Tests in `packages/sandbox/test/bwrap.test.js`**
- **Deterministic regression tests** (prover): three new tests run a fake launcher (a Node script standing in for bwrap) with the driver's real stdio and process group:
  - An init outside the launcher's process group is killed. This fails against the base branch `llm-d5ac419`.
  - A reported PID the launcher does not own is left alone. This fails against the previous head `fc8aad7`.
  - A launcher that never reports still tears down within its grace. This also fails against `fc8aad7`.
- The existing stress test that uses real bwrap now skips when host `/proc` can't be read (transplanter), and the identifiers the stylist flagged are spelled out.

**Other items**
- The changeset is rewritten as a release note for users (migrator, releaser).
- I posted the summary comment the scribe asked for: https://github.com/endojs/endo-but-for-bots/pull/1542#issuecomment-6380992287
- I did not add the `fast-check` property test (fast-checker, marked summary-fix). The new fixed-scenario tests cover what the timing loop only sampled, and the extra devDependency would also change `yarn.lock`. The comment explains this.

**Local checks:** the bwrap, child-process and factory test files pass (76 tests, every config). eslint, prettier, the package `tsc` and the repo-root `tsc -p tsconfig.json` are clean.

**Follow-ups:** none. The driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3984105 cached reads)
- Output: 35155 tokens
- Cost: $2.432889
- Wall-clock: 1665s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
