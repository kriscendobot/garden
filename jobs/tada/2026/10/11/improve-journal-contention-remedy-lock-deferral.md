Implemented and pushed commit `29ff9e9bf9c` to `origin/main2`.

- Added durable per-clone live-lock remedy backoff with deterministic expiry retries.
- Suppressed expected optional soft-lock warnings and self-generated contention telemetry.
- Added regression coverage for deferral, quiet backoff, and expiry recovery.
- Verified with syntax checks, `git diff --check`, ShellCheck, and the passing journal contention test suite.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-contention-remedy-lock-deferral.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 191s

<!-- garden-usage-end -->
