PR #1335 is still red, and this PR can't make it green. Every failing job is caused by the `@endo/sandbox` bwrap tests in the runner environment, not by this PR's changes. I re-requested review from kriskowal anyway; the job's gate was "green first", so that was my call on a red PR.

**What fails** (CI run 41804897520, head `d2c0bf31`):
- All failures in `test (22.x/24.x)`, `cover (22.x/24.x)` and `sandbox-drivers` are `@endo/sandbox` bwrap tests:
  - `prlimit nproc cap is enforced inside the slice` fails with `/bin/sh: ulimit: Illegal option -u`.
  - `bwrap parent death leaves no owned process group` fails, plus a few timeout and output-cap reaping cases.
- I re-ran the failed jobs once and they failed the same way, so rerunning more won't help.

**Why it isn't this PR's fault:**
- The PR only changes `packages/daemon` plus a changeset and docs, and every `@endo/daemon` test passes.
- Open PRs #1649, #1637 and #1621 fail `sandbox-drivers` the same way.
- Fixes are in open, unmerged PRs: #1566 (makes the bwrap tests portable across runners), #1542 and #1591.

**Actions taken:**
- Posted the classification on the PR: https://github.com/endojs/endo-but-for-bots/pull/1335#issuecomment-6634521106
- Re-requested review from kriskowal; the reviewer list now shows `kriskowal`. The reply to review 5764182424 was already posted before this job.

**Follow-ups:**
- Merge #1566, or #1542 / #1591. After that, a weave (or a rebased base branch) will pick up the fix. Note that this PR's base is the stacked branch `build/guest-locator-adoption-11e726e`, so it won't inherit the fix automatically.
- The PR is still a draft, and its review status is CHANGES_REQUESTED until kriskowal looks again.

No garden-repo changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1335-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (577515 cached reads)
- Output: 3976 tokens
- Cost: $0.645767
- Wall-clock: 568s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
