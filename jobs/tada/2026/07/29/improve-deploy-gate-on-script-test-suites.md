Implemented and pushed `7d041aa1f8` to `main2`.

- Added candidate-tree deploy gate: syntax-checks all tracked `scripts/**/*.sh` and runs two bounded classifier regressions before draining or swapping.
- Failures abort deployment, preserve the root tree, emit/report `kind:error`, and name failed suites.
- Added bounded per-suite/total limits and `GARDEN_DEPLOY_TEST_OVERRIDE=1` emergency bypass.
- Extended deploy regression coverage for a failed candidate gate.

Verified: all script syntax checks; `deploy-garden-test.sh` (85 passed).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-gate-on-script-test-suites.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 306s

<!-- garden-usage-end -->
