## Shepherd report: endojs/endo-but-for-bots#1572 is red because of the CI runner, not the PR

**Result:** CI is still red. Nothing in the PR's diff can fix it, so I escalated to the maintainer. I pushed nothing.

**What's failing:** `sandbox-drivers`, `cover (22/24, ubuntu)` and `test (22/24, ubuntu)` all fail on the same two `@endo/sandbox` bwrap tests:
- `prlimit nproc cap is enforced inside the slice`: on the Ubuntu 26.04 runner `/bin/sh` is dash, which rejects `ulimit -u`.
- `bwrap parent death leaves no owned process group`: the test finishes without running any assertions.

The PR doesn't touch `@endo/sandbox`. Its own packages passed in the same CI job (on the 22.x leg): `@endo/daemon` 1611 tests, `@endo/exo-git` 59, `@endo/git` 36, `@endo/cli` 39. The macOS legs passed too.

**What I did:**
- Read the failed-job logs from run 40374368054, the 2026-10-26 run on head `15507c93bf`.
- Reran the failed jobs (`gh run rerun --failed`). On attempt 2 on 2026-10-31, `sandbox-drivers` and `cover` failed with the same two tests. These failures are deterministic, not a flake. The `test (ubuntu)` legs were still running when I stopped. They run the same suite, so I expect the same result.
- Checked the fix: draft endojs/endo-but-for-bots#1566 fixes exactly this, and its CI is green. Its gauntlet halted on 2026-10-28 because it overlaps endojs/endo-but-for-bots#1542 (the bwrap fix) and endojs/endo-but-for-bots#1546 (the depcheck fix). None of the three has merged. The maintainer has already seen the halt notices, and endojs/endo-but-for-bots#1573's shepherd escalated the same blocker.
- Did not copy the CI fix into #1572, because it would put unrelated changes in a feature PR.
- Sent a message to the maintainer inbox (`msg-endojs-endo-but-for-bots-pr1572-shepherd-1028c5e5a887`). It adds the M3 stack (endojs/endo-but-for-bots#1571 → #1572) to the decision already pending.

**Classification:** `next: liaison`. The maintainer needs to pick which fix lands: either #1566, or #1542 and #1546 together. Once one has merged, say `weave endojs/endo-but-for-bots#1571` and then `weave endojs/endo-but-for-bots#1572`. CI should then go green; if it doesn't, run one more shepherd job.

**Follow-ups:**
- The open choice between #1566 and #1542 + #1546 now blocks at least three stacks: the M3 child-agent-factory stack, the API-key provider stack (#1573/#1575), and this M3 git stack. Making that choice is the one action that unblocks all of them.
- I didn't comment on the PR because the job didn't authorize it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1572-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2010996 cached reads)
- Output: 9316 tokens
- Cost: $1.2098072
- Wall-clock: 1263s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
