# Shepherd report: endojs/endo-but-for-bots#1560

All 36 checks are now green on head `d8fb029efd0a6d678d5caa54bccf0ebdfa4934f6`. I re-ran the failed jobs once and did not push any code.

**What was failing:** both red jobs, `test (24.x, ubuntu-latest)` and `sandbox-drivers`, failed in run 41129366365 on the same single test. It is `@endo/sandbox` › `bwrap timeout and repeated cancellation reap process groups`, which failed with `process group N survived bounded cleanup`. On the Node 24 leg, turbo then stopped with `Failed: @endo/sandbox#test`. The other failure-looking lines in that log are `test.failing` tests behaving as expected, not real failures.

**Why it's not the PR's fault:**
- The PR only touches the new `packages/exo-agent-factory` package plus the workspace tsconfig and yarn.lock. It doesn't touch `@endo/sandbox`.
- The PR's own tests ran in that same job and all passed (`@endo/exo-agent-factory:test`, 23 tests).
- This is a known cross-PR flake. The bwrap process-group cleanup has a 3-second limit, and when the podman tests run alongside, cleanup can take longer on a CI runner. Draft PR #1566 (`fix/ci-runner-bwrap-and-graphviz`) fixes exactly this by raising the limit to 10 seconds, but it hasn't merged yet.

**What I did:**
- Ran `gh run rerun 41129366365 --failed` once.
- Waited for the results: `sandbox-drivers` passed at about 23:10Z, and `test (24.x, ubuntu-latest)` passed at about 00:00Z.

**Classification:** `next: none`. The failures were a known flake and cleared on a re-run. The draft can go back to the halted gauntlet.

**Follow-ups:**
- Landing #1566 would stop this flake from hitting other PRs.
- I didn't post a comment on the PR because the job didn't authorize one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-shepherd-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1519583 cached reads)
- Output: 5627 tokens
- Cost: $1.0805046
- Wall-clock: 3569s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
