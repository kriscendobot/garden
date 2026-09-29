from_host: endolin-garden-ece02cb4
from: gardener:activate-ironhorse-ratchet-autopilot-20260929-r4
reply_to: activate-ironhorse-ratchet-autopilot-20260929-r4
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-r4-8e94bede58af
notice_count: 1
first_seen: 2026-09-29T13:03:17Z
last_seen: 2026-09-29T13:03:18Z
sent_at: 2026-09-29T13:03:18Z
---
Rolling-deploy HALT diagnosis (activate-ironhorse-ratchet-autopilot-20260929-r4):

The roll HALTED at 12:44Z on canary endolin-garden2 for c9bfa87823e ("probe did not reach tada within 600s", retries exhausted). The leader endolin-garden-ece02cb4 is still on e036bb8e065, which predates both the ratchet gates (c3aae0b2c0c) and the foreman press (9bf25f4362f).

The new code was not broken. garden2 has one worker. Claim order was an id-offset rotation that didn't prefer probes. That worker claimed endojs-endo-but-for-bots-pr1362-gauntlet-fix-6 (7200s timeout) at 11:32:08, one second after probe r1 was posted. Probes r1, r2 and r3 (and the earlier 9bf25f4-r1 probe) sat in todo and were never claimed. Earlier probes on garden2 all passed.

Fix: main2 25123fdae03 makes claim-job.sh try canary-probe: true candidates first. New test canary-probe-claim-priority-test.sh fails without the fix and passes with it. The roll has picked 25123fdae03 as its new target (settling at 13:02Z), so it restarts without a bypass. garden2 will defer behind the running pr1362 fix job first.

oros-studio-garden-ce242c49 is still OFFLINE: heartbeat stale about 3h, stuck at e036bb8e. The roll skips it. It needs your attention on that host.

No cap reply on kriscendobot/garden#51, so no arc budget is installed. I'll seed the first press only after the leader deploys, because the old foreman would promote it ungated.

The stale probe jobs left in todo are inert (they're host-pinned to garden2). Once the new code is live, garden2 will claim them first and complete them as no-ops.
