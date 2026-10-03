---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
scripts/jobs/cursor-set.sh:124 turns a receive-side push rejection into a stalled cursor; at 21:25:05 the issue inbox could not advance `issues/kriscendobot-garden` after `failed to push some refs`. Add deterministic post-rejection remote verification and safe reconciliation/retry when the cursor content is already present or the remote merely moved; otherwise preserve the actionable rejection diagnostic and raise a deduplicated repair alert.
