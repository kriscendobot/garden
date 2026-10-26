---
orchestration-failed: true
---
orchestration-failed — CI is red at the new head (`ci-wait-merge` rc 3), so I'm not marking clean done. None of the failures come from this PR's package (`exo-agent-factory`); they also show up on the base PR and across the repo's other open PRs.

**Coverage pass (done and pushed)**
- **Gaps found:** I measured coverage of `packages/exo-agent-factory` with V8 coverage (c8 isn't installed in the worktree). Only `turn-ledger.js` had untested code:
  - every result type except `ok` in `stringsForInferResult`, plus its throw for an unknown type;
  - the checks that reject a bad message number, a negative key, a forged result record and a malformed cursor;
  - the defaults when no instructions, model or message strings are given;
  - the two places `run` stops early when the agent is no longer active.
  The example module was already fully covered. No code was left unused by the change.
- **Tests added:** commit `6eac64112d`, "test(exo-agent-factory): cover turn-ledger result rendering and fail-closed paths", adds 7 tests to `test/turn-ledger.test.js`. They also check that one failed turn doesn't jam the queue for later turns, that the cursor never moves backwards, and that `run` skips its own messages. Every line and branch of `turn-ledger.js` is now covered.
- **Local checks:** the package's ava run passes (34/34), and eslint, the package's `tsc` and the repo-root `tsc -p tsconfig.json` (checkJs) are all clean.
- **Push:** `safe-push-pr-head.sh` fast-forwarded `build/exo-agent-factory-turn-ledger` from `1762c1beff` to `6eac64112d`.

**CI at `6eac64112d`: red**
- **`build`:** fails at "Check for cycles" with `scripts/graph.sh: tred: command not found` (exit 127). The runner image is missing `tred`.
- **`sandbox-drivers`, both `cover` legs, `test (22.x, ubuntu)` and `test (24.x, ubuntu)`:** all fail in `packages/sandbox` bwrap tests. The main ones are "prlimit nproc cap is enforced inside the slice" (`/bin/sh: ulimit: Illegal option -u`) and "bwrap parent death leaves no owned process group"; `sandbox-drivers` also failed "bwrap timeout and repeated cancellation reap process groups".
- **`test (24.x, macos-15)`:** fails in `packages/floot` `test/factory-system-prompt.test.js`. Nothing in this PR touches that package. The base head also failed this leg, but I didn't confirm it was the same test.
- **Not caused by this PR:** base PR #1560 (head `8c4a87e9da`) fails the same `build`, `sandbox-drivers`, `cover` and `test` legs with the same bwrap/tred errors. The `build` and `sandbox-drivers` failures also appear on #1549, #1553, #1555, #1557 and #1559–#1562. `llm`'s own tip skipped these jobs.

**Follow-ups**
- Fixing the shared CI is a separate job: install `tred` (graphviz) on the runner, and make the bwrap prlimit test use bash or skip `ulimit -u` when `/bin/sh` is dash. Until then, no gauntlet on a PR that runs these jobs can pass the clean stage.
- After that fix lands, re-run this stage. The coverage commit is already on the PR, so the re-run only needs to confirm CI is green.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1563-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3278745 cached reads)
- Output: 16318 tokens
- Cost: $1.6897649999999995
- Wall-clock: 3850s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
