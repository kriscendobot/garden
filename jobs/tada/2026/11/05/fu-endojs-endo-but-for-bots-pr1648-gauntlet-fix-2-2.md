The two red macOS legs on PR #1648 passed on rerun, and every check on the PR is now green. I did not change the PR diff.

- **What failed:** run 41966267381 had two red legs, `test (22.x, macos-15)` and `test (24.x, macos-15)`. Both failed only on "Uncaught exception in test/restore-context.test.js … exited with a non-zero exit code: 1". That matches the known cross-PR macOS flake. The other `CapTP … exception` lines in the log came from tests that passed.
- **What I did:** ran `gh run rerun 41966267381 --failed`. On attempt 2, both macOS legs and the run as a whole succeeded.
- **Current state:** the PR head is still `28980e08bf2e2e448adc11cdd849058253477dcd`, with no failing or pending checks. The PR is still a draft; the rest of the gauntlet decides when to un-draft it.

No garden commits and no follow-ups were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1648-gauntlet-fix-2-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (644404 cached reads)
- Output: 2631 tokens
- Cost: $0.5837168
- Wall-clock: 2509s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
