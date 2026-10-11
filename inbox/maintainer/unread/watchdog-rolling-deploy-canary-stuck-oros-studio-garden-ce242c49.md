from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-11T00:08:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 250
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-11T00:08:02Z
---
WATCHDOG notice — occurrence #250 (first seen 2026-10-09T06:59:03Z, latest 2026-10-11T00:08:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 250 times; this is ONE
coalesced notice that updates in place, not 250 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 592f66b2a04f 20 min ago
but still reports deployed_sha 2972b8d8284bdbdd2b0ab610e604bb9b45b4a649. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
