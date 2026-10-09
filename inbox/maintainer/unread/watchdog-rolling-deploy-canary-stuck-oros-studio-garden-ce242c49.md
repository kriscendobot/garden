from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-09T16:29:06Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 163
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-09T16:29:06Z
---
WATCHDOG notice — occurrence #163 (first seen 2026-10-09T06:59:03Z, latest 2026-10-09T16:29:06Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 163 times; this is ONE
coalesced notice that updates in place, not 163 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to fad05c578989 324 min ago
but still reports deployed_sha 2e8aedf5363a19f701f4fafa8fd6170bd2240138. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden2-5bcdff64)
