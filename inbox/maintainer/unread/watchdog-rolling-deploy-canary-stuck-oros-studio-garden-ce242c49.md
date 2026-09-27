from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-27T22:40:13Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 813
first_seen: 2026-09-25T03:17:02Z
last_seen: 2026-09-27T22:40:13Z
---
WATCHDOG notice — occurrence #813 (first seen 2026-09-25T03:17:02Z, latest 2026-09-27T22:40:13Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 813 times; this is ONE
coalesced notice that updates in place, not 813 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 18f02975bc8c 84 min ago
but still reports deployed_sha 586aee8196b4c03fdb68c7d2368856cb756de4eb. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
