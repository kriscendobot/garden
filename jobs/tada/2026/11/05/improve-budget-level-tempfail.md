Implemented and pushed commit `2c082b9acbc` to `main2`.

- Exit 75 from worker actuation now retains the target for retry and is classified distinctly in the decision ledger.
- Repeated transient diagnostics are edge-latched; recovery reports suppressed repeats.
- Updated regression coverage and stale worker-kind assertions.
- Verified: live budget admission (64/64), proportional leveling (10/10), and snapshot warning dedup tests pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-tempfail.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 394s

<!-- garden-usage-end -->
