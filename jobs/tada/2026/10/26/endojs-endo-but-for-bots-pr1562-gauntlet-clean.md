I added coverage tests for PR #1562 and pushed them, but CI didn't reach a final state within the hour (rc 4). Several legs are already red, all from runner-image problems that would fail any PR touching these packages, not from this PR's code or my tests.

**Coverage pass.** The PR's new code had several paths no test ran. I pushed one commit, `474f468735`, with tests only and no source changes:
- **`exo-agent-factory`:**
  - New `test/inference-driver.test.js`: the driver loop was never loaded by any test before. It now covers skipping non-package and unfinished messages, the limit and model settings from the environment, the replies for ok and failed results, and the default limits.
  - Additions to `adapters.test.js`: the spawner revoking a child's namespace when an endowment uses the reserved name or creation fails, and the adapter passing its environment to the driver.
  - The new source files now have every line covered.
- **`claude`:** new `test/agent-driver-maker.test.js` for the CLI and SDK makers, which had no tests.
- **`fae`:** tests for the `authSecret` path, `help()`, and the reserved `subagent-spawner` name. Both new files are now at 100%.
- **`lal`:** a test that the `driver.js` facet is still returned when the agent lookup fails. The one uncovered line calls into existing code.
- **Checks:** prettier and eslint pass, with no errors and one warning in code that was already there. The repo-root `tsc -p tsconfig.json` type-check passes. I found no dead code left behind by the change.

**CI at head `474f468735`.** `ci-wait-merge.sh` timed out at 3600s with 1 of 35 checks still running (`test (22.x, macos-15)`). These checks are already red:
- **`build`** (Test project mutual dependency versions): fails with `tred: command not found`. The Ubuntu 26.04 runner's graphviz package no longer includes `tred`. Draft PR endojs/endo-but-for-bots#1546 fixes this by pinning the job to `ubuntu-24.04`, but it hasn't landed on `llm` yet. The same failure shows on every PR in the exo-agent-factory stack.
- **`sandbox-drivers`, both `cover` legs, and `test (22.x / 24.x, ubuntu-latest)`:** only `packages/sandbox` fails, in its bwrap tests (`ulimit: Illegal option -u` under dash on 26.04). The `fix/sandbox-ubuntu-2604-bwrap-tests` branch exists for this.
- **`test (24.x, macos-15)`:** `packages/floot` fails. This PR doesn't touch it, so it is likely a flake.

**What happens next:** the next run of this stage will likely see red (rc 3) and halt the gauntlet. It can only go green once #1546 and the sandbox fix land on `llm` and this stack is woven onto the new base.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1562-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 128 tokens (6154030 cached reads)
- Output: 25174 tokens
- Cost: $2.840318
- Wall-clock: 4017s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
