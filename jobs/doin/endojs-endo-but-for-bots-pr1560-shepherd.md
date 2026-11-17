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

<!-- garden-transient-elapsed: kind=exit0 through=0 values=5932 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-17T07:53:23Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-17T08:14:06Z
