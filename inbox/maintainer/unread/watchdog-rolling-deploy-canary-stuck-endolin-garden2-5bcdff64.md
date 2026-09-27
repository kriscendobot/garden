from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-27T03:15:38Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-27T03:15:38Z
last_seen: 2026-09-27T03:15:38Z
---
Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to 1570aa85a47b 24 min ago
but still reports deployed_sha ab66fece68f403b0de02e7ca5949d46362b34b16. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
