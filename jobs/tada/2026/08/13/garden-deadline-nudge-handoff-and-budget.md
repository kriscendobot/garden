Implemented and pushed to `main2` in commits `f988fb1294` and `796e0f313c`.

- Added evidenced unfinished handoffs, stamped `handed-off:` and `deliverable-complete: false`.
- Expanded deadline nudges with job, attempt, campaign, and quota budget facts plus handoff/parking guidance.
- Added progress-aware reaping, explicit budget holds, fresh budget epochs, and automatic quota-refresh promotion.
- Added final checkpoint nudges, `progress.sh`, systemd wiring, documentation, and regression coverage.
- Tests passed: core suite 368/368, deadline nudge 43/43, completion signal 24/24, provider quota 7/7.
- Follow-up: calibrate the initial static role token budgets from ledger percentiles.
- Elapsed: 1691s of 7200s.

Self-improvement: integrated newly landed reset-aware provider quota markers during the rebase and updated the completion regression accordingly.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-deadline-nudge-handoff-and-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1680s

<!-- garden-usage-end -->
