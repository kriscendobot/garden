from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-10T23:05:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 249
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-10T23:05:02Z
---
WATCHDOG notice — occurrence #249 (first seen 2026-10-09T06:59:03Z, latest 2026-10-10T23:05:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 249 times; this is ONE
coalesced notice that updates in place, not 249 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 2972b8d8284b 162 min ago
but still reports deployed_sha d1b7c3337c196b83162de92fc2b5ad11057b4c06. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
