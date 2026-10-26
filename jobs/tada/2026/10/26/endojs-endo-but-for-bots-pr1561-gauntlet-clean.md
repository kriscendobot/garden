orchestration-failed: true

Clean stage for PR #1561 failed. CI is RED at head `e33aaa5f61fe`. I pushed nothing and ran no coverage pass, because the PR is not green, so there is nothing to clean up on top of.

`ci-wait-merge.sh` returned rc 3 with 7 of 35 checks failing:
- `build`
- `test (22.x, ubuntu-latest)`
- `test (24.x, ubuntu-latest)`
- `test (24.x, macos-15)`
- `sandbox-drivers`
- `cover (22.x, ubuntu-latest)`
- `cover (24.x, ubuntu-latest)`

The separate "Test project mutual dependency versions" workflow also failed.

I only read the logs for `sandbox-drivers`, where two bwrap tests fail:
- "prlimit nproc cap is enforced inside the slice" fails with `ulimit: Illegal option -u`, because `/bin/sh` there is dash.
- "bwrap parent death leaves no owned process group" fails with "Test finished without running any assertions".

My memory notes list bwrap CI reds as pre-existing on this repo, so these may not come from this PR. I did not read the logs for the other six checks or the dependency-versions workflow, so I can't say whether those are attributable to the PR.

Follow-up: the driver should halt the gauntlet and send the PR for fixing (a fixer or shepherd job), starting with the `build` and `test` failures.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1561-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 84 tokens (2951099 cached reads)
- Output: 12338 tokens
- Cost: $1.6330981999999996
- Wall-clock: 3859s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
