Completed and pushed commit `401b0ccc55` to `main2`.

- Corrected the premise: 87/444 records had generic `disposition: error`; only 14 had all seats marked error.
- Established that 12 of 14 were panel interruption artifacts following `exit-0-unsatisfying` supervisor exits. The proposed chain was reversed: handler termination interrupted the panel, then the recorder mislabeled pending seats.
- Identified PR #893 as a separate shared-quota incident; PR #867 remains unclassifiable due to missing logs.
- Added the durable diagnosis in `designs/panel-seat-error-rate-diagnosis.md`.
- Panel records now preserve exit codes and classify signaled panels and pending seats as `interrupted`.
- Verified 74 panel tests and all pre-push checks passed.
- Withdrew the incorrect budget-overrun follow-up and parked `make-panel-stage-survive-supervisor-session-exit`.

Self-improvement: Recomputing the exact seat-vector predicate exposed the denominator error before extending a speculative diagnosis.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/diagnose-panel-seat-error-rate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (1 unmetered)
- Input: 78 tokens (3924747 cached reads)
- Output: 48381 tokens
- Cost: $5.0364485000000005 (1 engagement(s) unpriced)
- Wall-clock: 2458s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
