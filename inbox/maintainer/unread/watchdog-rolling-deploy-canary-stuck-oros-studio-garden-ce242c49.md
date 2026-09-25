from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-25T13:26:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 175
first_seen: 2026-09-25T03:17:02Z
last_seen: 2026-09-25T13:26:03Z
---
WATCHDOG notice — occurrence #175 (first seen 2026-09-25T03:17:02Z, latest 2026-09-25T13:26:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 175 times; this is ONE
coalesced notice that updates in place, not 175 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 46e100b66419 336 min ago
but still reports deployed_sha 917115c9b77234e4a05db68e8c5111fe6e5b305f. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
