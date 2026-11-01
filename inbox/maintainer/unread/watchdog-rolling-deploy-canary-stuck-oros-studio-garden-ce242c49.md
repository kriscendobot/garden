from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-01T07:29:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 5
first_seen: 2026-11-01T06:29:02Z
last_seen: 2026-11-01T07:29:02Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-01T06:29:02Z, latest 2026-11-01T07:29:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 796949fbe1ac 56 min ago
but still reports deployed_sha d45a2d77f58a88a5fb4118c6e7403317f8f9bcd8. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
