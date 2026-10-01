from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T22:47:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-01T22:08:01Z
last_seen: 2026-10-01T22:47:03Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-01T22:08:01Z, latest 2026-10-01T22:47:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to e02555bca7f4 21 min ago
but still reports deployed_sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
