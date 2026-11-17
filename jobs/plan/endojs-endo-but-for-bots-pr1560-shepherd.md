---
gate: go-ahead
priority: normal
role: shepherd
tier: minion
handler-timeout: 10800
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-17T08:23:58Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-17T08:23:58Z
---

---
posted_at: 2026-11-17T05:46:32Z
role: shepherd
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

handler-timeout: 10800

# shepherd (auto: approved but CI needs work) on endojs/endo-but-for-bots PR #1560

A trusted maintainer APPROVED this PR (the approval is still effective
even if the head has advanced), but it is not yet mergeable/green.
The approval RECONCILER caught an approval the
event watcher missed and, exactly as the event finalize path does when
a PR is approved-but-not-ready, dispatched a **shepherd** (drive CI to
green) rather than forcing the merge. Map: **shepherd** -> drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/1560
Head: endojs/endo-but-for-bots (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd->fixer auto-chain. Re-fetch the live state before acting; this
job was minted from a status read at post time. Once green, the conductor
is posted by the event watcher / a later reconcile tick. Never link to
upstream agoric/agoric-sdk.
