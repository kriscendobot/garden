from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-25T20:35:05Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 311
first_seen: 2026-09-25T03:17:02Z
last_seen: 2026-09-25T20:35:05Z
---
WATCHDOG notice — occurrence #311 (first seen 2026-09-25T03:17:02Z, latest 2026-09-25T20:35:05Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 311 times; this is ONE
coalesced notice that updates in place, not 311 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to e5ce93779a62 402 min ago
but still reports deployed_sha 917115c9b77234e4a05db68e8c5111fe6e5b305f. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
