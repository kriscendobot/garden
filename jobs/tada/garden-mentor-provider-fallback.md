Implemented and pushed `bcba5f0b40` to `main2`.

- Mentor now uses availability-aware OpenAI → local → Claude fallback, with strict fail-closed JOB parsing and stable identities.
- Added provider fallback regressions and updated operations docs.
- Verified: `bash scripts/jobs/test/mentor-provider-order-test.sh` (8 passed).

Follow-up: deliberate garden deploy is required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-mentor-provider-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 399s

<!-- garden-usage-end -->
