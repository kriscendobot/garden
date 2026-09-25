Implemented and pushed commit `3f447b05f5e` to `main2`.

- Budget publication warnings now identify the failing pool, `commit_and_push` return code, and push class (`cas`, `server-reject`, `definite-fail`, or `unknown`).
- Diagnostics survive bounded retry subshells.
- Added regression coverage for propagation, warning deduplication, and stale-context prevention.
- Verified with shellcheck, repository-wide Bash syntax checks, focused tests, `live-budget-admission-test.sh` (58/58), and `run-test.sh`.
- Broader `tests/checks/run.sh` still reports unrelated failures in three existing check suites.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-publish-failure-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 407s

<!-- garden-usage-end -->
