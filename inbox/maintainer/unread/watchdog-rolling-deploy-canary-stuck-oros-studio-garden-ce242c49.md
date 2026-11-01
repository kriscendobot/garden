from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-01T06:29:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-11-01T06:29:02Z
last_seen: 2026-11-01T06:29:03Z
---
Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 7a27474163b7 66 min ago
but still reports deployed_sha d45a2d77f58a88a5fb4118c6e7403317f8f9bcd8. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
