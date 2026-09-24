from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-24T22:35:02Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-24T22:35:02Z
last_seen: 2026-09-24T22:35:02Z
---
Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to a7c06dd82175 21 min ago
but still reports deployed_sha 268455dca8646a5be908bf5f000da562564810f0. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
