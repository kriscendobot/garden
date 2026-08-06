---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-07-12T16:43:04Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-12T16:43:04Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

# shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124

CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/124
Head: endojs/endo-but-for-bots (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd→fixer auto-chain. Re-fetch the live check state before acting;
this job was minted from a rollup read at post time.

<!-- garden-deadline-overrun: 1 -->
