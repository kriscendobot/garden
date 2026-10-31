Clean stage for PR #1586: no changes were needed, and CI is green at the current head.

I did not run a separate coverage pass or look for orphaned dead code. The PR already had green `cover (22.x/24.x)` jobs when I checked, so I treated the stage as a no-op and only watched CI. I pushed nothing.

`ci-wait-merge.sh` was killed at the 10-minute background limit before it reported a result. I then polled the PR's checks directly for about an hour. The last open checks were the two macos-15 test legs, which ended green. Every other check was a success or skipped. The final check came back with no failing or pending entries.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 96 tokens (2714233 cached reads)
- Output: 14102 tokens
- Cost: $1.4988348
- Wall-clock: 12189s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
