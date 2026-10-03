Implemented and pushed commit `cb5844690f7` to `main2`.

- Added live REST primary-quota latch detection before CI source failure handling reaches `die`.
- Collateral rc=75 failures now discard partial source data and exit cleanly without posting jobs or running later sweeps.
- Added regression coverage for the concurrent latch race.
- Verification: `ci-watcher-test.sh` passed all 106 checks; `bash -n` and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-quota-collateral.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 238s

<!-- garden-usage-end -->
