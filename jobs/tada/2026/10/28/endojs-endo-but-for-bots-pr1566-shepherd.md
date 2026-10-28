CI on endojs/endo-but-for-bots PR #1566 is green on the new head `2696934af6`: all 17 checks pass and 18 are skipped. The PR is still a draft and still mergeable.

**What was failing:** the only red check on the woven head `12e3bfb6c3` was `sandbox-drivers`. One test, `bwrap timeout and repeated cancellation reap process groups` (inherited from the base, not this PR's diff), failed in one of its repeated runs with "process group 7714 survived bounded cleanup". It passed in the other repetitions and on the PR's previous run, so it's a timing flake, not a containment escape. My best explanation, worked out from how bwrap and the kernel behave because I couldn't reproduce it here (no bwrap in this container): Node sees the bwrap leader exit while bwrap's pid-namespace init is still in the leader's process group. The kernel has to kill everything in the namespace and tear down its mount namespace first. The init then stays a zombie until the host reaps it. With the podman tests running at the same time, that took longer than the test's 3s limit.

**What changed:** one test-only commit to `packages/sandbox/test/bwrap.test.js`:
- **Longer wait:** `waitForProcessGroupGone` now waits up to 10s instead of 3s.
- **Matching timeouts:** the four tests that call it have their test timeouts raised (10s→20s ×3, 15s→30s).
- **Better failure message:** if it fails again, the error lists the processes still in the group and their state from `/proc`. That shows whether it was a slow teardown or a real escape.

**Checks:** prettier, eslint and a TypeScript check of the file are clean. The bwrap tests skip locally, so the real check was CI: the `sandbox-drivers` run on the new head passed the test in every repetition (80 tests per run).

I posted a short explanation on the PR: https://github.com/endojs/endo-but-for-bots/pull/1566#issuecomment-6461506699

**Follow-ups:**
- The PR is still a draft. Its earlier gauntlet was halted, so un-drafting it or re-running the gauntlet to unblock the API-key provider stack needs the maintainer.
- If this test fails again even with the 10s limit, the new message's process states will show whether the fix should go into the driver itself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1566-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2455588 cached reads)
- Output: 15722 tokens
- Cost: $1.5239975999999995
- Wall-clock: 1016s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
