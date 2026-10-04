from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-04T07:35:02Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-10-04T07:35:02Z
last_seen: 2026-10-04T07:35:02Z
---
Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to 9d25d153e73e 20 min ago
but still reports deployed_sha e18494cfb29b65a072ad15acdfc988889a0141ce. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
