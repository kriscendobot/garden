---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:5451 lets concurrent REST calls pass before the primary-quota latch is written; at 19:35:34–19:35:35 two comment sources were refused. Serialize gh-api admission with the cooldown lock, re-check the all-API marker under it, and latch primary-quota failures before releasing it so sibling watchers skip without another doomed request.
