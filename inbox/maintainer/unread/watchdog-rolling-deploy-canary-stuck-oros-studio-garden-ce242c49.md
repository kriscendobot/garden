from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-14T10:02:04Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 356
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-14T10:02:04Z
---
WATCHDOG notice — occurrence #356 (first seen 2026-10-12T21:38:02Z, latest 2026-10-14T10:02:04Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 356 times; this is ONE
coalesced notice that updates in place, not 356 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 8eb6caecffd1 89 min ago
but still reports deployed_sha 320cfbed282856094ef3a4f88f6ea556f3d71d9d. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
