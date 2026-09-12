Updated `gardener.sh` so cycle-1 exit-0-unsatisfying retries remain local and journal-silent, while cycle-2 repeats and near-doom retries still publish progress.

Added regression coverage for silent cycle 1, repeated cycle 2, and low-threshold near-doom escalation.

Verified:
- `completion-signal-test.sh`: 31 passed, 0 failed
- `tests/checks/run.sh`: 10 suites passed
- Bash syntax and diff checks passed

Committed and pushed to `main2` as `a031b56440`.
Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gardener-silent-exit0-retries.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 185s

<!-- garden-usage-end -->
