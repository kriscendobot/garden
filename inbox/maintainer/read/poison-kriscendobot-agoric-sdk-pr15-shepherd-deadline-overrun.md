from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-12T22:33:07Z
poison_base: kriscendobot-agoric-sdk-pr15-shepherd
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-12T22:33:07Z
last_seen: 2026-07-12T22:33:07Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-agoric-sdk-pr15-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: kriscendobot-agoric-sdk-pr15-shepherd

--- original job body ---
# shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15

CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.

PR: https://github.com/kriscendobot/agoric-sdk/pull/15
Head: kriscendobot/agoric-sdk (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd→fixer auto-chain. Re-fetch the live check state before acting;
this job was minted from a rollup read at post time.

<!-- garden-deadline-overrun: 1 -->
