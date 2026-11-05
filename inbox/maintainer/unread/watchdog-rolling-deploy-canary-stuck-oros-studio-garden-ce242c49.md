from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-05T12:23:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 228
first_seen: 2026-11-01T06:29:02Z
last_seen: 2026-11-05T12:23:02Z
---
WATCHDOG notice — occurrence #228 (first seen 2026-11-01T06:29:02Z, latest 2026-11-05T12:23:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 228 times; this is ONE
coalesced notice that updates in place, not 228 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to dd3e6bc6edfd 20 min ago
but still reports deployed_sha 2c082b9acbc8684ec3a0ff42a398a31ce1978ee1. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
