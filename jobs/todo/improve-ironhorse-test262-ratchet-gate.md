---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ironhorse-test262-ratchet-gate.sh
entries/2026/09/28/201744Z-progress-builder-798d43.md:2026-09-28T20:17:46Z reports 906 previously covered paths lost because the classifier changed, while the authorization requires zero loss before merge. Add a deterministic pinned-baseline comparator that records coverage, rejects classifier-incompatible measurements, and emits a machine-readable pass/fail gate for the watcher to consume.
