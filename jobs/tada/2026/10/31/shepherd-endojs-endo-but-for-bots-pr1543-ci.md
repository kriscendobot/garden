PR #1543 is now green: all 36 checks pass on head `2866a26dbf`. I didn't change any code. The fix was rerunning the failed job, which took two tries.

**What was failing:** `cover (24.x, ubuntu-latest)` in CI run 41171352922. One test failed: `@endo/sandbox` › `bwrap timeout and repeated cancellation reap process groups`, with `process group N survived bounded cleanup` (`packages/sandbox/test/bwrap.test.js:1099`). Turbo then stopped with `Failed: @endo/sandbox#test:c8`.

**Why it isn't this PR's fault:**
- The PR is 8 commits ahead of frozen base `llm-9a14ddf` and 0 behind. Its diff is only five files under `designs/`, so the sandbox code it tests is the same as the base's.
- The base commit passed `cover (24.x)` in its own CI.
- Other PRs on the same base and the same `ubuntu-26.04` runner image passed this test (#1585, #1501).
- The same failure shows up across PRs and on `llm` itself. I found it in 7 of the last 15 failed CI runs, including two `llm` pushes on 2026-10-28 and branches for #1566 and #1571. Earlier shepherd jobs for #1560 and #1501 also cleared it by rerunning.
- The test gives the process group 3 seconds to exit after it's killed. That can run out on a slow runner, especially when the podman tests run at the same time.

**What I did:**
1. Ran `gh run rerun 41171352922 --failed`. It failed again on the same test.
2. Ran it a second time. `cover (24.x)` passed.

No commits, pushes or PR comments.

**Follow-ups:**
- Draft PR #1566 (`fix/ci-runner-bwrap-and-graphviz`) raises the 3-second limit to 10 seconds, and its checks are currently green. Landing it would stop this failure from hitting other PRs.
- #1543 can go back to its gauntlet or review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1543-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2640897 cached reads)
- Output: 8926 tokens
- Cost: $1.4479554
- Wall-clock: 2832s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
