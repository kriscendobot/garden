---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-07-12T04:53:32Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-12T04:53:32Z
---

# shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704

CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/704
Head: endojs/endo-but-for-bots (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd→fixer auto-chain. Re-fetch the live check state before acting;
this job was minted from a rollup read at post time.
