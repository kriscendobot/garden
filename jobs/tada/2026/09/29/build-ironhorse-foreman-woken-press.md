---
handed-off: activate-ironhorse-ratchet-autopilot-20260929-r4
deliverable-complete: false
---
Implemented and pushed commit `9bf25f4362f` to `main2`.

- Added fail-closed `not_before` scheduling, rolling per-arc ledger-derived token budgets, foreman-only promotion, decision logging, and atomic/idempotent Ironhorse successor creation.
- Added budget/configuration, seeding, and legacy-schedule retirement tools.
- Updated Ironhorse watcher gates, documentation, and issue #51. No budget was guessed; maintainer input remains pending.
- Passed all relevant suites, including the new 11-case press/budget suite.
- Leader deployment verification, legacy schedule retirement, budget application, and first seed are durably handed to `activate-ironhorse-ratchet-autopilot-20260929-r4`.
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-foreman-woken-press.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1242s

<!-- garden-usage-end -->
