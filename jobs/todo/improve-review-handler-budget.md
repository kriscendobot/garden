---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Ensure every review-directive job includes a leading `handler-budget-role: review` (and test the emitted board body). The captured PR #1046 review job lacked it and deterministically hit the 2400s wall instead of the configured 7200s review budget.
