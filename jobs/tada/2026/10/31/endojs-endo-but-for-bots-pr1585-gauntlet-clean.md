The clean stage for PR #1585 was a no-op. CI is green at the current head, so I changed nothing and pushed nothing.

- **Coverage:** the `cover (22.x/24.x, ubuntu-latest)` jobs passed, and I saw no orphaned dead code. I did not run a separate local coverage pass.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with "total=38 failed=0 → CI GREEN". The PR is still a draft and open.
- **First wait:** my first `ci-wait-merge.sh` wait hit the background time limit and was killed. I checked the check list and re-ran the script, which then reported green.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1585-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 72 tokens (2053636 cached reads)
- Output: 12282 tokens
- Cost: $1.3989569000000002
- Wall-clock: 10472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
