Implemented and pushed commit `c364bde3ad` to `main2`.

- Detects Git object-corruption diagnostics during fuzz checkout refresh.
- Quarantines the disposable project checkout with a timestamped name, recreates it, and retries provisioning once.
- Preserves the external corpus, findings, artifacts, and build state.
- Added regression coverage for quarantine, one-time retry, logging, and corpus preservation.
- Verification: `scripts/jobs/test/ironhorse-fuzz-test.sh` passed all 42 tests.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-recover-corrupt-fuzz-checkout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 223s

<!-- garden-usage-end -->
