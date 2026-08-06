---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

handler-timeout: 7200

# shepherd (auto: approved but CI needs work) on endojs/endo-but-for-bots PR #892

A trusted maintainer APPROVED this PR on its CURRENT head, but it is not
yet mergeable/green. The approval RECONCILER caught an approval the
event watcher missed and, exactly as the event finalize path does when
a PR is approved-but-not-ready, dispatched a **shepherd** (drive CI to
green) rather than forcing the merge. Map: **shepherd** -> drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/892
Head: endojs/endo-but-for-bots (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd->fixer auto-chain. Re-fetch the live state before acting; this
job was minted from a status read at post time. Once green, the conductor
is posted by the event watcher / a later reconcile tick. Never link to
upstream agoric/agoric-sdk.
