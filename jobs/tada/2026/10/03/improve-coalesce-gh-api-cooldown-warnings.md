Implemented and pushed commit `6bd54f002cf` to `main2`.

- Added per-latch warning-emission markers so only the latch owner or first suppressed caller warns.
- Later suppressed callers remain quiet and return nonzero status.
- Added concurrent suppression coverage.
- Verified `gh-api-retry-test.sh`: 61 passed.
- Verified `api-cooldown-test.sh`: 22 passed.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-coalesce-gh-api-cooldown-warnings.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 291s

<!-- garden-usage-end -->
