from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-13T14:08:09Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 238
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-13T14:08:09Z
---
WATCHDOG notice — occurrence #238 (first seen 2026-10-12T21:38:02Z, latest 2026-10-13T14:08:09Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 238 times; this is ONE
coalesced notice that updates in place, not 238 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 8fd22da4bfb6 80 min ago
but still reports deployed_sha bdc2943ce1f4b19ef3e28d1a92426544a762da55. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
