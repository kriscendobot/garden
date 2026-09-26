Implemented and pushed commit `a2320a7b42` to `main2`.

- Added trailing-median per-role cost projection using billable-token ledgers.
- Derived paced wakes from calibrated budget headroom and reset epoch, clamped to cadence floor/ceiling and telemetry freshness.
- Added fail-open cadence with deduplicated warnings for absent/stale inputs.
- Added immediate watched-event preemption and durable decision-ledger records.
- Added deterministic projection, fallback, warning-deduplication, and event-preemption tests to deploy gates.

Verified: pacing tests 5/5, triager tests 133/133, deploy tests 133/133; Bash syntax, ShellCheck, and diff checks passed. The broader checks suite was stopped when an unrelated state-clone-keeper test hung.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cybernetics-triager-pacing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 973s

<!-- garden-usage-end -->
