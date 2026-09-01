---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Stamp non-mechanical attention directives with `handler-budget-role: review`, matching whole-review feedback jobs. PR #1059 attention routing deterministically hit the generic 2400s wall; these directives re-fetch and assess substantive feedback, so the existing 7200s review budget avoids repeat timeout/reap cycles.
