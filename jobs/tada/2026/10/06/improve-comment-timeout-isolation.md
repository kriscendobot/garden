Implemented and pushed commit `79bca08dd84` to `main2`.

- Isolated timeout backoff per repository slug.
- Shared cooldown now opens only for positively identified network/API or quota failures.
- Added timeout heartbeat handling and regression coverage.
- Verified: comment watcher 468/468, API cooldown 22/22, latency watcher PASS, shell syntax/lint and diff checks PASS.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-timeout-isolation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1064s

<!-- garden-usage-end -->
