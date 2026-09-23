Implemented and pushed commit `0fcdcafe90` to `main2`.

- Proxy questions are now processed independently.
- Deterministic malformed-reference rejections quarantine only the affected question, advance its seen marker, and post one idempotent, actionable maintainer notice.
- Other questions continue within the same tick; non-reference handler failures remain retryable.
- Added regression coverage proving quarantine, continued processing, and notice deduplication.
- Relevant proxy tests passed, including the new 4 assertions and companion qualified-reply suite (14/14). Full suite reached 376/377; the lone failure was an unrelated issue-inbox fixture. A separate proxy parking suite had one unrelated reaper-state expectation failure.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-proxy-malformed-reference-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 367s

<!-- garden-usage-end -->
