## Shepherd report: endojs/endo-but-for-bots#1504 (sandbox engine for the Shell capability)

PR #1504 now passes every check its own diff affects. The checks still red are caused by the Ubuntu 26.04 CI runner image, and other open PRs already fix them.

**What was breaking:** After the rebase onto `llm-d5ac419`, three daemon tests failed on every `test` leg:
- `endo › portable environment Shell crosses two daemon peers…`
- `endo › durable environment restores passively…`
- `environment › creation, inspect, and idle restoration remain passive`

They all failed with `In "inspect" method of (EnvironmentShell) … Must have missing properties ["engine"]`. The environment Shell came in from `llm` and returns the bare recipe policy from `inspect()`. This PR now requires every Shell's `inspect()` result to include `engine`, and the environment Shell's result didn't.

**Fix:** pushed one commit, `f867170aec` (`fix(daemon): report the sandbox engine from the environment Shell`), using `--force-with-lease` against the old head `0319ee96a8`.
- `packages/daemon/src/environment.js`: `inspect()` now returns `{ ...recipe.policy, engine: 'sandbox' }`. Its runner provides a confined environment, and inspecting still starts no native work.
- `packages/daemon/test/environment.test.js` and `packages/daemon/test/endo.test.js`: expectations updated to include `engine`.
- Before pushing, I ran `environment.test.js` (15 passed) and the two affected `endo.test.js` cases (passed) locally. Prettier is clean and eslint shows no errors.

**CI on `f867170aec`** ([run 40146014980](https://github.com/endojs/endo-but-for-bots/actions/runs/40146014980)):
- **Passing:** the three daemon tests on all `test` legs, both macOS legs, `lint`, the IronHorse oracle sanitizers, OCapN Guile interop, and the workflow security audit. The PR's new real-bwrap `shell-engine` tests all pass in `sandbox-drivers`.
- **Still red, unrelated to this PR's code:**
  - `sandbox-drivers`, `cover (22/24)` and `test (22/24, ubuntu-latest)` fail only on the bwrap tests (`prlimit nproc` with `ulimit: Illegal option -u`, `parent death`, `timeout and repeated cancellation`). Open #1542 fixes these.
  - `Test project mutual dependency versions / build` fails with `tred: command not found`. The Ubuntu 26.04 graphviz package no longer ships `tred`; open #1546 fixes this.
  - The first run also had an IronHorse oracle failure: a last-digit math mismatch in `stage3-math/054,055`. It passed on this run and has nothing to do with this diff.

I posted a summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1504#issuecomment-6391871624

**Follow-ups:**
- Once #1542 and #1546 land on the base, the remaining reds should clear after re-pinning the base.
- Not changed here, noted in the PR comment: `packages/hosted-agent/src/environment-runner.js` creates its Shell without `engine`, so that Shell's `inspect()` says `'host'` even though it runs in a podman sandbox.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `ee79556d4d81098800bfabcb2b42368e57138dd8`; this job presented `f867170aec06ff5023548462647f0e77c598ae44`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-shepherd-20261025.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (7612119 cached reads)
- Output: 23245 tokens
- Cost: $3.016107800000002
- Wall-clock: 4215s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
