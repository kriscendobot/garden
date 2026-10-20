Implemented and pushed commit `e2d0a90b598` to `main2`.

- Scoped mirror state-read quota failures to the GraphQL cooldown latch.
- Preserved the all-API latch for REST close-handler failures.
- Added regression coverage proving GraphQL cooldown does not suppress REST watchers.
- Verified: mirror-closer tests 86/86; API cooldown tests 32/32; Bash syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-closer-graphql-cooldown-scope.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 205s

<!-- garden-usage-end -->
