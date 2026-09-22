---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

handler-timeout: 7200

# shepherd (auto: approved but CI needs work) on kriscendobot/minion.town PR #87

A trusted maintainer APPROVED this PR (the approval is still effective
even if the head has advanced), but it is not yet mergeable/green.
The approval RECONCILER caught an approval the
event watcher missed and, exactly as the event finalize path does when
a PR is approved-but-not-ready, dispatched a **shepherd** (drive CI to
green) rather than forcing the merge. Map: **shepherd** -> drive CI to green.

PR: https://github.com/kriscendobot/minion.town/pull/87
Head: kriscendobot/minion.town (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd->fixer auto-chain. Re-fetch the live state before acting; this
job was minted from a status read at post time. Once green, the conductor
is posted by the event watcher / a later reconcile tick. Never link to
upstream agoric/agoric-sdk.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T01:01:32Z
