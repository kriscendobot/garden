from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-05T11:20:04Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 217
first_seen: 2026-11-01T06:29:02Z
last_seen: 2026-11-05T11:20:04Z
---
WATCHDOG notice — occurrence #217 (first seen 2026-11-01T06:29:02Z, latest 2026-11-05T11:20:04Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 217 times; this is ONE
coalesced notice that updates in place, not 217 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to afd9d789d84b 21 min ago
but still reports deployed_sha 2c082b9acbc8684ec3a0ff42a398a31ce1978ee1. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
