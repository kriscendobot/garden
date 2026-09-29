from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-29T01:44:03Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-29T01:44:03Z
last_seen: 2026-09-29T01:44:03Z
---
Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to b89b800a91d9 21 min ago
but still reports deployed_sha 894f26756377be6837b1d613f849cb2c7d2d1b1c. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
