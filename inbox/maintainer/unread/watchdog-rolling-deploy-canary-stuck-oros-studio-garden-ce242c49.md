from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-08T19:02:04Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 17
first_seen: 2026-10-08T17:47:04Z
last_seen: 2026-10-08T19:02:04Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-10-08T17:47:04Z, latest 2026-10-08T19:02:04Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to c185ee5f97bc 21 min ago
but still reports deployed_sha 2e8aedf5363a19f701f4fafa8fd6170bd2240138. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden2-5bcdff64)
