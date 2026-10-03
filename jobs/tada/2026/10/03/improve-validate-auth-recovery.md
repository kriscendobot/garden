Implemented and pushed commit `3db86d59576` to `main2`.

- Added a bounded `claude auth status --json` validation before clearing Claude `auth-failure` markers.
- Changed-but-invalid credentials now remain parked without a false recovery notice.
- Added hermetic regression coverage and isolated tests from live usage data.
- Verification: `worker-health-gate-test.sh` passed all 67 cases. Bash syntax and diff checks passed.
- Follow-up: `backend-autotune-test.sh` still has two unrelated pre-existing gardener-kind failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-validate-auth-recovery.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 565s

<!-- garden-usage-end -->
