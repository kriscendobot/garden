Implemented and pushed commit `837f031ccb32` to `main2`.

- Replaced capped marker discovery with complete GitHub API pagination.
- Preserved targeted head-branch lookup and duplicate-PR safeguards.
- Added regression coverage for repositories with more than 200 open PRs.
- `ensure-pr-test.sh`: 32/32 checks passed.
- Live `gh api --paginate --slurp` response-shape check passed.
- Full suite: 378 passed, 1 unrelated issue-inbox assertion failed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-pr-head-lookup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 318s

<!-- garden-usage-end -->
