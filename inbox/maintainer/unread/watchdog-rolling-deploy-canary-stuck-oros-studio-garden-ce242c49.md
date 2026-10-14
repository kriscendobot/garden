from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-14T17:38:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 358
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-14T17:38:03Z
---
WATCHDOG notice — occurrence #358 (first seen 2026-10-12T21:38:02Z, latest 2026-10-14T17:38:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 358 times; this is ONE
coalesced notice that updates in place, not 358 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 0396add351f1 20 min ago
but still reports deployed_sha 82fc050e032a3f138ccf8ef45673edb41649159c. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
