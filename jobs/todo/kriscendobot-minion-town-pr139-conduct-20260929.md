---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct kriscendobot/minion.town PR #139 to merge

https://github.com/kriscendobot/minion.town/pull/139 — "fix(deploy): endo daemon probes must not auto-start a stray daemon".
kriskowal APPROVED (review 5358570484); PR is open, non-draft, MERGEABLE, and the
`test (typecheck + vitest)` run on head 6a3555dd is green. The review's only other
ask (proxy/mentat screening of minion.town PRs) is tracked separately in job
`design-minion-town-pr-screening-by-proxy` and does not gate this merge.
Re-verify mergeability + checks, then merge and run any minion.town post-merge
production deploy validation the conductor role prescribes.
