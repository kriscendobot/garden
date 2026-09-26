Implemented and pushed commit `68b98daa9c` to `main2`.

- Recognizes GitHub’s “API rate limit already exceeded” wording as primary-quota exhaustion.
- Mirror closer now captures handler stderr, leaves mappings unresolved, and exits 0 in a quota-only degraded state; non-quota failures still exit 1.
- Added regression coverage preserving secondary-rate-limit and HTTP 429 retry behavior.
- Verified: `gh-api-retry-test.sh` (48 passed), `mirror-closer-test.sh --no-e2e` (36 passed), full `run-test.sh` suite (379 passed).
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mirror-closer-gh-primary-ratelimit-already.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 364s

<!-- garden-usage-end -->
