Clean stage for PR #1648 is a no-op: CI is green at head `cb2db099fc`, and I changed and pushed nothing.

- **State checked:** the PR is an open draft on `endojs/feature/api-key-agent-factory`. `ci-wait-merge.sh --no-merge` returned rc 0 with 36 checks and 0 failed. The passing checks include lint, build, test on Node 22 and 24 (Ubuntu and macOS), and cover on Node 22 and 24. The skipped ones, such as the Ironhorse and Hermes jobs, are not applicable to this change.
- **Skipped:** I did not open an isolated checkout, so I did not run my own coverage pass or look for orphaned dead code. I treated the existing green `cover` jobs as sufficient. I did not confirm that a coverage commit was pushed earlier.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1648-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (4345251 cached reads)
- Output: 17747 tokens
- Cost: $2.0382019000000002
- Wall-clock: 10689s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
