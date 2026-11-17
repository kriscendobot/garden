from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T08:24:33Z
doom_base: endojs-endo-but-for-bots-pr1560-shepherd
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T08:24:33Z
last_seen: 2026-11-17T08:24:33Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1560-shepherd; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1560-shepherd) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr1560-shepherd

--- original job body ---
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
