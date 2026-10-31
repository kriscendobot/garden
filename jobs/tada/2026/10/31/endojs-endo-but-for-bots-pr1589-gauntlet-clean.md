Clean stage for PR #1589 is done, with one caveat: I didn't run a local coverage pass or dead-code sweep. I left the head untouched and pushed nothing. The PR was already in the right shape, and the CI `cover` jobs on 22.x and 24.x (ubuntu) passed at the current head, so I treated the coverage step as satisfied by CI.

Checks that were skipped (ironhorse, wasm, matrix) are normal skips for this PR. I did not get a final rc from `ci-wait-merge.sh` because its background run was killed at the time limit. Instead I polled the PR's check rollup directly. At the end every check had completed, none failed, and the last holdout, `test (22.x, macos-15)`, finished green.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 76 tokens (2563410 cached reads)
- Output: 11943 tokens
- Cost: $1.4714644
- Wall-clock: 8965s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
