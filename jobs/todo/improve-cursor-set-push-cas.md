---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
Classify ordinary non-fast-forward journal push rejections as CAS contention and retry/reconcile them, instead of surfacing “failed to push some refs” as a definite repair-only cursor failure. Keep authentication, permissions, and server-side rejections loud; add a fixture for this push diagnostic.
