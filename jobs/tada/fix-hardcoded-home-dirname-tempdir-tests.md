Implemented and pushed commit `ed289c9da5` to `main2`.

- Extracted writable, executable temp-base probing into `scripts/jobs/test/test-tmpdir.sh`.
- Updated `run-test.sh` and all seven affected standalone tests to use the helper.
- Verified all seven suites: 532 assertions passed, 0 failed.
- Verified `run-test.sh 2 2`: 385 passed, 0 failed.
- Verified relocated `HOME=/Users/dom/garden`; the selector chose `/var/tmp`, and the deploy-gate policy-refusal suite passed 5/5.
- Posted host-pinned follow-up `verify-policy-refusal-tempdir-oros-20260915` for verification on `oros-studio-garden-ce242c49`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-hardcoded-home-dirname-tempdir-tests.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 378s

<!-- garden-usage-end -->
