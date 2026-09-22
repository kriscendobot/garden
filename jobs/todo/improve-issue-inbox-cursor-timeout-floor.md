---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
Cursor reads repeatedly time out with rc=124 despite the helper’s intended lock-wait handling. Derive and enforce the cursor-stage timeout floor from the actual cursor lock wait (including grace), preventing environment overrides from guillotining the helper before it can return the quiet temporary-unavailable result.
