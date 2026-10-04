---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the ensureDirectory race on kriscendobot/minion.town#148 (and require activate)

Maintainer (kriskowal, 2026-10-04): "Go ahead and merge anything that is ready on the minion.town repository." This PR becomes merge-ready after a named small fix plus the maintainer re-review (panel summary minion-town-pr148-137-panel-summary-20261004).

https://github.com/kriscendobot/minion.town/pull/148 (confined inference via the Claude CLI backend), head 7c08ffa.
1. Must-fix: has-then-make race in ensureDirectory (claude-guest-bridge.ts:145, saboteur). Daemon makeDirectory overwrites, so two concurrent first creates can orphan a child binding (quota under-count; removeChild then silently does nothing). Memoize per path; add a concurrency test.
2. Make activate required (a store that omits it currently skips the pending gate); add a test.
Push with safe-push-pr-head.sh; drive CI green. No new gauntlet. Do not touch the #149 root-socket relay item (maintainer decision). Report the commits so the maintainer can review 533aabb..new head.
