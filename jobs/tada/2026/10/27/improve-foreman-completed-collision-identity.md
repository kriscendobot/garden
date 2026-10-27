Implemented and pushed commit `9e45ede85f5` to `main2`.

- Added deterministic foreman decision identities derived from normalized milestone context and proposal metadata.
- Fresh recurrences can reuse old completed basenames; unchanged decisions remain idempotent.
- Preserved one-reprompt handling for duplicate and malformed proposals.
- Updated handler guidance and regression coverage.
- Verified all foreman tests pass (114 assertions), including the focused 7-case recurrence suite.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-completed-collision-identity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 397s

<!-- garden-usage-end -->
