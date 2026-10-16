Implemented and pushed commit `a130d814da0` to `main2`.

Changed deadmail promotion to use a five-second soft producer clone-lock wait. Exit 75 now quietly defers the tick while retaining dead letters; genuine timeouts remain warnings.

Verification: focused deadmail tests passed all four cases, including real lock contention completing in one second with all three letters retained and no warning. Shellcheck and repository-wide Bash syntax checks passed. The broader job suite exposed unrelated existing scaler/follow-up failures.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadmail-producer-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 465s

<!-- garden-usage-end -->
