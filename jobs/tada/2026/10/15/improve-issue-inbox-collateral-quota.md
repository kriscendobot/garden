Implemented and pushed commit `0bb399c2284` to `main2`.

- Detects collateral host-shared `gh-api` admission refusals before latch adoption.
- Freezes the issue-inbox cursor and exits silently, preserving the original cooldown and warning owner.
- Added regression coverage for a latch owned by a different REST source.
- Verified: issue-inbox watcher tests (71 passed), API cooldown tests (32 passed), tick-bound tests (23 passed), syntax and diff checks.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-collateral-quota.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 177s

<!-- garden-usage-end -->
