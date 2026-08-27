Implemented and pushed commit `da19aa7daa` to `main2`.

- Deadmail now recognizes issue spines and emits `kind: issue-follow-up` with canonical issue URL metadata.
- Issue framing explicitly forbids PR-state, review, checks, mergeability, and merge-action assumptions.
- Original ISSUE NOTE remains preserved verbatim.
- Added regression coverage for typing, canonical URLs, framing, and idempotency.
- Verification: syntax checks passed; schedule/deadmail suite passed 11/11; full suite passed 378/379. The sole failure is an unrelated existing issue-source error-classification expectation.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-deadmail-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 405s

<!-- garden-usage-end -->
