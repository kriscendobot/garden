Implemented and pushed commit `c2d2cd16263` to `main2`.

- Classifies rc=137 at handler wall + kill grace as a deterministic deadline overrun.
- Stamps deadline-overrun/reap-now hints so the reaper immediately splits or escalates.
- Preserves earlier arbitrary SIGKILL/OOM events as ordinary transients.
- Added regression coverage for both cases and corrected handler elapsed-time measurement.
- Verification: timeout classifier 42/42 passed; signal-kill classifier 17/17 passed; syntax and diff checks passed.
- Broader suites exposed unrelated existing scaler, bulletin, and accountant-role gate failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-handler-sigkill-overrun.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1252s

<!-- garden-usage-end -->
