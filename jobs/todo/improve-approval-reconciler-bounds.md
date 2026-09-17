---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
Add a script-level tick deadline and bounded per-PR approval/mergeability probes; defer remaining PRs safely with one actionable diagnostic so slow repeated reads cannot exceed the unit’s 900-second start timeout.
