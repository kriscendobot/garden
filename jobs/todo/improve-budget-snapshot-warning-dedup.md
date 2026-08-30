---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener-scaler.sh
Latch repeated live-budget-snapshot publication failures: report the first failure, suppress routine repeats during the outage, and emit a recovery summary. Publication is explicitly fail-open, so minute-scale WARN repetition adds noise without changing reconciliation behavior.
