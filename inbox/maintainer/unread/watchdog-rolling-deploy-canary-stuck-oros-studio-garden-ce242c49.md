from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-09T14:29:04Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 123
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-09T14:29:04Z
---
WATCHDOG notice — occurrence #123 (first seen 2026-10-09T06:59:03Z, latest 2026-10-09T14:29:04Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 123 times; this is ONE
coalesced notice that updates in place, not 123 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to fad05c578989 204 min ago
but still reports deployed_sha 2e8aedf5363a19f701f4fafa8fd6170bd2240138. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden2-5bcdff64)
