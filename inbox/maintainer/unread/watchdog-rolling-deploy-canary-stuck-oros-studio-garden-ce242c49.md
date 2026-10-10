from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-10T17:23:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 193
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-10T17:23:03Z
---
WATCHDOG notice — occurrence #193 (first seen 2026-10-09T06:59:03Z, latest 2026-10-10T17:23:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 193 times; this is ONE
coalesced notice that updates in place, not 193 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 6021144b5fbf 20 min ago
but still reports deployed_sha 61a16d250ef165719ca2307e3300655f113af206. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
