from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-05T05:59:04Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 216
first_seen: 2026-11-01T06:29:02Z
last_seen: 2026-11-05T05:59:04Z
---
WATCHDOG notice — occurrence #216 (first seen 2026-11-01T06:29:02Z, latest 2026-11-05T05:59:04Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 216 times; this is ONE
coalesced notice that updates in place, not 216 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 1dd5dbe16cab 26 min ago
but still reports deployed_sha f4dcb3c044e63f064f0b6b00a88432ec402b99f5. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
