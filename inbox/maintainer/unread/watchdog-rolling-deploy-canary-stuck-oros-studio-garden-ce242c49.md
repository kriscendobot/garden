from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-11T19:05:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 435
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-11T19:05:03Z
---
WATCHDOG notice — occurrence #435 (first seen 2026-10-09T06:59:03Z, latest 2026-10-11T19:05:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 435 times; this is ONE
coalesced notice that updates in place, not 435 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to db962f139798 380 min ago
but still reports deployed_sha 592f66b2a04fbb9c4c1905809f2a2172d0fa820c. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
