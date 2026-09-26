Implemented and pushed commit `9405a69805` to `main2`.

- Added four bounded Wayback original-byte retries with exponential backoff.
- Cleared partial bodies and headers before each attempt, preserving fail-closed hashing and manifest behavior.
- Added recovery and exhaustion regression coverage.
- Verification: `fetch-source-test.sh` passed 89/89; `run-test.sh` passed 385/385; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fetch-source-transient-wayback-retries.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 252s

<!-- garden-usage-end -->
