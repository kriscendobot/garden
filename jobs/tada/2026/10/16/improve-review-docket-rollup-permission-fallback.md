Implemented permission-aware review-docket fallback for GraphQL `statusCheckRollup` 403s. Trusted PR head/state/review metadata is preserved, while CI is derived from Actions runs for the exact head.

Added and CI-wired a regression test. Passed:

- `review-docket-pr-gh-test.sh`
- `review-docket-test.sh`
- `bash -n`, ShellCheck, and `git diff --check`

Pushed commit `b8abbe64412` to `origin/main2`. No follow-ups required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-rollup-permission-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 200s

<!-- garden-usage-end -->
