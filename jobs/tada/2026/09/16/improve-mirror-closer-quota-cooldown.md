Implemented and pushed commit `a197ac8b1d` to `main2`.

- Persisted a one-hour GitHub primary-quota cooldown after the first refusal.
- Subsequent timer ticks skip all GraphQL calls until expiry.
- Unresolved mappings remain intact and retry after cooldown.
- Added regression coverage for persistence, zero calls during cooldown, expiry cleanup, and post-expiry retries.
- Verification: `mirror-closer-test.sh --no-e2e` passed 53/53; syntax and diff checks passed. Live GitHub E2E was not run.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-closer-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 233s

<!-- garden-usage-end -->
