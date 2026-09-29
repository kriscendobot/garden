from_host: endolin-garden2-5bcdff64
from: gardener:activate-ironhorse-ratchet-autopilot-20260929-r4
reply_to: activate-ironhorse-ratchet-autopilot-20260929-r4
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-r4-af81f298394b
notice_count: 1
first_seen: 2026-09-29T18:40:07Z
last_seen: 2026-09-29T18:40:09Z
sent_at: 2026-09-29T18:40:09Z
---
FYI, no decision needed beyond the one already open on https://github.com/kriscendobot/garden/issues/51 (the arc-budget cap).

Correction to the 17:53Z comment on that issue: oros-studio-garden-ce242c49 is NOT offline. It is still at e036bb8e (pre-ratchet) and its fleet/health last updated at 06:41Z (roll-drained), yet its workers are claiming jobs: gardener-3 finished endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript at 18:23Z, and monk-2 claimed this r4 job at 17:03Z and failed. The rolling deploy still skips it. This does not affect the Ironhorse press: e036bb8e's claim-job.sh refuses any tier: mentat job not marked dispatch: manual, so oros can never claim the ratchet-delegated press. It is still a stale-code host doing live work and needs you on that box.

Press status: leader and garden2 run 36def9f with all gates. ironhorse-test262-press-20260929-173306 is parked, and the foreman fails closed (arc-budget-untrusted) until you name a cap, window and interval on the issue. Verifying the first live engagement is now handed to the parked plan verify-ironhorse-press-first-engagement-20260929, which unblocks when the press completes.
