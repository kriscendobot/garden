from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T09:17:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 67
first_seen: 2026-10-01T05:20:02Z
last_seen: 2026-10-01T09:17:03Z
---
WATCHDOG notice — occurrence #67 (first seen 2026-10-01T05:20:02Z, latest 2026-10-01T09:17:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 67 times; this is ONE
coalesced notice that updates in place, not 67 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to c5416eb373bc 201 min ago
but still reports deployed_sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
