Implemented and pushed commit `77f2bee9ce0` to `main2`.

- Added configurable `GARDEN_CI_ROLLUP_BUDGET` with a default of 10.
- Added a persistent per-repository fair cursor so deferred eligible PRs lead the next tick.
- Applied the hard budget across both normal scans and stale-shepherd revalidation.
- Added regression coverage for budget enforcement, cursor persistence, fair wraparound, and same-tick revalidation.
- Verification: `ci-watcher-test.sh` passed all 112 tests; Bash syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-rollup-quota-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 303s

<!-- garden-usage-end -->
