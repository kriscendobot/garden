Implemented and pushed commit `ba8c2dc529` to `main2`.

- Added a durable terminal-handler-failure marker before diagnostic reporting.
- Reaper now promptly retries these claims, preserves deterministic classification, advances bounded doom retries, and removes the one-cycle marker.
- Added the regression to the deployment gate.
- Verified new regression: 6/6 passed; deployment suite: 131/131 passed; relevant classifier/reaper tests passed.
- Follow-up: existing `proxy-park-body-hygiene-test.sh` has one unrelated baseline failure.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reap-terminal-handler-failures.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 434s

<!-- garden-usage-end -->
